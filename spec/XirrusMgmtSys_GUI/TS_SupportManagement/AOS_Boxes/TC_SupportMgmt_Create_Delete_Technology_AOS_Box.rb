require_relative "../local_lib/support_management_lib.rb"
###############################################################################################################
#############TEST CASE: Test the SUPPORT MANAGEMENT area - AOS BOXES - CREATE TECHNOLOGY AOS BOX##############
###############################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - AOS BOXES - CREATE TECHNOLOGY AOS BOX **********" do
	aos_box_name = "1 - Test Box - Technology - " + UTIL.ickey_shuffle(5)

	include_examples "go to support management"
	include_examples "add new AOS box", aos_box_name, "Test Box description", "technology",  "8.8.1-8890", "8.0.0-125-xwj", "7.8.1-86-xap", "3.3.0-108", "4.3.0-363","6.5.1-81"
	include_examples "delete an AOS box", aos_box_name
end