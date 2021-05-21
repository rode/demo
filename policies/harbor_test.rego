package rode.demo.harbor

import data.rode.demo.util.disc_occurrences
import data.rode.demo.util.vuln_occurrences

harbor_note := "projects/rode/notes/harbor"

test_no_data {
	not pass with input as {}
}

test_no_occurrences {
	not pass with input as {"occurrences": []}
}

test_vuln_no_discovery {
	not pass with input as {"occurrences": vuln_occurrences(harbor_note, "HIGH", 1)}
}

test_no_vuln_scan {
	pass with input as {"occurrences": disc_occurrences(harbor_note, "FINISHED_SUCCESS", 1)}
}

test_high_vuln_below_threshold {
	occurrences := array.concat(disc_occurrences(harbor_note, "FINISHED_SUCCESS", 1), vuln_occurrences(harbor_note, "HIGH", 2))
	pass with input as {"occurrences": occurrences}
}

test_high_vuln_above_threshold {
	occurrences := array.concat(disc_occurrences(harbor_note, "FINISHED_SUCCESS", 1), vuln_occurrences(harbor_note, "HIGH", 3))
	not pass with input as {"occurrences": occurrences}
}

test_medium_vuln_above_threshold {
	occurrences := array.concat(disc_occurrences(harbor_note, "FINISHED_SUCCESS", 1), vuln_occurrences(harbor_note, "MEDIUM", 11))
	not pass with input as {"occurrences": occurrences}
}

test_low_vuln_above_threshold {
	occurrences := array.concat(disc_occurrences(harbor_note, "FINISHED_SUCCESS", 1), vuln_occurrences(harbor_note, "LOW", 11))
	not pass with input as {"occurrences": occurrences}
}

test_mix_vulns_pass {
	discovery := disc_occurrences(harbor_note, "FINISHED_SUCCESS", 1)
	low := vuln_occurrences(harbor_note, "LOW", 5)
	medium := vuln_occurrences(harbor_note, "MEDIUM", 5)
	high := vuln_occurrences(harbor_note, "HIGH", 1)
	occurrences := array.concat(array.concat(discovery, low), array.concat(medium, high))

	pass with input as {"occurrences": occurrences}
}

test_mix_vulns_fail {
	discovery := disc_occurrences(harbor_note, "FINISHED_SUCCESS", 1)
	low := vuln_occurrences(harbor_note, "LOW", 11)
	medium := vuln_occurrences(harbor_note, "MEDIUM", 5)
	high := vuln_occurrences(harbor_note, "HIGH", 3)
	occurrences := array.concat(array.concat(discovery, low), array.concat(medium, high))

	not pass with input as {"occurrences": occurrences}
}
