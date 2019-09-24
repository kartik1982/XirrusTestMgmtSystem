require_relative "./local_lib/msp_lib.rb"
########################################################################################################
###############TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB###############################
########################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB **********"  do

	tenant_name = "Automation Access Points Domain (several) "  + UTIL.ickey_shuffle(8)

	include_examples "go to commandcenter"
	include_examples "create Domain", tenant_name
	include_examples "assign and Unassign several arrays to a domain", tenant_name, "Both"
	include_examples "delete Domain", tenant_name

end
