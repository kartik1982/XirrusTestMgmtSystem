require_relative "local_lib/refresh_grids_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
#############################################################################################
##############TEST CASE: TEST ALL GRIDS GENERAL SETTINGS AND REFRESH BUTTON#################
#############################################################################################
describe "TEST CASE: TEST ALL GRIDS GENERAL SETTINGS AND REFRESH BUTTON" do
	include_examples "backoffice - customers tab"
	include_examples "backoffice - customers tab - browsing tenant view - access points tab", "Adrian-Automation-Chrome"
	include_examples "backoffice - customers tab - browsing tenant view - user accounts tab", "Adrian-Automation"
end