require_relative "../local_lib/support_management_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
##########################################################################################################################################################
###############TEST CASE: Test the SUPPORT MANAGEMENT area - ACCESS POINTS tab - Error status tooltip showing 'more info...' / 'less info...'#############
##########################################################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - ACCESS POINTS tab - Error status tooltip showing 'more info...' / 'less info...' **********" do
  include_examples "go to support management"
  include_examples "aa"
  include_examples "scope to tenant", "Adrian-Automation-Chrome-Eight-Child"
end

