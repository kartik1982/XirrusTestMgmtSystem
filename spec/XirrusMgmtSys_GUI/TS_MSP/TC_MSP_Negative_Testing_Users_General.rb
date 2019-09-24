require_relative "./local_lib/msp_lib.rb"
#############################################################################################
##################TEST CASE: Test the COMMANDCENTER area - NEGATIVE TESTING - USERS##########
#############################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - NEGATIVE TESTING - USERS **********"  do
	include_examples "error messages on create administrator"
end