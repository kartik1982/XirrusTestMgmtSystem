require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
##############################################################################################################################################
################TEST CASE: TROUBLESHOOTING AREA - SETTINGS - USER ACCOUNTS - ADD, EDIT AND DELETE USER IN UI - VERIFY AUDIT TRAIL LOG#########
##############################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - SETTINGS - USER ACCOUNTS - ADD, EDIT AND DELETE USER IN UI - VERIFY AUDIT TRAIL LOG **********" do

	first_name = "Test Account"
	last_name = "User For Troubleshooting"
	email = "troubleshooting_user_" + UTIL.ickey_shuffle(3) + "@tester.ro"
	details = "THIS IS A TEST ACCOUNT (should be deleted!)"
	xms_role = "Admin"
	backoffice_role = "Admin"

	include_examples "set date time format to specific", "MM/DD/YYYY", "24 hour"

	include_examples "delete all user accounts", "Dinte"

	include_examples "test user account general settings - add user", first_name, last_name, email, details, xms_role, backoffice_role
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "EMAIL", Array["User: "+email, 'Maintenance Window: Default'], 1

	include_examples "test user account general settings - edit user", first_name, first_name + " NEW", last_name, last_name + " NEW", email, "new_" + email, details, "NEW " + details, xms_role, "User", backoffice_role, backoffice_role
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["User: "+ email, 'Maintenance Window: Default'], 2
	include_examples "perform action verify audit trail", "UPDATE", Array["User: "+ "new_" + email, 'Maintenance Window: Default'], 1

	include_examples "delete all user accounts", "Dinte"
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "DELETE", Array["User: "+ "new_" + email], 1

end