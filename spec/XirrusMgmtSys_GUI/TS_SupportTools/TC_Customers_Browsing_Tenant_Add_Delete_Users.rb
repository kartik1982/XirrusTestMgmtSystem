require_relative "../environment_variables_library.rb"
require_relative "./local_lib/support_tools_lib.rb"
################################################################################################################
##############TEST CASE: Test the SUPPORT TOOLS area - CUSTOMERS tab - Browsing Tenant view####################
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT TOOLS area - CUSTOMERS tab - Browsing Tenant view **********" do
	tenant_name = return_proper_value_based_on_the_used_environment($the_environment_used, "supportTools/customrs/", "")
	include_examples "go to support tools"
	include_examples "search for customer", tenant_name, "1", true
	include_examples "browse to tenant", tenant_name, "AVAYA"
		number = UTIL.ickey_shuffle(4)
		first_name = "Automation_user_#{number}"
		last_name = "Last Name"
		email = "automationuser#{number}@email.com"
		additional_details = "Some random details in this string here ...."
		roles = ["CNP Admin", "CNP User", "CNP Read Only", "AP Installer"]
	include_examples "browsing to tenant add user", tenant_name, first_name, last_name, email, additional_details, roles.sample
	include_examples "delete user", email
end