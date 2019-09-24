require_relative "../environment_variables_library.rb"
require_relative "./local_lib/support_tools_lib.rb"
################################################################################################################
##############TEST CASE: Test the SUPPORT TOOLS area - CUSTOMERS tab - Search for a Customer###################
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT TOOLS area - CUSTOMERS tab - Search for a Customer **********" do
	tenant_name = return_proper_value_based_on_the_used_environment($the_environment_used, "supportTools/customrs/", "")

	include_examples "go to support tools"
	include_examples "search for customer", tenant_name, "1", true
	include_examples "cancel search"
	include_examples "search for customer", "Avaya", "287", false
	include_examples "cancel search"
	include_examples "search for customer", "ABCDABCAABBBDACCADDAAAD", "0", false
end