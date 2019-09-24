require_relative "./local_lib/msp_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
########################################################################################################################
#####################TEST CASE: Test the COMMANDCENTER area - Settings - Command Center Support Email###################
########################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - Settings - Command Center Support Email **********"  do

	domain_name = "Domain for CC Support Email " + UTIL.ickey_shuffle(2)

	include_examples "go to commandcenter"
	include_examples "create Domain", domain_name
	include_examples "manage specific domain", domain_name

	include_examples "go to settings then to tab", "My Account"
	include_examples "verify command center tab not present in settings"

	include_examples "go to commandcenter"
	include_examples "delete Domain", domain_name

end
