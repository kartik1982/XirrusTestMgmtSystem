require_relative "../local_lib/services_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
############################################################################################################
##############TEST CASE: EDIT PROFILE SETTINGS ON THE SERVICES TAB - NEGATIVE TESTING######################
############################################################################################################
describe "********** TEST CASE: EDIT PROFILE SETTINGS ON THE SERVICES TAB - NEGATIVE TESTING **********" do

	profile_name = "Services Test: " + UTIL.ickey_shuffle(7)
	profile_description = UTIL.chars_256.upcase

	include_examples "create profile from header menu", profile_name, profile_description, false
	include_examples "test location services - negatige" , profile_name

end