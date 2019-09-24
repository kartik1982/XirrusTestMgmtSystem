require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
##############################################################################################################################
################TEST CASE: TROUBLESHOOTING AREA - SETTINGS - FIRMWARE UPGRADES - VERIFY AUDIT TRAIL LOG######################
##############################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - SETTINGS - FIRMWARE UPGRADES - VERIFY AUDIT TRAIL LOG **********" do

	include_examples "go to settings then to tab", "Firmware Upgrades"
	include_examples "change default firmware for new domains", "Mainline"

	include_examples "go to settings then to tab", "Firmware Upgrades"
	include_examples "change default firmware for new domains", "Technology"
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Firmware Upgrade: " + "Technology"], 1

	include_examples "go to settings then to tab", "Firmware Upgrades"
	include_examples "change default firmware for new domains", "Mainline"
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Firmware Upgrade: " + "Mainline"], 1

	include_examples "go to settings then to tab", "Firmware Upgrades"
	include_examples "set firmware upgrades to custom time", "Week", "Sunday, Tuesday, Friday", "12:00 am", "8:00 pm", "(GMT-09:00) Alaska", false
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Upgrade Schedule: " + "Every week on Sunday, Tuesday, Friday between 12:00 am and 9:00 pm - (GMT-09:00) Alaska"], 1

end