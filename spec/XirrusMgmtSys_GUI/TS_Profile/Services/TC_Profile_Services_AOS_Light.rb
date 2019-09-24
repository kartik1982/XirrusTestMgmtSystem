require_relative "../local_lib/services_lib.rb"
require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
###########################################################################################################
###############TEST CASE: EDIT PROFILE SETTINGS ON THE SERVICES TAB - AOS LIGHT TESTING#####################
###########################################################################################################
describe "********** TEST CASE: EDIT PROFILE SETTINGS ON THE SERVICES TAB - AOS LIGHT TESTING **********" do

	profile_name = "Services Test: " + UTIL.ickey_shuffle(7)
	profile_description = UTIL.chars_256.upcase

	include_examples "create profile from header menu", profile_name, profile_description, false
	include_examples "add access point to profile certain model" , profile_name, "X2-120","XR320", true
	include_examples "test location services - positive other data format" , profile_name , "https://www.google.com", 222, "1234567890abcdefghij", "http://192.168.89.36", true

end