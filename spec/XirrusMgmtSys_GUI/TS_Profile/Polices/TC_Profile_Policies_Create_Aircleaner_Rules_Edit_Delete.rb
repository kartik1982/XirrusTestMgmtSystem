require_relative "../local_lib/policies_lib.rb"
#################################################################################################################################
###############TEST CASE: Test the Profile - POLICIES TAB - Create AirCleaner rules - EDIT and DELETE############################
#################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - Create AirCleaner rules - EDIT and DELETE **********" do

	profile_name = "Test profile for Policies tab - AIRCLEANER - EDIT and DELETE"
	profile_descriptiion = "Profile description for : " + profile_name
	

  include_examples "delete all profiles from the grid"
	include_examples "create profile from header menu", profile_name, profile_descriptiion, false

	rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	protocol = UTIL.random_firewall_protocol
	port = UTIL.random_firewall_port
	source = UTIL.random_firewall_source
	destination = UTIL.random_firewall_destination

	include_examples "create a rule for any policy", "Global Policy", "test name", "", "",  "firewall", rule_name, true, "block", "2", protocol, port, source, destination, true, "QoS", "", ""
	include_examples "search for rule and verify it", rule_name, "firewall", "block", "2", protocol, port, source, destination, true, false, false, ""	

  include_examples "create a rule for any policy", "Global Policy", "test name", "", "", "aircleaner", "", "", "", "", "", "", "", "", "", "", "", ""
	include_examples "search for aircleaner rules and verify them"

	include_examples "save the profile"
	include_examples "delete aircleaner rules all", profile_name, 14, 13
	include_examples "search for rule and verify it", rule_name, "firewall", "block", "2", protocol, port, source, destination, true, false, false, ""	

	include_examples "create a rule for any policy", "Global Policy", "test name", "", "", "aircleaner", "", "", "", "", "", "", "", "", "", "", "", ""
	include_examples "save the profile"
	include_examples "delete rule by name", "Air-cleaner-Mcast.2", "firewall", false
	include_examples "delete rule by name", "Air-cleaner-Bcast.4", "firewall", false
	include_examples "delete aircleaner rules all", profile_name, 12, 11
	include_examples "search for rule and verify it", rule_name, "firewall", "block", "2", protocol, port, source, destination, true, false, false, ""	
end