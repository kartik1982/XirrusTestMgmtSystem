require_relative "./local_lib/eircom_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/policies_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/lookfeel_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_XMSE/local_lib/xmse_lib.rb"
#####################################################################################################################################################
#################TEST CASE: EIRCOM - Test the SETTINGS area - ADD-ON SOLUTIONS TAB - WEB TITAN - NEGATIVE TESTING - INCORRECT CONFIGURATIONS########
#####################################################################################################################################################
describe "********** TEST CASE: EIRCOM - Test the SETTINGS area - ADD-ON SOLUTIONS TAB - WEB TITAN - NEGATIVE TESTING - INCORRECT CONFIGURATIONS **********" do

	profile_name = "Eircom profile for testing Web Titan - negative 1"
	profile_description = "DESCRIPTION"
	ssid_name = 'SSID test of AOS Light Profile'
	rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)

	# Web Titan
	include_examples "go to settings then to tab", "Firmware Upgrades"
 	include_examples "change default firmware for new domains", "Technology"

	include_examples "addon solutions deactivation of web titan"
	include_examples "create profile from header menu", profile_name , profile_description, false
	include_examples "add profile ssid", profile_name, ssid_name
	include_examples "create a rule for any policy", "SSID Policy", ssid_name, "", "", "firewall", rule_name, true, "allow", "2", "ANY", "ANY", "Any", "Any", true, "QoS", "", ""
	include_examples "addon solutions profile cannot set web titan on if it is not configured", profile_name
	include_examples "delete profile from tile", profile_name

end