require_relative "../local_lib/policies_lib.rb"
#########################################################################################################
#################TEST CASE: Test the Profile - POLICIES TAB - General Features#########################
#########################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - General Features **********" do
	profile_name = "Test profile for Policies tab general features"
	profile_descriptiion = "Profile description for : " + profile_name
	

	include_examples "create a profile and an ssid inside that profile", profile_name, profile_descriptiion, false, "SSID"
	include_examples "general policy tab features", profile_name

end