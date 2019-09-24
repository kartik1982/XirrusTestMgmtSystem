require_relative "../local_lib/support_management_lib.rb"
########################################################################################################
###################TEST CASE: Test the SUPPORT MANAGEMENT area - AOS BOXES#############################
########################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - AOS BOXES -  **********" do
	aos_box_name = "1 - Test Box - " + UTIL.ickey_shuffle(5)
	circle_name = "Circle Name - " + UTIL.ickey_shuffle(5)

	include_examples "go to support management"
	include_examples "add an AOS box", aos_box_name, "Test Box description", "mainline", "8.8.1-8890", 1, "XR4426", "7.6", "8.1.0-6604"
	include_examples "duplicate an AOS box", aos_box_name
	include_examples "delete an AOS box", aos_box_name
	include_examples "delete an AOS box", "#{aos_box_name} (1)"

end