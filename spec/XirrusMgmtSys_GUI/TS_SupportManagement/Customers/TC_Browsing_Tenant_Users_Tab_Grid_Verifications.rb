require_relative "../local_lib/support_management_lib.rb"
######################################################################################################################################
################TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - GRID VERIFICATIONS - USER ACCOUNTS TAB###############
######################################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - GRID VERIFICATIONS - USER ACCOUNTS TAB **********" do
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "Adrian-Automation", 8
	include_examples "verify descending ascending sorting firmware", "User Accounts - Browsing tenant", "Email"
	include_examples "verify column does not support sorting", "User Accounts - Browsing tenant", "First Name"
	include_examples "verify column does not support sorting", "User Accounts - Browsing tenant", "Last Name"
	include_examples "verify column does not support sorting", "User Accounts - Browsing tenant", "Additional Details"
	include_examples "verify column does not support sorting", "User Accounts - Browsing tenant", "Privileges"
	include_examples "verify user accounts grid on customers dashboard view add user", "sortingtest@yahoo.ro", "Sorting", "Test Account", "Additional Details", "XMS User", "None"
	include_examples "verify user accounts grid on customers dashboard view delete user from context button", "sortingtest@yahoo.ro"
	include_examples "verify go back from browsing tenant view"
end