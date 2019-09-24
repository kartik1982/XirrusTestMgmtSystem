require_relative "../local_lib/policies_lib.rb"
##########################################################################################################################################################
###################TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of rules for policy type - SSID POLICY########################
##########################################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of rules for policy type - SSID POLICY **********" do
	
	include_examples "delete all profiles from the grid"

	profile_name = "Test profile for Policies tab MAX RULE NUMBER"
	profile_descriptiion = "Profile description for : " + profile_name
	

	include_examples "create a profile and an ssid inside that profile", profile_name, profile_descriptiion, false, "SSID Policy"

	(1..25).each do
		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "SSID Policy", "SSID Policy", "", "", "firewall", rule_name, true, "allow", "2", "ANY", "ANY", "Any", "Any", true, "QoS", "", ""
	    include_examples "search for rule and verify it", rule_name, "firewall", "allow", "2", "ANY", "ANY", "Any", "Any", true, false, false, ""
	end	
	include_examples "verify max 25 rules added for policy", profile_name, "SSID Policy", "SSID Policy", 25, 0, 0

end