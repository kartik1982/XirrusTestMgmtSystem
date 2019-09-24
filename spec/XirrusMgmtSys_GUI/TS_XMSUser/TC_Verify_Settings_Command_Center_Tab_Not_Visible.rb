require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
#################################################################################################################################
##############TEST CASE: Test the - Settings area - Command Center Support Email - DOES NOT EXIST FOR XMS USER ACCOUNTS##########
#################################################################################################################################
describe "********** TEST CASE: Test the - Settings area - Command Center Support Email - DOES NOT EXIST FOR XMS USER ACCOUNTS **********"  do

	include_examples "go to settings then to tab", "My Account"
	include_examples "verify command center tab not present in settings"

end
