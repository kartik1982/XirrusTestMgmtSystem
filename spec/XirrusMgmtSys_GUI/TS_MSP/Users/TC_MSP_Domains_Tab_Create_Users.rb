require_relative "../local_lib/msp_lib.rb"
##############################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - DOMAINS TAB - CREATE USERS############################
##############################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - DOMAINS TAB - CREATE USERS **********"  do

	include_examples "go to commandcenter"
	include_examples "create Administrator from domain slide-out", "Test", "Administrator XMS READONLY", "test_readonly@test.com", "Automation Users Domain - TEST", "XMS Read Only"
	include_examples "create Administrator from domain slide-out", "Test", "Administrator XMS USER", "test_user@test.com", "Automation Users Domain - TEST", "XMS User"
	include_examples "create Administrator from domain slide-out", "Test", "Administrator XMS ADMIN", "test_admin@test.com", "Automation Users Domain - TEST", "XMS Admin"
	include_examples "create Administrator from domain slide-out", "Test", "Administrator DOMAIN READONLY", "test_domreadonly@test.com", "Automation Users Domain - TEST", "Domain Read Only"
	include_examples "create Administrator from domain slide-out", "Test", "Administrator DOMAIN USER", "test_domuser@test.com", "Automation Users Domain - TEST", "Domain User"
	include_examples "create Administrator from domain slide-out", "Test", "Administrator DOMAIN ADMIN", "test_domadmin@test.com", "Automation Users Domain - TEST", "Domain Admin"
end
