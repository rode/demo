package rode.demo.tfsec

import data.rode.demo.util.disc_occurrences
import data.rode.demo.util.vuln_occurrences

tfsec_note := "projects/rode/notes/tfsec"

test_no_data {
	not pass with input as {}
}

test_no_occurrences {
	not pass with input as {"occurrences": []}
}

test_vuln_no_discovery {
	not pass with input as {"occurrences": vuln_occurrences(tfsec_note, "HIGH", 1)}
}

test_no_vuln_scan {
	pass with input as {"occurrences": disc_occurrences(tfsec_note, 1)}
}

test_high_vuln_below_threshold {
	occurrences := array.concat(disc_occurrences(tfsec_note, 1), vuln_occurrences(tfsec_note, "HIGH", 2))
	pass with input as {"occurrences": occurrences}
}

test_high_vuln_above_threshold {
	occurrences := array.concat(disc_occurrences(tfsec_note, 1), vuln_occurrences(tfsec_note, "HIGH", 3))
	not pass with input as {"occurrences": occurrences}
}

test_medium_vuln_above_threshold {
	occurrences := array.concat(disc_occurrences(tfsec_note, 1), vuln_occurrences(tfsec_note, "MEDIUM", 6))
	not pass with input as {"occurrences": occurrences}
}

test_mix_vulns_pass {
	discovery := disc_occurrences(tfsec_note, 1)
	medium := vuln_occurrences(tfsec_note, "MEDIUM", 5)
	high := vuln_occurrences(tfsec_note, "HIGH", 1)
	occurrences := array.concat(discovery, array.concat(medium, high))

	pass with input as {"occurrences": occurrences}
}

test_mix_vulns_fail {
	discovery := disc_occurrences(tfsec_note, 1)
	medium := vuln_occurrences(tfsec_note, "MEDIUM", 6)
	high := vuln_occurrences(tfsec_note, "HIGH", 2)
	occurrences := array.concat(discovery, array.concat(medium, high))

	not pass with input as {"occurrences": occurrences}
}
