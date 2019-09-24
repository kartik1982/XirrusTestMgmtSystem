require_relative "../local_lib/msp_lib.rb"
##############################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - USERS TAB - DELETE USERS###############################
##############################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - USERS TAB - DELETE USERS **********"  do

	include_examples "go to commandcenter"
	include_examples "delete a certain Administrator", "Test Administrator XMS READONLY"
	include_examples "delete a certain Administrator", "Test Administrator XMS USER"
	include_examples "delete a certain Administrator", "Test Administrator XMS ADMIN"
	include_examples "delete a certain Administrator", "Test Administrator DOMAIN READONLY"
	include_examples "delete a certain Administrator", "Test Administrator DOMAIN USER"
	include_examples "delete a certain Administrator", "Test Administrator DOMAIN ADMIN"
	include_examples "delete Domain", "Automation Users Domain - TEST"
end
