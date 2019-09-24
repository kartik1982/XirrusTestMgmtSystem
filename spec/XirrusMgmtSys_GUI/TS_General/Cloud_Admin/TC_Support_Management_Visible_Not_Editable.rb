require_relative "../../TS_SupportManagement/local_lib/support_management_lib.rb"
########################################################################################################################
##############TEST CASE: SUPPORT MANAGEMENT area - Test the FIRMWARE tab - Create, edit and delete FIRMWARES############
########################################################################################################################
describe  "********** TEST CASE: SUPPORT MANAGEMENT area - Test the FIRMWARE tab - Create, edit and delete FIRMWARES **********" do

	include_examples "go to support management"
	include_examples "cant delete a certain firmware"
	include_examples "cant add edit an AOS Box"
	include_examples "cant add edit an circle"
	#include_examples "cant delete an ap with grid delete button", "backoffice"
	include_examples "cant edit a customer"
	include_examples "cant edit browsing tenant area", "Adrian-Automation-Chrome", 5
	#include_examples "cant delete an ap with grid delete button", "customerDash"

	role = "Domain Admin"
	cloud_service = nil
	first_name = UTIL.random_firstname
	last_name = UTIL.random_lastname
	email = UTIL.random_email
	additional_details = UTIL.chars_255

	include_examples "verify user accounts grid on customers dashboard view add user", email,first_name, last_name, additional_details, role, cloud_service
	include_examples "verify user accounts grid on customers dashboard view delete user from context button", email


end