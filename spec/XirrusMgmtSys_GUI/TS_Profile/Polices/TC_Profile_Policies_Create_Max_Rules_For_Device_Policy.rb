require_relative "../local_lib/policies_lib.rb"
############################################################################################################################################
###############TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of rules for policy type - DEVICE POLICY##############
############################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of rules for policy type - DEVICE POLICY **********" do
	
	include_examples "delete all profiles from the grid"

	profile_name = "Test profile for Policies tab MAX RULE NUMBER"
	profile_descriptiion = "Profile description for : " + profile_name
	

	include_examples "create profile from header menu", profile_name, profile_descriptiion, false

	(1..25).each do
	    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "Device Policy", "Car", "Car", "All Car Types", "application", rule_name, true, "block", "7", "ICMP", "IRC", "Any", "Any", true, "", "Games", "All Games Apps"
	    include_examples "search for rule and verify it", rule_name, "application", "block", "7", "Games", "All Games Apps", "", "", true, false, false, ""	    
	end
	include_examples "verify max 25 rules added for policy", profile_name, "Device Policy", "Car", 0, 0, 25

end