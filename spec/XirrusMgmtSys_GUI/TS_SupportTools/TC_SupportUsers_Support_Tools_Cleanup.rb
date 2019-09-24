require_relative "./local_lib/support_tools_lib.rb"
################################################################################################################
##############TEST CASE: Test the SUPPORT TOOLS area - CLEAN UP#################################################
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT TOOLS area - CLEAN UP **********" do
	include_examples "go to support tools"
	include_examples "go to tab", "Support Users"
	include_examples "users cleanup", "automation_user_"
end