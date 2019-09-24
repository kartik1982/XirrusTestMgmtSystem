require_relative "../local_lib/support_management_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_MSP/local_lib/ap_provision_lib.rb"
#####################################################################################################################
###########TEST CASE: Test the SUPPORT MANAGEMENT area - CUSTOMERS TAB - AP SELF PROVISION ACCOUNT####################
######################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - CUSTOMERS TAB - AP SELF PROVISION ACCOUNT**********" do
  child_tenant = "BACKOFICE_AP_PROVISION_ACCOUNT"
  include_examples "go to commandcenter"
  include_examples "create Domain", child_tenant
  include_examples "manage specific domain", child_tenant
  include_examples "verify access point provision panel"
  (1..5).each do
    ap_sn = "ABCDE1" + UTIL.ickey_shuffle(1) + "A" + UTIL.ickey_shuffle(5)
    ap_hostname = "Hostname-" + UTIL.ickey_shuffle(9)
    ap_location = "Location " + UTIL.ickey_shuffle(9)
    include_examples "add access points to account", ap_sn, ap_hostname, ap_location
  end
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "AP_PROVISION_BACKOFFICE_AUTOMATION_XMS_SUPER_ADMIN", 1
	include_examples "verify accesspoints provision slot bar chart", 5, 20
	include_examples "go to support management"
	include_examples "open a customers dashboard view", child_tenant, 1
	include_examples "verify accesspoints provision slot bar chart", 5, 20
	include_examples "go to commandcenter"
  include_examples "delete Domain", child_tenant
end