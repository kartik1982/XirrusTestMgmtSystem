require_relative "../local_lib/msp_lib.rb"
##############################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - DOMAINS TAB - CREATE USERS############################
##############################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - DOMAINS TAB - CREATE USERS **********"  do

	include_examples "go to commandcenter"
	include_examples "verify that administrators and roles are correct on the domain slideout", "Automation Users Domain - TEST", "test_readonly@test.com", "Test Administrator XMS READONLY", "XMS Read Only"
	include_examples "verify that administrators and roles are correct on the domain slideout", "Automation Users Domain - TEST", "test_user@test.com", "Test Administrator XMS USER", "XMS User"
	include_examples "verify that administrators and roles are correct on the domain slideout", "Automation Users Domain - TEST", "test_admin@test.com", "Test Administrator XMS ADMIN", "XMS Admin"
	include_examples "verify that administrators and roles are correct on the domain slideout", "Automation Users Domain - TEST", "test_domreadonly@test.com", "Test Administrator DOMAIN READONLY", "Domain Read Only"
	include_examples "verify that administrators and roles are correct on the domain slideout", "Automation Users Domain - TEST", "test_domuser@test.com", "Test Administrator DOMAIN USER", "Domain User"
	include_examples "verify that administrators and roles are correct on the domain slideout", "Automation Users Domain - TEST", "test_domadmin@test.com", "Test Administrator DOMAIN ADMIN", "Domain Admin"

end
