require_relative "../local_lib/support_management_lib.rb"
require_relative "../../environment_variables_library.rb"
##########################################################################################################
###########TEST CASE: Test the SUPPORT MANAGEMENT area - CUSTOMERS TAB - SEARCH FOR CUSTOMER##############
##########################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - CUSTOMERS TAB - SEARCH FOR CUSTOMER **********" do

	number_of_tenants = return_proper_value_based_on_the_used_environment($the_environment_used, "supportManagement/customers/customers_tab_search_for_customer.rb", "")

	include_examples "go to support management"
	include_examples "search for customer and verify grid responds", "asdr" , 0
	include_examples "search for customer and verify grid responds", "Adrian-Automation-Firefox" , 1
	include_examples "search for customer and verify grid responds", "automation" , number_of_tenants
end