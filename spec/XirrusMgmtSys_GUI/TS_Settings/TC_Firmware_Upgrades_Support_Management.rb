require_relative "./local_lib/settings_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "../TS_SupportManagement/local_lib/support_management_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
################################################################################################################
##################TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES - SET ON CIRCLE VALUE##################
################################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES - SET ON CIRCLE VALUE **********" do

	circle_name = "Firmare_Upgrade_Circle_" + UTIL.ickey_shuffle(4)
	domain_name = "Firmware Upgrades Domain New Schedule " + UTIL.ickey_shuffle(4)

	include_examples "set timezone area to local"

	include_examples "go to commandcenter"
	include_examples "go to settings then to tab", "Firmware Upgrades"
	include_examples "change default firmware for new domains", "Mainline"
	include_examples "set firmware upgrades to default time", false
	include_examples "go to commandcenter"
	include_examples "create Domain", domain_name

	include_examples "go to support management"
	include_examples "create a circle" , circle_name, "Circle description", "Empty Box", domain_name
	include_examples "change circle firmware scheduling", circle_name, "3:00 am", "8:00 pm", "(GMT+12:00) Auckland, Wellington"

	include_examples "go to commandcenter"
	include_examples "manage specific domain", domain_name
	include_examples "verify firmware upgrades time", "Every day between 3:00 am and 8:00 pm - (GMT+12:00) Auckland, Wellington", ""

	include_examples "go to commandcenter"
	include_examples "delete Domain", domain_name

	include_examples "go to support management"
	include_examples "delete a circle" , circle_name

end