require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
##################################################################################################################################################
################TEST CASE: TROUBLESHOOTING AREA - SETTINGS - ADDON SOLUTIONS - ADD AND DELETE AIRWATCH IN UI - VERIFY AUDIT TRAIL LOG#############
##################################################################################################################################################

describe "********** TEST CASE: TROUBLESHOOTING AREA - SETTINGS - ADDON SOLUTIONS - ADD AND DELETE AIRWATCH IN UI - VERIFY AUDIT TRAIL LOG **********" do

	include_examples "test add-on solutions settings", 'www.airwatchmdm.gov', "3356744821", "test_user", "password"
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Add-ons: Third Party Configuration"], 1

	include_examples "test add-on solutions settings", "", "", "", ""
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Add-ons: Third Party Configuration"], 1

end