require_relative "./local_lib/settings_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
############################################################################################
################TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES######################
############################################################################################
describe "********** TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES **********" do

  include_examples "set timezone area to local"

  include_examples "set firmware upgrades to custom time", "Day", "", "1:00 am", "4:00 pm", "(GMT+02:00) Jerusalem", false
  #include_examples "verify audit trail for firmware upgrade", "Maintenance Window: Custom" #"Maintenance Window: Frequency: DAILY, Days: ALL, Start Hour: 1, End Hour: 16, Time Zone: +2:00"
  include_examples "set firmware upgrades to custom time", "Week", "Sunday, Tuesday, Friday", "12:00 am", "8:00 pm", "(GMT-09:00) Alaska", false
  include_examples "set firmware upgrades to custom time", "Day", "", "12:00 am", "12:00 am", "(GMT-10:00) Hawaii", false
  include_examples "set firmware upgrades to custom time", "Week", "Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday", "6:00 am", "7:00 pm", "(GMT-08:00) Pacific Time (US & Canada)", false
  include_examples "set firmware upgrades to custom time", "Day", "", "10:00 pm", "12:00 pm", "(GMT-04:00) Atlantic Time (Canada)", false
  include_examples "set firmware upgrades to custom time", "Week", "Monday", "6:00 pm", "8:00 pm", "(GMT+10:00) Brisbane", false
  #include_examples "verify audit trail for firmware upgrade", "Maintenance Window: Custom" #{}"Maintenance Window: Frequency: WEEKLY, Days: [MONDAY], Start Hour: 18, End Hour: 20, Time Zone: +10:00"
  include_examples "set firmware upgrades to default time", false

end