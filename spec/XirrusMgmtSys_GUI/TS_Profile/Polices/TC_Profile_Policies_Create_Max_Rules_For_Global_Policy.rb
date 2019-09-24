require_relative "../local_lib/policies_lib.rb"
require_relative "../local_lib/profile_lib.rb"
############################################################################################################################################
################TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of rules for policy type - GLOBAL POLICY############
############################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of rules for policy type - GLOBAL POLICY **********" do

	profile_name = "Test profile for Policies tab MAX RULE NUMBER"
	profile_descriptiion = "Profile description for : " + profile_name
  
  include_examples "delete all profiles from the grid"
	include_examples "create a profile and an ssid inside that profile", profile_name, profile_descriptiion, false, "SSID"

	(1..10).each do
		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
		protocol = "ANY" 
		port = "ANY" 
		source = "Any" 
		destination = "Any" 

		include_examples "create a rule for any policy", "Global Policy", "Global Policy", "", "", "firewall", rule_name, true, "block", "2", protocol, port, source, destination, true, "QoS", "", ""
		include_examples "search for rule and verify it", rule_name, "firewall", "block", "2", protocol, port, source, destination, true, false, false, ""
	end
	(1..10).each do
		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
		protocol = "ANY"
		port = "ANY"
		source = "Any"
		destination = "Any"

		include_examples "create a rule for any policy", "Global Policy", "Global Policy", "", "", "firewall", rule_name, true, "allow", "3", protocol, port, source, destination, true, "QoS", "", ""
		include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", protocol, port, source, destination, true, false, false, ""
	end
	(1..5).each do
	    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Global Policy", "Global Policy", "", "", "application", rule_name, true, "block", "7", "", "", "", "", true, "", "Games", "All Games Apps"
	    include_examples "search for rule and verify it", rule_name, "application", "block", "7", "Games", "All Games Apps", "", "", true, false, false, ""
	end
	include_examples "verify max 25 rules added for policy", profile_name, "Global Policy", "Global Policy", 10, 10, 5

end