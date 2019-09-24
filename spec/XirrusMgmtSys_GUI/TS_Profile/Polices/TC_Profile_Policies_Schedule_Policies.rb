require_relative "../local_lib/policies_lib.rb"
#################################################################################################################################
###############TEST CASE: Test the Profile - POLICIES TAB - TEST SCHEDULING for POLICY and RULES################################
#################################################################################################################################
describe "********** TEST CASE: Test the Profile - POLICIES TAB - TEST SCHEDULING for POLICY and RULES **********" do

	include_examples "delete all profiles from the grid"

    profile_name = "Test profile for Policies tab - SCHEDULE POLICIES"
	profile_descriptiion = "Profile description for : " + profile_name

	include_examples "create a profile and an ssid inside that profile", profile_name, profile_descriptiion, false, "TEST"

    policy_types = ["Personal SSID Policy", "SSID Policy", "Device Policy", "User Group Policy"]

    policy_types.each { |policy_type|
    	rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
    	if policy_type == "Device Policy"
    		policy_name = "Game"
    		policy_device_class = "Game"
            policy_device_type = "All Game Types"
    	elsif policy_type == "SSID Policy"
    		policy_name = "TEST"
    		policy_device_class = ""
    	else
    		policy_name = "Policy_name_" + UTIL.ickey_shuffle(6)
    		policy_device_class = ""
    	end
		include_examples "create schedule for all policy types", policy_type, policy_name, policy_device_class, "M", "10:00am", "5:00pm", false
    }



end