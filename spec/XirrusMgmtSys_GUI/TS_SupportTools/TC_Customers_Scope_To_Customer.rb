require_relative "../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "./local_lib/support_tools_lib.rb"
################################################################################################################
##############TEST CASE: Test the SUPPORT TOOLS area - CUSTOMERS tab - Browsing Tenant view####################
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT TOOLS area - CUSTOMERS tab - Browsing Tenant view **********" do
	$the_environment_used=="test01" ? tenant_name = "Macadamian Avaya Parent" : tenant_name = "Macadamian - Avaya MSP"
	include_examples "go to support tools"
	include_examples "search for customer", tenant_name, "1", true
	include_examples "browse to tenant", tenant_name, "AVAYA"
	include_examples "scope to customer from support", tenant_name, "Browsing tenant area"
	include_examples "go to support tools"
	include_examples "search for customer", tenant_name, "1", true
	include_examples "scope to customer from support", tenant_name, "Customers tab"
end