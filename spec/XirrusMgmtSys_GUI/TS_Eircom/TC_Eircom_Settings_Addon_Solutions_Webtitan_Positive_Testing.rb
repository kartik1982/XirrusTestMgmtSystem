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
#######################################################################################################################
#################TEST CASE: EIRCOM - Test the SETTINGS area - ADD-ON SOLUTIONS TAB - WEB TITAN - POZITIVE TESTING######
#######################################################################################################################
describe "********** TEST CASE: EIRCOM - Test the SETTINGS area - ADD-ON SOLUTIONS TAB - WEB TITAN - POZITIVE TESTING **********" do

	profile_name = "Eircom profile for testing Web Titan - positive"
	profile_description = "DESCRIPTION"
	ssid_name = 'SSID test of AOS Light Profile'
	rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)

	# Web Titan

	include_examples "addon solutions deactivation of web titan"
	include_examples "create profile from header menu", profile_name, "DESCRIPTION", false
	include_examples "add profile ssid", profile_name, ssid_name
	include_examples "addon solutions activation of web titan", "1.1.1.1"
	include_examples "go to profile and policies tab", profile_name
	include_examples "create a rule for any policy", "SSID Policy", ssid_name, "", "", "firewall", rule_name, true, "allow", "2", "ANY", "ANY", "Any", "Any", true, "QoS", "", ""
  include_examples "search for rule and verify it", rule_name, "firewall", "allow", "2", "ANY", "ANY", "Any", "Any", true, false, false, ""
	include_examples "addon solutions profile can be set to web titan on if it is configured", profile_name
	include_examples "search for rule and verify it" , "WebTitan.1", "firewall", "allow", "3", "ANY-IP", "53", "Any", "Any", true, false, true, ""
	include_examples "delete profile from tile", profile_name

end