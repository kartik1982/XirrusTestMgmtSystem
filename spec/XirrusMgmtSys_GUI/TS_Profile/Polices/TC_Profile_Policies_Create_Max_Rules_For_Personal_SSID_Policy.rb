require_relative "../local_lib/policies_lib.rb"
########################################################################################################################################################
#############TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of rules for policy type - PERSONAL SSID POLICY###################
########################################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of rules for policy type - PERSONAL SSID POLICY **********" do
	
	include_examples "delete all profiles from the grid"

	profile_name = "Test profile for Policies tab MAX RULE NUMBER"
	profile_descriptiion = "Profile description for : " + profile_name
	

	include_examples "create profile from header menu", profile_name, profile_descriptiion, false

	(1..25).each do
	    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Personal SSID Policy", "Personal SSID Policy", "", "", "firewall", rule_name, true, "allow", "2", "ANY", "ANY", "Any", "Any", true, "DSCP", "", ""
	    include_examples "search for rule and verify it", rule_name, "firewall", "allow", "2", "ANY", "ANY", "Any", "Any", true, false, false, ""
	end
	include_examples "verify max 25 rules added for policy", profile_name, "Personal SSID Policy", "Personal SSID Policy", 25, 0, 0

end