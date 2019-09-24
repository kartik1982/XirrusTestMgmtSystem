require_relative "../local_lib/support_management_lib.rb"
require_relative "../../environment_variables_library.rb"
###############################################################################################################
#################TEST CASE: Test the SUPPORT MANAGEMENT area - AOS BOXES######################################
###############################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - AOS BOXES -  **********" do
	
	first_customer = return_proper_value_based_on_the_used_environment($the_environment_used, "supportManagement/aos_boxes/create_add_circles_delete", "First Customer")
	second_customer = return_proper_value_based_on_the_used_environment($the_environment_used, "supportManagement/aos_boxes/create_add_circles_delete", "Second Customer")

	aos_box_name = "1 - Test Box - " + UTIL.ickey_shuffle(5)
	circle_name = "Circle Name - " + UTIL.ickey_shuffle(5)

	include_examples "go to support management"
	include_examples "add an AOS box", aos_box_name, "Test Box description", "mainline", "8.8.1-8890", 1, "XR4426", "7.6", "8.1.0-6604"
	include_examples "add circle to AOS box", aos_box_name, "sucking circle 2"
	include_examples "change circle from AOS box", "sucking circle 2", "Anca L box"
	include_examples "create a circle" , circle_name, "circle_description", aos_box_name, first_customer
	include_examples "change customer from one circle to another", first_customer, second_customer
	include_examples "delete a circle" , circle_name
	include_examples "delete an AOS box", aos_box_name

end