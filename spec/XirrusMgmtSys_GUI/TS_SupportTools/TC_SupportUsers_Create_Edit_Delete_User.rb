require_relative "./local_lib/support_tools_lib.rb"
################################################################################################################
##############TEST CASE: Test the SUPPORT TOOLS area - Support Users tab - Create, Edit and Delete User#########
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT TOOLS area - Support Users tab - Create, Edit and Delete User **********" do
	include_examples "go to support tools"
	include_examples "go to tab", "Support Users"
		number = UTIL.ickey_shuffle(4)
		first_name = "Automation_user_#{number}"
		last_name = "Last Name"
		email = "automationuser#{number}@email.com"
	include_examples "create user", first_name, last_name, email
	include_examples "edit user", email, "", first_name, "", last_name, "Last Name EDITED"
	include_examples "edit user", email, "", first_name, "Automation_user_#{number}_EDITED", "Last Name EDITED", last_name
	include_examples "edit user", email, "automation_user_#{number}@emailedited.com", "Automation_user_#{number}_EDITED", first_name, last_name, ""
	include_examples "delete user", "automation_user_#{number}@emailedited.com"
end