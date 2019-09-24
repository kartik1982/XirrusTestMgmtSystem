require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "./local_lib/riverbed_branding_lib.rb"
#################################################################################################
##############TEST CASE: Test the RIVERBED BRANDING - XIRRUS normal user########################
#################################################################################################
describe "********** TEST CASE: Test the RIVERBED BRANDING - XIRRUS normal user **********" do

  include_examples "scope to tenant", "1-Macadamian Child XR-620-Auto"
  include_examples "xirrus tenant", false, false

end