require_relative "../local_lib/services_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
######################################################################################################################
##################TEST CASE: EDIT PROFILE SETTINGS ON THE SERVICES TAB - MAC ADDRESS HASH TESTING#####################
######################################################################################################################
describe "********** TEST CASE: EDIT PROFILE SETTINGS ON THE SERVICES TAB - MAC ADDRESS HASH TESTING **********" do

	profile_name = "Services Test: " + UTIL.ickey_shuffle(7)
	profile_description = UTIL.chars_256.upcase

  include_examples "go to settings then to tab", "Firmware Upgrades"
  include_examples "change default firmware for new domains", "Technology"
	include_examples "create profile from header menu", profile_name, profile_description, false
	include_examples "test location services - MAC address hashing non-xps" , profile_name , "https://www.google.com", 222, "1234567890abcdefghij", "http://192.168.89.36", false
end