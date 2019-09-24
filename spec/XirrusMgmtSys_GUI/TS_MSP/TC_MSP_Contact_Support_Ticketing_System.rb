require_relative "./local_lib/msp_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
############################################################################################################################
###################TEST CASE: Test the COMMANDCENTER area - Settings - Command Center Support Email########################
############################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - Settings - Command Center Support Email **********"  do

	include_examples "go to commandcenter"
	include_examples "go to settings then to tab", "Command Center"
	include_examples "verify support email features"
	include_examples "support email input", "testemail@domain.co.uk", false, "Write"
	include_examples "support email input", "anothertest@test.org", false, "Write"
	include_examples "support email input", "", false, "Write"
	include_examples "support email input", "mother@russia.ru", false, "Write"
	include_examples "go to settings then to tab", "My Account"
	include_examples "go to settings then to tab", "Command Center"
	include_examples "support email verify value", "mother@russia.ru"
	include_examples "support email input", "aaa", true, "Write"
	include_examples "support email input", "_*@test+test.com", true, "Write"
	include_examples "support email input", "testemail1testemail2testemail3testemail4testemail5@test.com", true, "Write"
	include_examples "support email input", "", false, "Copy"
end
