require_relative "./local_lib/msp_lib.rb"
require_relative "./local_lib/ap_provision_lib.rb"
#################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - DOMAINS TAB###############################
#################################################################################################
describe "********** TEST CASE: Test Xirrus AP Provisioning feature for child tenant **********"  do
  child_tenant_01 = "AP_PROVISION_CHILD_01"
  child_tenant_02 = "AP_PROVISION_CHILD_02"
  include_examples "go to commandcenter"
  include_examples "create Domain", child_tenant_01
  include_examples "create Domain", child_tenant_02
  include_examples "manage specific domain", child_tenant_01
  include_examples "verify access point provision panel"
  (1..5).each do
    ap_sn = "ABCDE1" + UTIL.ickey_shuffle(1) + "A" + UTIL.ickey_shuffle(5)
    ap_hostname = "Hostname-" + UTIL.ickey_shuffle(9)
    ap_location = "Location " + UTIL.ickey_shuffle(9)
    include_examples "add access points to account", ap_sn, ap_hostname, ap_location
  end
  include_examples "verify access point import"
  include_examples "delete certain Access Points using serial number", "AUTO000000001"
  include_examples "add access points to account", "AUTO000000001","Hostname-1","Location_1"
  include_examples "verify duplicate sn error message", "AUTO000000001"
  include_examples "verify invalid sn error message"
  include_examples "verify improper import"
  include_examples "go to commandcenter"
  include_examples "manage specific domain", child_tenant_02
  (1..5).each do
    ap_sn = "XIRRU1" + UTIL.ickey_shuffle(1) + "A" + UTIL.ickey_shuffle(5)
    ap_hostname = "Hostname-" + UTIL.ickey_shuffle(9)
    ap_location = "Location " + UTIL.ickey_shuffle(9)
    include_examples "add access points to account", ap_sn, ap_hostname, ap_location
  end
  include_examples "go to commandcenter"
  include_examples "delete Domain", child_tenant_01
  include_examples "delete Domain", child_tenant_02
end

