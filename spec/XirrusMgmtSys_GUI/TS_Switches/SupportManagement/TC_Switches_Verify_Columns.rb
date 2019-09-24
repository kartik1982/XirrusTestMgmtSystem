require_relative "../../TS_SupportManagement/local_lib/support_management_lib.rb"
require_relative "../local_lib/switches_lib.rb"
#############################################################################################################
##############TEST CASE: Test the Support Management area - Switches tab###################################
#############################################################################################################
describe "TEST CASE: Test the Support Management area - Switches tab" do
  switch_sn = "BBBBCCDD00B1"
	include_examples "go to support management"
	include_examples "go to tab support management", "Switches"
	for column in  ["Tenant ID", "Serial Number", "Online", "Status", "Expiration Date", "Reported Version", "Model", "Last Activation Time"] do
	 include_examples "verify switches column", column
	end
	include_examples "search for an Switch and perform an action", switch_sn, "Command Line Interface"
end

