require_relative "../local_lib/policies_lib.rb"
####################################################################################################################
#################TEST CASE: Test the Profile - POLICIES TAB - AOS LIGHT - APPCON CREATE FIREWALL POLICIES##########
####################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - AOS LIGHT - APPCON CREATE FIREWALL POLICIES **********" do

	include_examples "delete all profiles from the grid"

	profile_name = "Test profile for Policies tab AOS LIGHT - APPCON - " + UTIL.ickey_shuffle(4)
	profile_descriptiion = "Profile description for : " + profile_name

	include_examples "create a profile and an ssid inside that profile", profile_name, profile_descriptiion, false, "SSID"

	    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Global Policy", "test name", "", "","firewall", rule_name, true, "block", "2", "ANY", "ANY", "Any", "Any", true, "QoS", "", ""
		include_examples "search for rule and verify it", rule_name, "firewall", "block", "2",  "ANY", "ANY", "Any", "Any", true, false, false, ""

		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "SSID Policy", "SSID", "", "", "firewall", rule_name, true, "allow", "3", "ANY-IP", "biff", "IP Address", "GIG", true, "DSCP", "", ""
	    include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY-IP", "biff", "IP Address", "GIG", true, false, false, ""
	    include_examples "search for policy and delete it", "SSID Policy", "SSID"

		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Personal SSID Policy", "test name", "", "", "firewall", rule_name, true, "allow", "3", "ANY", "ANY", "GIG", "Any", true, "Limit Traffic", "200", ""
	    include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY", "ANY", "GIG", "Any", true, false, false, ""

	    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "User Group Policy", "UG", "", "", "firewall", rule_name, false, "allow", "3", "ANY", "ANY", "GIG", "Any", true, "Limit Traffic", "200", ""
	    include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY", "ANY", "GIG", "Any", false, false, false, ""

	    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Device Policy", "Access Point", "Access Point", "All Access Point Types", "firewall", rule_name, true, "allow", "3", "UDP", "Gopher", "Any", "GIG", true, "", "Access Point", "All Access Point Types"
	    include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "UDP", "Gopher", "Any", "GIG", true, false, false, ""
		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Device Policy", "Car", "Car", "All Car Types", "firewall", rule_name, true, "block", "2", "ICMP", "IRC", "GIG", "IAP", true, "", "Car", "All Car Types"
	    include_examples "search for rule and verify it", rule_name, "firewall", "block", "2", "ICMP", "IRC", "GIG", "IAP", true, false, false, ""
	    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Device Policy", "Desktop", "Desktop", "All Desktop Types", "firewall", rule_name, true, "allow", "3", "SRP", "HTTP", "IP Address", "IP Address", true, "", "Desktop", "All Desktop Types"
	    include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "SRP", "HTTP", "IP Address", "IP Address", true, false, false, ""
	    include_examples "search for policy and delete it", "Device Policy", "Desktop: All Desktop Types"
	    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Device Policy", "Player", "Player", "AppleTV", "firewall", rule_name, true, "block", "2", "IGMP", "UUCP", "IAP", "GIG", false, "", "Player", "AppleTV"
	    include_examples "search for rule and verify it", rule_name, "firewall", "block", "2", "IGMP", "UUCP", "IAP", "GIG", true, false, false, ""
	    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Device Policy", "Tablet", "Tablet", "Archos", "firewall", rule_name, true, "allow", "2", "UDP", "XRP", "IP Address", "IP Address", false, "", "Tablet", "Archos"
	    include_examples "search for rule and verify it", rule_name, "firewall", "allow", "2", "UDP", "XRP", "IP Address", "IP Address", true, false, false, ""
	    include_examples "search for policy and delete it", "Device Policy", "Tablet: Archos"
	    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Device Policy", "Watch", "Watch", "All Watch Types", "firewall", rule_name, true, "block", "2", "TCP", "talk", "IAP", "Any", true, "", "Watch", "All Watch Types"
	    include_examples "search for rule and verify it", rule_name, "firewall", "block", "2", "TCP", "talk", "IAP", "Any", true, false, false, ""

end
