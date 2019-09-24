require_relative "../local_lib/msp_lib.rb"
##############################################################################################################
#############TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB#######################################
##############################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB **********" do

	include_examples "go to commandcenter"
	include_examples "create Domain", "Deploy PORTALS to this domain 1"
	include_examples "create Domain", "Deploy PORTALS to this domain 2"

end