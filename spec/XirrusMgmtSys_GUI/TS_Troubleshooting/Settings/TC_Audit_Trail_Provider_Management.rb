require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
#################################################################################################################################################################
#############TEST CASE: TROUBLESHOOTING AREA - SETTINGS - PROVIDER MANAGEMENT - ADD, EDIT AND DELETE MOBILE CARRIER IN UI - VERIFY AUDIT TRAIL LOG##############
#################################################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - SETTINGS - PROVIDER MANAGEMENT - ADD, EDIT AND DELETE MOBILE CARRIER IN UI - VERIFY AUDIT TRAIL LOG **********" do

	provider_name = "Iceland_" + UTIL.ickey_shuffle(5)

	include_examples "go to settings then to tab", "Provider Management"
	include_examples "add mobile provider", provider_name , "iceland.cold.com", "Iceland", "TEST", "TEST"
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "CREATE", Array["Mobile Carrier: "+provider_name], 1

	include_examples "go to settings then to tab", "Provider Management"
	include_examples "edit certain mobile provider", provider_name, "", "iceland.cold.com", "", "NEWTEST", "NEWEND"
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Mobile Carrier: "+provider_name], 1

	include_examples "go to settings then to tab", "Provider Management"
	include_examples "edit certain mobile provider", provider_name, "New_" + provider_name, "iceland.cold.com", "", "NEWTEST", "NEWEND"
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Mobile Carrier: "+ "New_" + provider_name], 1

	include_examples "go to settings then to tab", "Provider Management"
	include_examples "delete mobile provider", "New_" + provider_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "DELETE", Array["Mobile Carrier: "+ "New_" + provider_name], 1

end