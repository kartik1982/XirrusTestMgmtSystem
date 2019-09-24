require_relative "../local_lib/support_management_lib.rb"
######################################################################################################################################
################TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - USERS TAB - CREATE USERS WITH ALL PERMISSIONS#########
######################################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - USERS TAB - CREATE USERS WITH ALL PERMISSIONS **********" do
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "Adrian-Automation-Edge", 1

	role = "Guest Ambassador"
	# cloud_services = ["None","Admin","Super Admin"] -NOTE: removed privilege to add same rights user
	cloud_services = ["None","Admin"]
	cloud_services.each { |cloud_service|
		first_name = UTIL.random_firstname
		last_name = UTIL.random_lastname
		email = UTIL.random_email
		additional_details = UTIL.chars_255
		include_examples "verify user accounts grid on customers dashboard view add user", email,first_name, last_name, additional_details, role, cloud_service
		include_examples "verify user accounts grid on customers dashboard view delete user from context button", email
	}
end