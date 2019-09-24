require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
######################################################################################################################
######################TEST CASE: PROFILE - SSIDs TAB - CREATE MAX AVAILABLE SSIDs##################################
######################################################################################################################
describe "********** TEST CASE: PROFILE - SSIDs TAB - CREATE MAX AVAILABLE SSIDs **********" do

	profile_name = "Profile - Create maximum number of SSIDS - " + UTIL.ickey_shuffle(5)

	include_examples "create profile from header menu", profile_name, "Profile description " + profile_name, false
	include_examples "verify portal list view tile view toggle" 
	include_examples "create portal from header menu", "Personal WiFi Portal", "Description string ...", "personal"
	include_examples "ssids grid general configurations - max 8 grids", profile_name, "Personal WiFi Portal", "All at once"

	profile_name = "Profile - Create maximum number of SSIDS - " + UTIL.ickey_shuffle(5)

	include_examples "create profile from header menu", profile_name, "Profile description " + profile_name, false
	include_examples "ssids grid general configurations - max 8 grids", profile_name, "Personal WiFi Portal", "One by one"

end