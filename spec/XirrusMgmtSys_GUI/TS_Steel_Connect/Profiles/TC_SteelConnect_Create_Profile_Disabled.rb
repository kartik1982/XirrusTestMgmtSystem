require_relative "../local_lib/steel_connect_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
######################################################################################################################################
############TEST CASE: STEEL CONNECT - ACCESS POINTS Details Slideout - TAGS control HIDDEN & LOCATION control READ-ONLY#############
######################################################################################################################################
describe "********** TEST CASE: STEEL CONNECT - ACCESS POINTS Details Slideout - TAGS control HIDDEN & LOCATION control READ-ONLY **********" do

  profile_name = "STEEL CONNECT - PROFILE WITH SEVERAL SETTINGS"

  include_examples "scope to tenant", "Adrian-Automation-Chrome-SteelConnect-Child"
  include_examples "new profile button hidden for steel connect domains"
  include_examples "scope to tenant", "Adrian-Automation-Chrome-SteelConnect-Child-SELF-No-Profiles"
  include_examples "new profile button hidden for steel connect domains"
  include_examples "scope to tenant", "Adrian-Automation-Chrome-SteelConnect-Child"
  include_examples "profile landing page overlay for entries is disabled"
  include_examples "verify options dropdown tool menu on steelconnect profiles", profile_name

end