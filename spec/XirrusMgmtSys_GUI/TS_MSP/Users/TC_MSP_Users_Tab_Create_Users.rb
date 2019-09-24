require_relative "../local_lib/msp_lib.rb"
##############################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - USERS TAB - CREATE USERS###############################
##############################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - USERS TAB - CREATE USERS **********"  do

	include_examples "go to commandcenter"
	include_examples "create Domain", "Automation Users Domain - TEST"
	include_examples "create Administrator from administrator tab", "Test", "Administrator", "test@test2.com", "Automation Users Domain - TEST"
	include_examples "delete a certain Administrator", "Test Administrator"

end
