package rode.demo.util

project := "projects/rode/occurrences/"

vuln_occurrences(noteName, severity, count) = x {
	ids := generate_ids(count)

	x := [occurrence |
		ids[i]
		occurrence := {
			"noteName": noteName,
			"kind": "VULNERABILITY",
			# rule results are a set, so we need a unique field to prevent those
			"name": sprintf("%s/%s", [project, uuid.rfc4122(ids[i])]),
			"vulnerability": {"effectiveSeverity": severity},
		}
	]
}

disc_occurrences(noteName, count) = x {
	ids := generate_ids(count)

	x := [occurrence |
		ids[i]
		occurrence := {
			"createTime": "",
			"noteName": noteName,
			"kind": "DISCOVERY",
			"name": sprintf("%s/%s", [project, uuid.rfc4122(ids[i])]),
			"discovered": {"discovered": {"analysisStatus": "FINISHED_SUCCESS"}},
		}
	]
}

generate_ids(count) = x {
	x := [id | numbers.range(1, count)[i]; id := sprintf("%v", [i])]
}
