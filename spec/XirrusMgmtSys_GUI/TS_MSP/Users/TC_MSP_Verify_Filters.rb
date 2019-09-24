require_relative "../local_lib/msp_lib.rb"
##############################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - USERS TAB - VERIFY FILTERS############################
##############################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - USERS TAB - VERIFY FILTERS **********"  do

	include_examples "go to commandcenter"
	include_examples "verify the users filter", 'Domain Admin', 'Test Administrator DOMAIN ADMIN'
	include_examples "verify the users filter", 'Domain User', 'Test Administrator DOMAIN USER'
	include_examples "verify the users filter", 'Domain Read Only', 'Test Administrator DOMAIN READONLY'
	include_examples "verify the users filter", 'XMS Admin', 'Test Administrator XMS ADMIN'
	include_examples "verify the users filter", 'XMS User', 'Test Administrator XMS USER'
	include_examples "verify the users filter", 'XMS Read Only', 'Test Administrator XMS READONLY'

end
