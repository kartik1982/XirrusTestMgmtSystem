require_relative "../local_lib/support_management_lib.rb"
require_relative "../../environment_variables_library.rb"
#######################################################################################################################################
#############TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - ACCESS POINTS TAB - COMMAND LINE INTERFACE################
######################################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - ACCESS POINTS TAB - COMMAND LINE INTERFACE **********" do
	
	customer_name = return_proper_value_based_on_the_used_environment($the_environment_used, "supportManagement/customers/browsing_tenant_ap_tab_command_line_interface", "Customer Name")
	customer_count = return_proper_value_based_on_the_used_environment($the_environment_used, "supportManagement/customers/browsing_tenant_ap_tab_command_line_interface", "Customer Count")
	details = return_proper_value_based_on_the_used_environment($the_environment_used, "supportManagement/customers/browsing_tenant_ap_tab_command_line_interface", "Details")

	include_examples "go to support management"
	include_examples "open a customers dashboard view", customer_name, customer_count
	include_examples "verify acces points grid on customers dashboad view command line interface", details["Serial Number"], details["Name"], details["Activation Server"], details["Cloud Server"]
	include_examples "verify go back from browsing tenant view"
end