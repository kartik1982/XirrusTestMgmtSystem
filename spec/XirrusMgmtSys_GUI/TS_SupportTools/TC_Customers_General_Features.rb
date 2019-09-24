require_relative "./local_lib/support_tools_lib.rb"
################################################################################################################
##############TEST CASE: Test the SUPPORT TOOLS area - CUSTOMERS tab - GENERAL FEATURES#########################
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT TOOLS area - CUSTOMERS tab - GENERAL FEATURES **********" do
	include_examples "go to support tools"
	include_examples "customers general features"
end