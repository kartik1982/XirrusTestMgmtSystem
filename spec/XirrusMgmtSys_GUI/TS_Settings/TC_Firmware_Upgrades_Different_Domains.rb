require_relative "./local_lib/settings_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
###############################################################################################################
##############TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES - DIFFERENT DOMAINS#######################
###############################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES - DIFFERENT DOMAINS **********" do

	include_examples "set timezone area to local"
	include_examples "go to commandcenter"
	include_examples "set firmware upgrades to custom time", "Week", "Sunday, Tuesday, Friday", "12:00 am", "8:00 pm", "(GMT-05:00) Cuba", false
	include_examples "go to commandcenter"
	include_examples "create Domain", "Firmware Upgrades Domain"
	include_examples "manage specific domain", "Firmware Upgrades Domain"
	include_examples "verify firmware upgrades time", "Every week on Sunday, Tuesday, Friday between 12:00 am and 8:00 pm - (GMT-05:00) Cuba", ""
	include_examples "set firmware upgrades to custom time", "Day", "", "3:00 am", "9:00 pm", "(GMT+08:45) Eucla", true
	include_examples "go to commandcenter"
	include_examples "verify firmware upgrades time", "Every week on Sunday, Tuesday, Friday between 12:00 am and 8:00 pm - (GMT-05:00) Cuba", "(GMT-05:00) Cuba"
	include_examples "go to commandcenter"
	include_examples "manage specific domain", "Firmware Upgrades Domain"
	include_examples "verify firmware upgrades time", "Every day between 3:00 am and 9:00 pm - (GMT+08:45) Eucla", ""
	include_examples "go to commandcenter"
	include_examples "delete Domain", "Firmware Upgrades Domain"

end