require_relative "local_lib/xmse_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Portal/local_lib/lookfeel_lib.rb"
require_relative "../TS_Portal/local_lib/portal_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
#####################################################################################################################
##############Test Case: Test the XMS - Enterprise functionality - Settings area####################################
#####################################################################################################################
describe "Test Case: Test the XMS - Enterprise functionality - Settings area" do

  include_examples "change settings my account tab"
  include_examples "change settings user accounts tab", 1, "Admin", nil
  include_examples "change settings user accounts tab", 1, "Ambassador", nil
  include_examples "delete all user accounts expect for those that include a certain string", "Dinte"
  
end