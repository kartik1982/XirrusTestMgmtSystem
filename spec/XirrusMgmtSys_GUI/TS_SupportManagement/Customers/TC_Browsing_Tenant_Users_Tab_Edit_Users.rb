require_relative "../local_lib/support_management_lib.rb"
##############################################################################################################################
#########TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - USERS TAB - CREATE and EDIT USERS###################
##############################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - USERS TAB - CREATE and EDIT USERS **********" do
	user_email = "test_email_" + UTIL.ickey_shuffle(3).to_s + "@yahoo.ro"
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "Adrian-Automation", 10
	include_examples "verify user accounts grid on customers dashboard view add user", user_email,"TEST_NAME","First account","TEST ACCOUNT QA","XMS User", "None"
	include_examples "verify user accounts grid on customers dashboard view edit user", user_email,"automation edit","First account","TEST ACCOUNT QA","XMS User"
	include_examples "verify user accounts grid on customers dashboard view delete user from grid button", user_email
	include_examples "verify user accounts grid on customers dashboard view add user", "sortingtest@yahoo.ro","TEST","Sorting account","TEST ACCOUNT QA FOR SORTING","XMS Admin", "Admin"
	include_examples "verify user accounts grid on customers dashboard view delete user from grid button", "sortingtest@yahoo.ro"
	include_examples "verify go back from browsing tenant view"
end