package rode.demo.harbor

pass {
	count(violation_count) == 0
}

violation_count[v] {
	violations[v].pass == false
}

harbor_scan_finished[o] {
	input.occurrences[i].noteName == "projects/rode/notes/harbor"
	input.occurrences[i].kind == "DISCOVERY"
	input.occurrences[i].discovered.discovered.analysisStatus == "FINISHED_SUCCESS"
	o := input.occurrences[i]
}

harbor_scan_last[t] {
	input.occurrences[i].noteName == "projects/rode/notes/harbor"
	input.occurrences[i].kind == "DISCOVERY"
	input.occurrences[i].discovered.discovered.analysisStatus == "FINISHED_SUCCESS"
	t := input.occurrences[i].createTime
}

harbor_scan_vulnerability_low[o] {
	input.occurrences[i].noteName == "projects/rode/notes/harbor"
	input.occurrences[i].kind == "VULNERABILITY"
	input.occurrences[i].vulnerability.effectiveSeverity == "LOW"
	o := input.occurrences[i]
}

harbor_scan_vulnerability_medium[o] {
	input.occurrences[i].noteName == "projects/rode/notes/harbor"
	input.occurrences[i].kind == "VULNERABILITY"
	input.occurrences[i].vulnerability.effectiveSeverity == "MEDIUM"
	o := input.occurrences[i]
}

harbor_scan_vulnerability_high[o] {
	input.occurrences[i].noteName == "projects/rode/notes/harbor"
	input.occurrences[i].kind == "VULNERABILITY"
	input.occurrences[i].vulnerability.effectiveSeverity == "HIGH"
	o := input.occurrences[i]
}

violations[result] {
	finished := harbor_scan_finished
	last := harbor_scan_last
	result := {
		"pass": count(finished) >= 1,
		"id": "harbor_scan_completed",
		"name": "Harbor Scan",
		"description": "Verify Harbor image scan completed",
		"message": sprintf("Harbor scanned image %v times. Last completed at %v", [count(finished), last]),
	}
}

violations[result] {
	args := {"max": 10}

	v := harbor_scan_vulnerability_low
	c := count(v)
	result := {
		"pass": c <= args.max,
		"id": "harbor_scan_vulnerability_low",
		"name": "Harbor low severity vulnerability count",
		"description": "Verify scan result low severity vulnerability result",
		"message": sprintf("Harbor scan found %v low severity vulnerabilities (max: %v)", [c, args.max]),
	}
}

violations[result] {
	args := {"max": 10}

	v := harbor_scan_vulnerability_medium
	c := count(v)
	result := {
		"pass": c <= args.max,
		"id": "harbor_scan_vulnerability_medium",
		"name": "Harbor medium severity vulnerability count",
		"description": "Verify scan result medium severity vulnerability result",
		"message": sprintf("Harbor scan found %v medium severity vulnerabilities (max: %v)", [c, args.max]),
	}
}

violations[result] {
	args := {"max": 2}
	v := harbor_scan_vulnerability_high
	c := count(v)
	result := {
		"pass": c <= args.max,
		"id": "harbor_scan_vulnerability_high",
		"name": "Harbor high severity vulnerability count",
		"description": "Verify scan result high severity vulnerability result",
		"message": sprintf("Harbor scan found %v high severity vulnerabilities (max: %v)", [c, args.max]),
	}
}
