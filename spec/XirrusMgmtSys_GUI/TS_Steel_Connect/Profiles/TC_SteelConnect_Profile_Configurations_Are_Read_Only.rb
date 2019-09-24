require_relative "../local_lib/steel_connect_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
######################################################################################################################################
############TEST CASE: STEEL CONNECT - ACCESS POINTS Details Slideout - TAGS control HIDDEN & LOCATION control READ-ONLY##############
######################################################################################################################################
describe "********** TEST CASE: STEEL CONNECT - ACCESS POINTS Details Slideout - TAGS control HIDDEN & LOCATION control READ-ONLY **********" do

  profile_name = "STEEL CONNECT - PROFILE WITH SEVERAL SETTINGS"

  include_examples "scope to tenant", "Adrian-Automation-Chrome-SteelConnect-Child"
  include_examples "profile settings should be read only for steel connect domains general tab", profile_name
  include_examples "profile settings should be read only for steel connect domains ssids tab", profile_name
  include_examples "profile settings should be read only for steel connect domains network tab", profile_name

end