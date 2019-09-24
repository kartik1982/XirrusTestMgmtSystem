require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_XMSE/local_lib/xmse_lib.rb"
######################################################################################################################
######################TEST CASE: PROFILE - SSIDs TAB - USE GUEST AMBASSADOR PORTAL####################################
######################################################################################################################
describe "********** TEST CASE: PROFILE - SSIDs TAB - USE GUEST AMBASSADOR PORTAL **********" do

	decription_prefix = "Description for "
	profile_name = UTIL.random_title.downcase
	portal_name = UTIL.random_title.downcase + " - header menu"
	portal_type = "ambassador"

	include_examples "create profile from header menu", profile_name, "Profile description", false
	include_examples "add profile ssid", profile_name, 'ssid'

	include_examples "verify portal list view tile view toggle" 
	include_examples "create portal from header menu", portal_name + " " + portal_type, decription_prefix + portal_name, portal_type

	include_examples "go to profile", profile_name

	include_examples "edit an ssid and change access control to captive portal gap", profile_name, portal_name + " " + portal_type , portal_type
	
end