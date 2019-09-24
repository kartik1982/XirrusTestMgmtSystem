require_relative "../local_lib/support_management_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
#########################################################################################################
##################TEST CASE: Test the Support Management area - Access Points tab########################
#########################################################################################################
describe "TEST CASE: Test the Support Management area - Access Points tab" do
	include_examples "go to support management"
  if $the_environment_used == "test03"
          ap_sn = "XR5030800073C"
  elsif $the_environment_used == "test01"
          ap_sn = "X6065440515BE"
  end
       include_examples "verify grid column", "10", "Support Management / Customers / Browsing Tenant: 1-Macadamian Child XR-620-Auto", ap_sn, "4", "xc-icon-nssg-activated", "Activated", "", "" #, false, ""
       include_examples "verify grid column", "10", "Support Management / Customers / Browsing Tenant: 1-Macadamian Child XR-620-Auto", ap_sn, "5", "xc-icon-nssg-onlinestatusup", "Online", "", "" #, false, ""
end