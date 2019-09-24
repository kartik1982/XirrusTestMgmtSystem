require_relative "./local_lib/search_box_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/guests_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
#########################################################################################################
##############TEST CASE: Test the SEARCH BOX - All tabs that it appears on##############################
#########################################################################################################
describe "********** TEST CASE: Test the SEARCH BOX - All tabs that it appears on **********" do
	context "********** VERIFY PROFILE - CLIENTS TAB **********" do
		profile_name = "PROFILE - " + UTIL.ickey_shuffle(4) + " - tile"
		decription_prefix = "Description for: "

		include_examples "delete all profiles from the grid"
  		include_examples "create profile from tile", profile_name, decription_prefix + profile_name, false
		include_examples "open profile and go to clients tab", profile_name
		include_examples "verify search empty"
    include_examples "verify search", "aur", "haur", false, false
	end
end