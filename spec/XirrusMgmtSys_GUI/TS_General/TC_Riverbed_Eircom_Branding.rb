require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "./local_lib/riverbed_branding_lib.rb"
#################################################################################
##############TEST CASE: Test the RIVERBED BRANDING - EIRCOM normal user#########
#################################################################################
describe "********** TEST CASE: Test the RIVERBED BRANDING - EIRCOM normal user **********" do

  include_examples "eircom avaya tenant", false, true, false

end