require_relative "./local_lib/settings_lib.rb"
require_relative "../TS_Portal/local_lib/portal_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Profile/local_lib/policies_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
######################################################################################################################################
######################TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES - Mainline vs. Technology feature##########################
######################################################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - FIRMWARE UPGRADES - Mainline vs. Technology feature **********" do

	type_of_testing = "POSITIVE"
	profile_name = "FIRMWARE UPGRADES TEST Profile - " + UTIL.ickey_shuffle(9)
	ssid_name = "Test SSID Firm.Upgd. - " + UTIL.ickey_shuffle(9)
	rule_name = "Test Rule - " + UTIL.ickey_shuffle(6)

	include_examples "test content filtering settings", "", "", type_of_testing

	include_examples "create profile from header menu", profile_name, "Profile description", false
	include_examples "add profile ssid", profile_name, ssid_name
	include_examples "create a rule for any policy", "SSID Policy", ssid_name, "", "", "firewall", rule_name, true, "allow", "2", "ANY", "ANY", "Any", "Any", true, "QoS", "", ""
	include_examples "search for rule and verify it", rule_name, "firewall", "allow", "2", "ANY", "ANY", "Any", "Any", true, false, false, ""

	include_examples "go to settings then to tab", "Firmware Upgrades"
 	include_examples "change default firmware for new domains", "Technology"

 	#include_examples "verify facebook portal enabled disabled", "enabled"

 	include_examples "go to profile", profile_name
 	include_examples "verify ssid policy content filtering", "disabled", ""

 	include_examples "go to settings then to tab", "Firmware Upgrades"
 	include_examples "change default firmware for new domains", "Mainline"

 	include_examples "go to profile", profile_name
 	include_examples "verify ssid policy content filtering", "disabled", ""

 	include_examples "test content filtering settings", "1.1.1.1", "", type_of_testing

 	include_examples "go to profile", profile_name
 	include_examples "verify ssid policy content filtering", "enabled", "on"
 	include_examples "verify ssid policy content filtering", "enabled", "off"

	include_examples "go to settings then to tab", "Firmware Upgrades"
 	include_examples "change default firmware for new domains", "Technology"

 	include_examples "go to profile", profile_name
 	include_examples "verify ssid policy content filtering", "enabled", "on"
 	include_examples "verify ssid policy content filtering", "enabled", "off"

 	include_examples "test content filtering settings", "2.2.2.2", "3.4.5.6", type_of_testing

 	include_examples "go to profile", profile_name
 	include_examples "verify ssid policy content filtering", "enabled", "on"
 	include_examples "verify ssid policy content filtering", "enabled", "off"

	include_examples "go to settings then to tab", "Firmware Upgrades"
	include_examples "change default firmware for new domains", "Mainline"
	include_examples "go to profile", profile_name

	#include_examples "verify facebook portal enabled disabled", "disabled"

	include_examples "go to profile", profile_name
 	include_examples "verify ssid policy content filtering", "enabled", "on"
 	include_examples "verify ssid policy content filtering", "enabled", "off"

	include_examples "test content filtering settings", "", "", type_of_testing

end