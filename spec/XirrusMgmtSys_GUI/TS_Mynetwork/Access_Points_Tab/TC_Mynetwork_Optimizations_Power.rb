require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
#################################################################################################################
##################TEST CASE: Test the MY NETWORK area - ACCESS POINTS TAB - OPTIMIZATIONS - POWER###############
#################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - ACCESS POINTS TAB - OPTIMIZATIONS - POWER **********" do
  if $the_environment_used == "test03"
          ap_sn = "X306519043B60"
  elsif $the_environment_used == "test01"
          ap_sn = "X20641902ADDC"
  end
  monitor_state = "on (dedicated)"
  include_examples "ap monitor configurations", ap_sn, monitor_state
  include_examples "verify optimizations power", "Romania-X620-Auto", ap_sn

end