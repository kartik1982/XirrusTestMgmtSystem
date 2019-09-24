require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
##################################################################################################################################################
################TEST CASE: TROUBLESHOOTING AREA - SETTINGS - ADDON SOLUTIONS - ADD AND DELETE TWILLIO IN UI - VERIFY AUDIT TRAIL LOG###############
##################################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - SETTINGS - ADDON SOLUTIONS - ADD AND DELETE TWILLIO IN UI - VERIFY AUDIT TRAIL LOG **********" do

	include_examples "set twillio account" , "1234567890", "1234567890", "+400730973335"
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Add-ons: Third Party Configuration"], 1

  	include_examples "set twillio account" , "", "", ""
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Add-ons: Third Party Configuration"], 1

end