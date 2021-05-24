package rode.demo.tfsec

note_name := "projects/rode/notes/tfsec"

pass {
	count(violation_count) == 0
}

violation_count[v] {
	violations[v].pass == false
}

tfsec_scan_finished[o] {
	input.occurrences[i].noteName == note_name
	input.occurrences[i].kind == "DISCOVERY"
	input.occurrences[i].discovered.discovered.analysisStatus == "FINISHED_SUCCESS"
	o := input.occurrences[i]
}

tfsec_scan_vulnerability_medium[o] {
	input.occurrences[i].noteName == note_name
	input.occurrences[i].kind == "VULNERABILITY"
	input.occurrences[i].vulnerability.effectiveSeverity == "MEDIUM"
	o := input.occurrences[i]
}

tfsec_scan_vulnerability_high[o] {
	input.occurrences[i].noteName == note_name
	input.occurrences[i].kind == "VULNERABILITY"
	input.occurrences[i].vulnerability.effectiveSeverity == "HIGH"
	o := input.occurrences[i]
}

violations[result] {
	finished := tfsec_scan_finished
	pass := count(finished) >= 1
	result := {
		"pass": pass,
		"id": "tfsec_scan_completed",
		"name": "tfsec Scan",
		"description": "Verify tfsec scan completed",
		"message": sprintf("tfsec scanned Terraform source code %v times.", [count(finished)]),
	}
}

violations[result] {
	max := 5
	v := tfsec_scan_vulnerability_medium
	c := count(v)
	pass := c <= max
	result := {
		"pass": pass,
		"id": "tfsec_scan_vulnerability_medium",
		"name": "tfsec medium severity vulnerability count",
		"description": "Check that the number of medium severity vulnerabilities is below a threshold",
		"message": sprintf("tfsec scan found %v medium severity vulnerabilities (max: %v)", [c, max]),
	}
}

violations[result] {
	max := 2
	v := tfsec_scan_vulnerability_high
	c := count(v)
	pass := c <= max
	result := {
		"pass": pass,
		"id": "tfsec_scan_vulnerability_high",
		"name": "tfsec high severity vulnerability count",
		"description": "Check that the number of high severity vulnerabilities is below a threshold",
		"message": sprintf("tfsec scan found %v high severity vulnerabilities (max: %v)", [c, max]),
	}
}
