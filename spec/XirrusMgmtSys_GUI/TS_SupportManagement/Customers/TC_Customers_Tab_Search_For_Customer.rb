require_relative "../local_lib/support_management_lib.rb"
##########################################################################################################
###########TEST CASE: Test the SUPPORT MANAGEMENT area - CUSTOMERS TAB - SEARCH FOR CUSTOMER##############
##########################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - CUSTOMERS TAB - SEARCH FOR CUSTOMER **********" do
  $the_environment_used=="test01" ? number_of_tenants=90 : number_of_tenants=23
	include_examples "go to support management"
	include_examples "search for customer and verify grid responds", "asdr" , 0
	include_examples "search for customer and verify grid responds", "Adrian-Automation-Firefox" , 1
	include_examples "search for customer and verify grid responds", "automation" , number_of_tenants
end