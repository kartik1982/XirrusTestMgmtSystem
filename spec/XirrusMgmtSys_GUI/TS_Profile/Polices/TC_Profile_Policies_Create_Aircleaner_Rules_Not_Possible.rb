require_relative "../local_lib/policies_lib.rb"
#################################################################################################################################
###############TEST CASE: Test the Profile - POLICIES TAB - Create AirCleaner rules impossible due to not enough room#############
#################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - Create AirCleaner rules impossible due to not enough room **********" do


	profile_name = "Test profile for Policies tab - AIRCLEANER (not available)"
	profile_descriptiion = "Profile description for : " + profile_name
	
  include_examples "delete all profiles from the grid"
	include_examples "create profile from header menu", profile_name, profile_descriptiion, false

	(1..13).each do
		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
		protocol = UTIL.random_firewall_protocol
		port = UTIL.random_firewall_port
		source = UTIL.random_firewall_source
		destination = UTIL.random_firewall_destination
		include_examples "create a rule for any policy", "Global Policy", "test name", "", "",  "firewall", rule_name, true, "block", "2", protocol, port, source, destination, true, "QoS", "", ""
		include_examples "search for rule and verify it", rule_name, "firewall", "block", "2", protocol, port, source, destination, true, false, false, ""	
	end
	include_examples "verify scenario when aicleaner cannot be set"

end