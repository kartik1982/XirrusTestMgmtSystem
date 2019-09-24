require_relative "../local_lib/policies_lib.rb"
#################################################################################################################################
###############TEST CASE: Test the Profile - POLICIES TAB - Create AirCleaner rules#############################################
#################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - Create AirCleaner rules **********" do

	profile_name = "Test profile for Policies tab - AIRCLEANER"
	profile_descriptiion = "Profile description for : " + profile_name
	
  include_examples "delete all profiles from the grid"
	include_examples "create profile from header menu", profile_name, profile_descriptiion, false
	    
    include_examples "create a rule for any policy", "Global Policy", "test name", "", "", "aircleaner", "", "", "", "", "", "", "", "", "", "", "", ""
	include_examples "search for aircleaner rules and verify them"

end