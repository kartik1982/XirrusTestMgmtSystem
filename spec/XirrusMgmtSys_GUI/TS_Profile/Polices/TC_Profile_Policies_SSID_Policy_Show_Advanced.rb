require_relative "../local_lib/policies_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
###############################################################################################################
############TEST CASE: Test the Profile - POLICIES TAB - USER GROUP POLICY - SHOW ADVANCED CONTROLS############
###############################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - USER GROUP POLICY - SHOW ADVANCED CONTROLS **********" do

	profile_name = "Test profile for Policies tab - SSID policy - Show Advanced"
	profile_descriptiion = "Profile description for : " + profile_name
	advance_config={policy_type: "SSID Policy", default_Qos: "3", traffic_per_ap: "50", traffic_per_ap_unit: "Kbps", traffic_per_client: "100", traffic_per_client_unit: "packets/sec", client_count_limit: "Limited", client_count: "200", content_filter: "", station_traffic: "Block"}
	#Delete all profiles
	include_examples "delete all profiles from the grid"
	#Set firmware to technology build
	include_examples "go to settings then to tab", "Firmware Upgrades"
  include_examples "change default firmware for new domains", "Technology"
  #Create Profile with ssid
	include_examples "create a profile and an ssid inside that profile", profile_name, profile_descriptiion, false, "SSID Policy"	
  #Create rule and config basic
  rule_name = "Rule_number_" + UTIL.ickey_shuffle(5)
  include_examples "create a rule for any policy", "SSID Policy", "SSID Policy", "", "", "firewall", rule_name, true, "allow", "3", "ANY", "ANY", "Any", "Any", true, "QoS", "", ""
  include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY", "ANY", "Any", "Any", true, false, false, ""
  #Configure and Verify Policy Advance settings
  include_examples "configure and verify policy advanced settings", advance_config
  #Profile save without error 
  include_examples "verify that the profile is properly saved"  
  
end