require_relative "../local_lib/support_management_lib.rb"
################################################################################################################
####################TEST CASE: Test the SUPPORT MANAGEMENT area - CUSTOMERS TAB - GRID VERIFICATIONS############
################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - CUSTOMERS TAB - GRID VERIFICATIONS **********" do
	include_examples "go to support management"

	include_examples "verify descending ascending sorting firmware", "Customers", "Name"
	include_examples "verify descending ascending sorting firmware", "Customers", "ERP Id"
	include_examples "verify column does not support sorting", "Customers", "Circle"

end