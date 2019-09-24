require_relative "../../environment_variables_library.rb"
require_relative "../local_lib/support_management_lib.rb"
########################################################################################################
###################TEST CASE: Test the SUPPORT MANAGEMENT area - CUSTOMERS TAB - CHANGE CIRLCE##########
########################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - CUSTOMERS TAB - CHANGE CIRLCE **********" do

	tenant_name = return_proper_value_based_on_the_used_environment($the_environment_used, "supportManagement/customers/customers_tab_change_circle.rb", "")

	include_examples "go to support management"
	include_examples "change customer from one circle to another", tenant_name, "2016 test"

end