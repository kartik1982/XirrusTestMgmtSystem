require_relative "./local_lib/msp_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/ap_lib.rb"
###############################################################################################################
##########TEST CASE: Test the COMMANDCENTER area - GENERAL FEATURES#############################################
###############################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - GENERAL FEATURES **********"  do
  ap_sn = "AUTOXR620CHROME011FIRST"
  ap_mac = "01:01:01:01:01:11"
  ap_model = "XR620"
  domain_name = "Tenant Scope Dropdownlist testing"
  ap_hostname = "AutomationXR620-CHROME-011-First"
  profile_name = "Profile for CC APs tab testing"
  location = "Cluj-Napoca"
  tag = "AD #{UTIL.ickey_shuffle(9)}"


	include_examples "create Domain", domain_name
	include_examples "verify tenant scoping icons", 'Adrian-Automation'
  include_examples "only assign array to domain", ap_sn, domain_name
  include_examples "scope to tenant", domain_name
  include_examples "create profile from header menu", profile_name, "", false
  include_examples "add access point to profile", profile_name, ap_hostname
  include_examples "profile access point general tab perform changes", profile_name, ap_sn, nil, location, tag
  include_examples "go to commandcenter"
  include_examples "verify the ap slideout", ap_sn, ap_mac, ap_model, domain_name, ap_hostname, profile_name, location, tag
	include_examples "go to CommandCenter and verify basic requirements"
  include_examples "only unassign array to domain", ap_sn, domain_name
  include_examples "delete Domain", domain_name
  include_examples "verify access points search", "XR320"
  include_examples "verify access points search", "XR620"

end