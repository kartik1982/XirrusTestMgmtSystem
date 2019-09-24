require_relative "../local_lib/switches_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
##############################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB######################################
##############################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB **********"  do

	tenant_name = "Automation Switch Domain (several) "  + UTIL.ickey_shuffle(8)

	include_examples "go to commandcenter"
	include_examples "create Domain", tenant_name
	include_examples "assign and Unassign several Switches to a domain", tenant_name, "Both"
	include_examples "delete Domain", tenant_name

end
