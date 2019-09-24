require_relative "./local_lib/settings_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
###########################################################################################
##############TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES########################
###########################################################################################
describe "********** TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES **********" do
  include_examples "Verify switching 'Default Firmware' from 'Technology' to 'Mainline' Admin feedback panel should show up"
end