require_relative "../../TS_Refresh_Grids/local_lib/refresh_grids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
require_relative "../local_lib/msp_lib.rb"
##################################################################################################
############TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type FACEBOOK#####################
##################################################################################################
describe "**********TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type FACEBOOK******************" do

	portal_type = "mega"
	portal_name = "Portal to be deployed - " + UTIL.ickey_shuffle(9) + " - #{portal_type}"
	portal_description = "Random description text: " + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9)
  include_examples "delete all profiles from the grid"
	include_examples "create portal from header menu", portal_name, portal_description, portal_type
	include_examples "deploy portal facebook not possible", portal_name


end