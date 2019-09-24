require_relative "../local_lib/groups_lib.rb"
require_relative "../local_lib/ap_lib.rb"
require_relative "../local_lib/dashboard_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profile/local_lib/ap_lib.rb"
require_relative "../../environment_variables_library.rb"
############################################################################################################################
###############TEST CASE: MY NETWORK AREA - GROUPS TAB - FROM PROFILE - ADD, EDIT then DELETE GROUPS########################
############################################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - FROM PROFILE - ADD, EDIT then DELETE GROUPS **********" do # Created on : 26/04/2017

	profile_name = "Profile for testing groups and APs " + UTIL.ickey_shuffle(9)

		include_examples "create profile from header menu", profile_name, "TEST PROFILE - Created to verify testing groups and APs", false
		include_examples "go to mynetwork access points tab"
		include_examples "add access point to profile", profile_name, "Auto-XR320-3" 
		include_examples "add access point to profile", profile_name, "Auto-XR320-2"

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"

	group_names = ["No APs copied", "Copy only one AP"]
	group_descriptions = ["TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy only one AP"]
	group_description_for_change = group_descriptions[1]
	group_access_points = Hash[0 => "", 1 => ["Change Search", profile_name, "Auto-XR320-2"]]

		group_names.each_with_index do |group_name, i|
			include_examples "add a group", group_name, group_descriptions[i], group_access_points[i]
		end

	edit_values_hash = Hash["Group Name" => nil, "Group Description" => group_description_for_change + " now other AP is assigned", "Group AP(s)" => ["Change Search", profile_name, "Auto-XR320-2"]]#return_proper_value_based_on_the_used_environment($the_environment_used, "mynetwork/access_points_tab/groups/", "1 tenant second")]]

		include_examples "edit group", "Grid view", group_names[1], edit_values_hash

	edit_values_hash = Hash["Group Name" => nil, "Group Description" => group_description_for_change, "Group AP(s)" => [""]]

		include_examples "edit group", "Grid view", group_names[1], edit_values_hash

		group_names.each_with_index do |group_name, i|
			group_verify = [Hash["Access Point Count" => "0", "Description" => group_descriptions[i], "Status" => "OK"], Hash["Access Point Count" => "0", "Description" => group_descriptions[i]]]
			include_examples "verify group", group_name, group_verify[i]
		end

		include_examples "delete all groups from the grid"

		include_examples "delete profile tile", profile_name

end