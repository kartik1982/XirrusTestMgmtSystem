require_relative "./local_lib/settings_lib.rb"
######################################################################################################################################
#########TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES - Mainline vs. Technology feature#####################################
######################################################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES - Mainline vs. Technology feature **********" do
#verify Upgrade type (Auto and manual) and note
include_examples "go to settings then to tab", "Firmware Upgrades"
include_examples "verify upgrade types"
#verify manual upgrade preference
include_examples "verify manual upgrade preference"	
end