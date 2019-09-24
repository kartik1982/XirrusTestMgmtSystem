require_relative "../local_lib/policies_lib.rb"
require_relative "../local_lib/profile_lib.rb"
#################################################################################################################################
###############TEST CASE: Test the Profile - POLICIES TAB - Create SSID Firewall rules - Source and Destination on DEVICE#######

describe "********** TEST CASE: Test the Profile - POLICIES TAB - Create SSID Firewall rules - Source and Destination on DEVICE **********" do

	include_examples "delete all profiles from the grid"

	profile_name = "Test profile for Policies tab SSID Firewall Rules - DEVICE as Source and Destination"
	profile_descriptiion = "Profile description for : " + profile_name
	
	include_examples "create a profile and an ssid inside that profile", profile_name, profile_descriptiion, false, "SSID Policy"

	include_examples "go to profile", profile_name
	for rule_source_and_destination in ["Access Point",  "Car", "Desktop", "Game", "Notebook", "Phone", "Player", "Tablet", "Watch"] do ######## "Appliance",
		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
    	include_examples "create a rule for any policy", "SSID Policy", "SSID Policy", "", "", "firewall", rule_name, true, "allow", "3", "ANY", "ANY", "Device", "Device", false, "", "", "", rule_source_and_destination, rule_source_and_destination
    	include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY", "ANY", "Device", "Device", true, false, false, ""
    	include_examples "verify that the profile is properly saved"
    end
    for traffic_shaping_options in ["QoS", "DSCP", "Limit Traffic"] do
   		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
   		include_examples "create a rule for any policy", "SSID Policy", "SSID Policy", "", "", "firewall", rule_name, true, "allow", "2", "ANY", "ANY", "Device", "Device", true, traffic_shaping_options, "", "", "Car", "Car"
   		include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY", "ANY", "Device", "Device", true, false, false, ""
   		include_examples "verify that the profile is properly saved"
   	end
  	rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
   	include_examples "create a rule for any policy", "SSID Policy", "SSID Policy", "", "", "firewall", rule_name, true, "allow", "3", "ANY", "ANY", "Device", "Device", true, traffic_shaping_options, "", "", "Appliance", "Appliance"
   	include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY", "ANY", "Device", "Device", true, false, false, ""
   	include_examples "verify that the profile is properly saved"
   	rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
   	include_examples "create a rule for any policy", "SSID Policy", "SSID Policy", "", "", "firewall", rule_name, true, "allow", "2", "TCP", "HTTP", "Device", "Device", true, "", "", "", "Phone", "Access Point"
   	include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3",  "TCP", "HTTP", "Device", "Device", true, false, false, ""
   	include_examples "verify that the profile is properly saved"



end