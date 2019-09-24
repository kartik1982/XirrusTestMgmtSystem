require_relative "./local_lib/msp_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_Mynetwork/local_lib/ap_lib.rb"
###############################################################################################
################TEST CASE: Test the COMMANDCENTER area - NON-MSP OWNED EQUIPMENT###############
###############################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - NON-MSP OWNED EQUIPMENT **********"  do

	include_examples "change to tenant", "Adrian-Automation-General-SELF-OWNED", 1

	include_examples "go to settings then to tab", "User Accounts"
	include_examples "verify domain and managed by strings", "Adrian-Automation-General-SELF-OWNED", "Adrian-Automation-"

	include_examples "change to tenant", "Adrian-Automation-Chrome", 1

end