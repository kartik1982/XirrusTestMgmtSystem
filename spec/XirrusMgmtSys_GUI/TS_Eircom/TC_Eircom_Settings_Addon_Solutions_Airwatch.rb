require_relative "./local_lib/eircom_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/policies_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/lookfeel_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_XMSE/local_lib/xmse_lib.rb"
###########################################################################################################################
#################TEST CASE: EIRCOM - Test the SETTINGS area - ADD-ON SOLUTIONS TAB - AIRWATCH##############################
###########################################################################################################################
describe "********** TEST CASE: EIRCOM - Test the SETTINGS area - ADD-ON SOLUTIONS TAB - AIRWATCH **********" do

	include_examples "create profile from header menu", "Eircom profile for testing airwatch", "DESCRIPTION", false
  include_examples "add profile ssid", "Eircom profile for testing airwatch", "ssid"
	include_examples "test add-on solutions settings", "https://www.airwatchmdm.org", "Test1234567890!@#~kkj", "User QA Test", "Admini$trator1"
	include_examples "configure ssid for airwatch", "Eircom profile for testing airwatch"
	include_examples "test add-on solutions settings", "", "", "", ""
	include_examples "confirm ssid is not airwatch", "Eircom profile for testing airwatch"
	include_examples "delete profile ssids", "Eircom profile for testing airwatch"
	include_examples "delete profile from tile", "Eircom profile for testing airwatch"
  
end