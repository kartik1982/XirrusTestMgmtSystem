require_relative "./local_lib/support_tools_lib.rb"
################################################################################################################
##############TEST CASE: Test the SUPPORT TOOLS area - Orders tab - VERIFY FEATURES#############################
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT TOOLS area - Orders tab - VERIFY FEATURES **********" do
	include_examples "go to support tools"
	include_examples "go to tab", "Orders"
	include_examples "verify orders grid"
end