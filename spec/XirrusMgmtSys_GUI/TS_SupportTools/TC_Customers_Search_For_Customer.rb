require_relative "./local_lib/support_tools_lib.rb"
################################################################################################################
##############TEST CASE: Test the SUPPORT TOOLS area - CUSTOMERS tab - Search for a Customer###################
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT TOOLS area - CUSTOMERS tab - Search for a Customer **********" do
	$the_environment_used=="test01" ? tenant_name = "Macadamian Avaya Parent" : tenant_name= "Macadamian - Avaya MSP" 
  $the_environment_used=="test01" ? tenant_count=7 : tenant_count=8

	include_examples "go to support tools"
	include_examples "search for customer", tenant_name, "1", true
	include_examples "cancel search"
	include_examples "search for customer", tenant_name, tenant_count, false
	include_examples "cancel search"
	include_examples "search for customer", "ABCDABCAABBBDACCADDAAAD", "0", false
end