require_relative "local_lib/refresh_grids_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
#############################################################################################
##############TEST CASE: TEST ALL GRIDS GENERAL SETTINGS AND REFRESH BUTTON##################
#############################################################################################
describe "TEST CASE: TEST ALL GRIDS GENERAL SETTINGS AND REFRESH BUTTON" do
	profile_name = UTIL.random_serial
	profile_description = UTIL.url_longer_than_256
	include_examples "create profile from header menu", profile_name, profile_description, false
	include_examples "profile - access points tab", profile_name, "Auto-XR320-3"
	include_examples "delete profile", profile_name
end