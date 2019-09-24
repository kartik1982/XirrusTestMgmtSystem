require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_XMSE/local_lib/xmse_lib.rb"
######################################################################################################################
######################TEST CASE: PROFILE - SSIDs TAB - CREATE A NEW AMBASSADOR PORTAL FROM HERE#######################
######################################################################################################################
describe "********** TEST CASE: PROFILE - SSIDs TAB - CREATE A NEW AMBASSADOR PORTAL FROM HERE **********" do

	profile_name = UTIL.random_title.downcase
	decription_prefix = "profile description for "
	portal_from_header_name = UTIL.random_title.downcase + " - header menu"
	decription_prefix = "portal description for "

	include_examples "create profile from header menu", profile_name, "Profile description", false
	include_examples "add profile ssid", profile_name, 'ssid'

	include_examples "verify portal list view tile view toggle" 

	include_examples "go to profile", profile_name
	include_examples "edit an ssid and add a new captive portal gap", profile_name, 'ambassador'

end