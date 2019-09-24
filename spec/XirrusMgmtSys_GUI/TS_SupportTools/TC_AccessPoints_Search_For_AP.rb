require_relative "../environment_variables_library.rb"
require_relative "./local_lib/support_tools_lib.rb"
################################################################################################################
##############TEST CASE: Test the SUPPORT TOOLS area - ACCESS POINTS tab - Search for an AP#####################
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT TOOLS area - ACCESS POINTS tab - Search for an AP **********" do

	ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "supportTools/access_points/search_for_ap.rb", "AP SN")
	tenant_id = return_proper_value_based_on_the_used_environment($the_environment_used, "supportTools/access_points/search_for_ap.rb", "Tenant ID")

	include_examples "go to support tools"
	include_examples "go to tab", "Access Points"
	include_examples "search for ap" , ap_sn, false,  tenant_id, "Offline", "Not Activated", ""
	include_examples "cancel search"
	include_examples "search for ap", "Avaya", true, "", "", "", ""
	include_examples "cancel search"
end