require_relative "../environment_variables_library.rb"
require_relative "./local_lib/support_tools_lib.rb"
################################################################################################################
##############TEST CASE: Test the SUPPORT TOOLS area - ACCESS POINTS tab - Search for an AP#####################
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT TOOLS area - ACCESS POINTS tab - Search for an AP **********" do

	$the_environment_used=="test01"? ap_sn = "A1600480E39B3" : ap_sn = "AUTOWAP9144AVAYA003FIRST"
	$the_environment_used=="test01"? tenant_id = "1847f571-e02d-11e9-ab26-02429829a388" : tenant_id = "7d133c71-228b-11e6-9973-06f40aa1df45"

	include_examples "go to support tools"
	include_examples "go to tab", "Access Points"
	include_examples "search for ap" , ap_sn, false,  tenant_id, "Offline", "Not Activated", ""
	include_examples "cancel search"
	include_examples "search for ap", "Avaya", true, "", "", "", ""
	include_examples "cancel search"
end