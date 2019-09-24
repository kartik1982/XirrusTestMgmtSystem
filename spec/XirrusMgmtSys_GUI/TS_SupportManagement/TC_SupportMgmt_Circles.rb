require_relative "./local_lib/support_management_lib.rb"
require_relative "../environment_variables_library.rb"
#################################################################################################################
##################TEST CASE: Test the Support Management area - Circles tab####################################
#################################################################################################################
describe "TEST CASE: Test the Support Management area - Circles tab" do
	aos_box_name = "1 - Test Box - " + UTIL.ickey_shuffle(5)
	circle_name = "Circle Name - " + UTIL.ickey_shuffle(5)
	first_tenant_name = return_proper_value_based_on_the_used_environment($the_environment_used, "supportManagement/circles.rb", "first tenant")
	second_tenant_name = return_proper_value_based_on_the_used_environment($the_environment_used, "supportManagement/circles.rb", "second tenant")

	include_examples "go to support management"
	include_examples "add an AOS box", aos_box_name, "Test Box description", "mainline", "8.8.1-8890", 1 ,"XR4426", "7.6", "8.1.0-6604"

	include_examples "create a circle" , circle_name, "circle_description", aos_box_name, first_tenant_name
	include_examples "cannot delete a circle with tenant", circle_name
	include_examples "add tenant to a circle", circle_name, second_tenant_name
	include_examples "change customer from one circle to another", second_tenant_name, "2016 test"
	include_examples "change customer from one circle to another", first_tenant_name, "2016 test"

	include_examples "delete a circle" , circle_name
	include_examples "delete an AOS box", aos_box_name

end