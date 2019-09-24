require_relative "../local_lib/support_management_lib.rb"

describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - AOS BOXES - SORTING ON GRID **********" do

	include_examples "go to support management"
	include_examples "verify descending ascending sorting firmware", "AOS Boxes", "Name"

end