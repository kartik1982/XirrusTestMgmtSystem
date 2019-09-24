require_relative "../local_lib/policies_lib.rb"
require_relative "../local_lib/profile_lib.rb"
#####################################################################################################################################################
###################TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of rules for policy type - USER GROUP POLICY##############
#####################################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of rules for policy type - USER GROUP POLICY **********" do

	profile_name = "Test profile for Policies tab MAX RULE NUMBER"
	profile_descriptiion = "Profile description for : " + profile_name

  include_examples "delete all profiles from the grid"
	include_examples "create profile from header menu", profile_name, profile_descriptiion, false

	for rule_source_and_destination in ["Access Point", "Car", "Desktop", "Game", "Notebook", "Phone", "Player", "Tablet", "Watch"] do
		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
    	include_examples "create a rule for any policy", "User Group Policy", "UG", "", "", "firewall", rule_name, true, "allow", "3", "ANY", "ANY", "Device", "Device", false, "", "", "", rule_source_and_destination, rule_source_and_destination
    	include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY", "ANY", "Device", "Device", true, false, false, ""
    	include_examples "verify that the profile is properly saved"
    end
    for traffic_shaping_options in ["QoS", "DSCP", "Limit Traffic"] do
   		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
   		include_examples "create a rule for any policy", "User Group Policy", "UG", "", "", "firewall", rule_name, true, "allow", "2", "ANY", "ANY", "Device", "Device", true, traffic_shaping_options, "", "", "Car", "Car"
   		include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY", "ANY", "Device", "Device", true, false, false, ""
   		include_examples "verify that the profile is properly saved"
   	end
	(1..13).each do
		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", "User Group Policy", "UG", "", "", "application", rule_name, false, "allow", "", "", "", "", "", false, "", "Games", "All Games Apps", "", ""
	    include_examples "search for rule and verify it", rule_name, "application", "allow", "7", "Games", "All Games Apps", "", "", false, false, false, ""
	end

end