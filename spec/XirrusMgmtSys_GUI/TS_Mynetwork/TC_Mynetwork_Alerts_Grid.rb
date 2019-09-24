require_relative "./local_lib/alerts_lib.rb"
require_relative "./local_lib/ap_lib.rb"
################################################################################################
#############TEST CASE: Test My Network Alerts#################################################
################################################################################################
describe "***************TEST CASE: Test My Network Alerts*****************************" do
   include_examples "change to tenant", "1-Macadamian Child XR-620-Auto", 1
   include_examples "test my network alerts grid"
   include_examples "verify filters"
   include_examples "verify default columns"
end