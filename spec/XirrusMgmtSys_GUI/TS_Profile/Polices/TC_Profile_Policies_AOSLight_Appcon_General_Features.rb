require_relative "../local_lib/policies_lib.rb"
require_relative "../local_lib/ap_lib.rb"
require_relative "../local_lib/profile_lib.rb"
###################################################################################################################################
################TEST CASE: Test the Profile - POLICIES TAB - AOS LIGHT - APPCON CREATE FIREWALL POLICIES########################
###################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - AOS LIGHT - APPCON CREATE FIREWALL POLICIES **********" do

	profile_name = "Test profile for Policies tab AOS LIGHT - APPCON - " + UTIL.ickey_shuffle(4)
	profile_descriptiion = "Profile description for : " + profile_name

	include_examples "create a profile and an ssid inside that profile", profile_name, profile_descriptiion, false, "SSID"

	include_examples "verify appcon false can not create app control policies", false
	include_examples "add access point to profile certain model" , profile_name, "X2-120","XR320", true
	include_examples "verify appcon false can not create app control policies", true

end
