require_relative "local_lib/refresh_grids_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
#############################################################################################
##############TEST CASE: TEST ALL GRIDS GENERAL SETTINGS AND REFRESH BUTTON##################
#############################################################################################
describe "TEST CASE: TEST ALL GRIDS GENERAL SETTINGS AND REFRESH BUTTON" do
	include_examples "commandcenter - domains tab"
	include_examples "commandcenter - users tab"
	include_examples "commandcenter - access points tab"
end