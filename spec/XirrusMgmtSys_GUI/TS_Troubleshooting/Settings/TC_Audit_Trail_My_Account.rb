require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
##############################################################################################################################
################TEST CASE: TROUBLESHOOTING AREA - SETTINGS - MY ACCOUNT - VERIFY AUDIT TRAIL LOG#############################
##############################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - SETTINGS - MY ACCOUNT - VERIFY AUDIT TRAIL LOG **********" do

	include_examples "set date time format to specific", "MM/DD/YYYY", "12 hour"
	include_examples "go to settings then to tab", "My Account"
	include_examples "ensure no checkboxes are ticked"
	include_examples "edit description field", "Description string."
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["User: " + "adinte+automation"], 1

	alerts_hash = Hash["Access Point lost connectivity" => "Email", "Station Count" => "SMS", "DHCP Failure" => "Email", "Profile Access Point lost connectivity" => "SMS"]

	alerts_hash.keys.each do |key|
		include_examples "tick certain checkbox on my account", key, alerts_hash[key], "Check"
		include_examples "go to the troubleshooting area"
		include_examples "perform action verify audit trail", "UPDATE", Array["Alert Notification: for " + key], 1
		include_examples "tick certain checkbox on my account", key, alerts_hash[key], "Uncheck"
	end
end