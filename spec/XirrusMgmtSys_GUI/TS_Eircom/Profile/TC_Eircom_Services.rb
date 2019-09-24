require_relative "../../TS_Profile/local_lib/services_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
########################################################################################################
###############TEST CASE: EDIT PROFILE SETTINGS ON THE SERVICES TAB - EIRCOM TENANT###################
########################################################################################################
describe "********** TEST CASE: EDIT PROFILE SETTINGS ON THE SERVICES TAB - EIRCOM TENANT **********" do

	profile_name = "Services Test: " + UTIL.ickey_shuffle(7)
	profile_description = UTIL.chars_256.upcase

  include_examples "go to settings then to tab", "Firmware Upgrades"
  include_examples "change default firmware for new domains", "Mainline"
	include_examples "create profile from header menu", profile_name, profile_description, false
	include_examples "test location services - positive other data format" , profile_name , "https://www.google.com", 222, "1234567890abcdefghij", "http://192.168.89.36", true

end