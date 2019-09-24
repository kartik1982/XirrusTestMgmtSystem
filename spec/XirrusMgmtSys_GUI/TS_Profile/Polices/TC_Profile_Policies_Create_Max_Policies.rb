require_relative "../local_lib/policies_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
#################################################################################################################################
#################TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of policies a profile can support#######
#################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - Create the maximum ammount of policies a profile can support **********" do

	include_examples "delete all profiles from the grid"
	profile_name = "Test profile for Policies tab MAX RULE NUMBER - DEVICE"
	profile_descriptiion = "Profile description for : " + profile_name
	include_examples "create profile from header menu", profile_name, profile_descriptiion, false
	policy_name = "Device_policy_"
	include_examples "create max available policies" , profile_name, "Device Policy", policy_name, "Phone", "Samsung"

	include_examples "delete all profiles from the grid"
	profile_name = "Test profile for Policies tab MAX RULE NUMBER - USER GROUP"
	profile_descriptiion = "Profile description for : " + profile_name
	include_examples "create profile from header menu", profile_name, profile_descriptiion, false
	policy_name = "UG_policy_"
	include_examples "create max available policies" , profile_name, "User Group Policy", policy_name, "", ""

	include_examples "delete all profiles from the grid"
	profile_name = "Test profile for Policies tab MAX RULE NUMBER - SSID"
	profile_descriptiion = "Profile description for : " + profile_name
	include_examples "create a profile and 8 ssids inside that profile", profile_name, profile_descriptiion, false, "SSID_"
	policy_name = "SSID_"
	include_examples "create max available policies" , profile_name, "SSID Policy", policy_name, "", ""


end