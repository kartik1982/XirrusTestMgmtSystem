require_relative "../local_lib/msp_lib.rb"
#########################################################################################
##############TEST CASE: Test the COMMANDCENTER area - CREATE CHILD TENANT###############
#########################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - CREATE CHILD TENANT **********" do

	domain_name = "Child Domain for Portal Second tab"

	include_examples "go to commandcenter"
	include_examples "create Domain", domain_name

end