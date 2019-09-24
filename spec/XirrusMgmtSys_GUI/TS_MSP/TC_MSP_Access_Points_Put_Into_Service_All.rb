require_relative "./local_lib/msp_lib.rb"
require_relative "../TS_Mynetwork/local_lib/ap_lib.rb"
###########################################################################################################################
###################TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB - PUT IN / OUT OF SERVICE###################
###########################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB - PUT IN / OUT OF SERVICE **********"  do

	include_examples "go to commandcenter"
	include_examples "put in service all arrays in grid commandcenter"

end
