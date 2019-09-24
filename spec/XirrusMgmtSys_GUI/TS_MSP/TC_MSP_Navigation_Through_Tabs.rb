require_relative "./local_lib/msp_lib.rb"
require_relative "../TS_Mynetwork/local_lib/ap_lib.rb"
#######################################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - NAVIGATE TROUGH ALL TABS########################################
#######################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - NAVIGATE TROUGH ALL TABS **********"  do

	include_examples "go to commandcenter"
	["Access Points","Domains","Users","Dashboard"].each do |tab|
		include_examples "go to specific tab", tab
	end
end
