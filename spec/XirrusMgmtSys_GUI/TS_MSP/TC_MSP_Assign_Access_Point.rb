require_relative "./local_lib/msp_lib.rb"
require_relative "../environment_variables_library.rb"
#######################################################################################################################
################TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB#############################################
#######################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB **********"  do

	ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/access_points", "serial number")
	mac = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/access_points", "mac")

	include_examples "go to commandcenter"
	include_examples "create Domain", "Automation Access Points Domain"
	include_examples "assign and Unassign an Array to a domain", mac, ap_sn, "Automation Access Points Domain"
	include_examples "delete Domain", "Automation Access Points Domain"

end
