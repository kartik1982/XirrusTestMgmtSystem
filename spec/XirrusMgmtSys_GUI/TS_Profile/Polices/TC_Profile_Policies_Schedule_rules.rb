require_relative "../local_lib/policies_lib.rb"
#################################################################################################################################
###############TEST CASE: Test the Profile - POLICIES TAB - TEST SCHEDULING for POLICY and RULES#################################
#################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - TEST SCHEDULING for POLICY and RULES **********" do

	include_examples "delete all profiles from the grid"

	profile_name = "Test profile for Policies tab - SCHEDULE RULES - LAYER 2, 3 and 7"
	profile_descriptiion = "Profile description for : " + profile_name

	include_examples "create a profile and an ssid inside that profile", profile_name, profile_descriptiion, false, "SSID Policy"

    policy_types = ["Personal SSID Policy", "SSID Policy", "Global Policy", "Device Policy", "User Group Policy"]
    policy_types.each { |policy_type|
    	rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)

    	policy_device_class = ""
    	if policy_type == "Device Policy"
    		policy_name = "Game"
    		policy_device_class = "Game"
            policy_device_type = "All Game Types"
    	elsif policy_type == "User Group Policy"
    		policy_name = "UG TEST"
    	elsif policy_type == "Personal SSID Policy"
            policy_name = "Personal SSID Policy"
        elsif policy_type == "SSID Policy"
    		policy_name = "SSID Policy"
    	end
	    include_examples "create a rule for any policy", policy_type, policy_name, policy_device_class, policy_device_type, "firewall", rule_name, true, "allow", "2", "ANY", "ANY", "Any", "Any", true, "DSCP", "", ""
	    include_examples "search for rule and verify it", rule_name, "firewall", "allow", "2", "ANY", "ANY", "Any", "Any", true, false, false, ""
	    include_examples "schedule rule and verify it", rule_name, "firewall", "2", "W", "5:00am", "8:00pm", false, false#, profile_name

		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", policy_type, policy_name, policy_device_class, policy_device_type, "firewall", rule_name, true, "allow", "3", "ANY", "ANY", "Any", "Any", true, "DSCP", "", ""
	    include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY", "ANY", "Any", "Any", true, false, false, ""
	    include_examples "schedule rule and verify it", rule_name, "firewall", "3", "W", "5:00am", "8:00pm", false, false#, profile_name
		include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", "ANY", "ANY", "Any", "Any", true, false, false, "W - 5:00am - 8:00pm"

		rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	    include_examples "create a rule for any policy", policy_type, policy_name, policy_device_class, policy_device_type, "application", rule_name, true, "block", "2", "ICMP", "IRC", "Any", "Any", true, "", "Games", "All Games Apps"
		include_examples "search for rule and verify it", rule_name, "application", "block", "7", "Games", "All Games Apps", "", "", true, false, false, ""
		include_examples "schedule rule and verify it", rule_name, "application", "7", "W", "5:00am", "8:00pm", false, false#, profile_name
	    include_examples "search for rule and verify it", rule_name, "application", "block", "7", "Games", "All Games Apps", "", "", true, false, false, "W - 5:00am - 8:00pm"

    }


end