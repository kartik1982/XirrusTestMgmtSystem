require_relative "local_lib/refresh_grids_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Mynetwork/local_lib/ap_lib.rb"
#############################################################################################
##############TEST CASE: TEST ALL GRIDS GENERAL SETTINGS AND REFRESH BUTTON##################
#############################################################################################
describe "TEST CASE: TEST ALL GRIDS GENERAL SETTINGS AND REFRESH BUTTON" do
	include_examples "change to tenant", "1-Macadamian Child XR-620", 2
	include_examples "my network - alerts tab"
end