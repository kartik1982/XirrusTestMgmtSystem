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
#################TEST CASE: EIRCOM - Test the SETTINGS area - ADD-ON SOLUTIONS TAB - WEB TITAN - NEGATIVE TESTING - NOT ENOUGH SPACE TO ADD##########
#####################################################################################################################################################
describe "********** TEST CASE: EIRCOM - Test the SETTINGS area - ADD-ON SOLUTIONS TAB - WEB TITAN - NEGATIVE TESTING - NOT ENOUGH SPACE TO ADD **********" do

	profile_name = "Eircom profile for testing Web Titan - no space to add"
	profile_description = "DESCRIPTION"
	ssid_name = 'SSID Policy'

	# Web Titan

	include_examples "addon solutions deactivation of web titan"
	include_examples "create profile from header menu", profile_name, "DESCRIPTION", false
	include_examples "add profile ssid", profile_name, ssid_name
	include_examples "addon solutions activation of web titan", "1.1.1.1"
	include_examples "go to profile and policies tab", profile_name
	(1..25).each do
		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
		include_examples "create a rule for any policy", "SSID Policy", ssid_name, "", "", "firewall", rule_name, true, "allow", "2", "ANY", "ANY", "Any", "Any", true, "QoS", "", ""
	end
   	include_examples "addon solutions web titan on profile after maxed out rules per policy", profile_name
	include_examples "addon solutions deactivation of web titan"
	include_examples "delete profile from tile", profile_name



end