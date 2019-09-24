require_relative "../local_lib/support_management_lib.rb"
######################################################################################################################################
################TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - USERS TAB - DELETE USERS############################
######################################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - USERS TAB - DELETE USERS **********" do
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "Adrian-Automation", 10
	include_examples "customers dashboard view delete all user accounts", "Dinte"
end