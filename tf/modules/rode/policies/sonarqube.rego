package rode.demo.sonar1

pass {
	count(violation_count) == 0
}

violation_count[v] {
	violations[v].pass == false
}

sonar_scan_started[o] {
	startswith(input.occurrences[i].noteName, "projects/rode/notes/sonar-scan")
	input.occurrences[i].kind == "DISCOVERY"
	input.occurrences[i].discovered.discovered.analysisStatus == "SCANNING"
	o := input.occurrences[i]
}

sonar_scan_finished[t] {
	startswith(input.occurrences[i].noteName, "projects/rode/notes/sonar-scan")
	input.occurrences[i].kind == "DISCOVERY"
	input.occurrences[i].discovered.discovered.analysisStatus == "FINISHED_SUCCESS"
	t := input.occurrences[i].createTime
}

violations[result] {
	started := sonar_scan_started
	result := {
		"pass": count(started) >= 1,
		"id": "sonar_scan_started",
		"name": "SonarQube Analysis Started",
		"description": "Verify SonarQube analysis started",
		"message": "SonarQube analysis started",
	}
}

violations[result] {
	finished := sonar_scan_finished
	result := {
		"pass": count(finished) >= 1,
		"id": "sonar_scan_completed",
		"name": "SonarQube Analysis Finished",
		"description": "Verify SonarQube analysis finished successfully",
		"message": sprintf("SonarQube analysis completed at %v", finished),
	}
}
