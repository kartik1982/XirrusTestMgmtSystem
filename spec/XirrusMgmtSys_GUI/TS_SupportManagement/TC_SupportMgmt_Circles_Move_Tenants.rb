require_relative "./local_lib/support_management_lib.rb"
##############################################################################################
############TEST CASE: Test the Support Management area - Circles tab#########################
##############################################################################################
describe "TEST CASE: Test the Support Management area - Circles tab" do
	include_examples "go to support management"
	include_examples "add tenant to a circle", "sucking circle 1", "Domain10"
	include_examples "add tenant to a circle", "sucking circle 2", "Domain10"
	include_examples "add tenant to a circle", "sucking circle 3", "Domain10"
	include_examples "add tenant to a circle", "sucking circle 2", "Domain10"
end