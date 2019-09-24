require_relative "../local_lib/groups_lib.rb"
require_relative "../local_lib/dashboard_lib.rb"
require_relative "../../environment_variables_library.rb"
#################################################################################################################
###############TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD, EDIT then DELETE GROUPS############################
#################################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD, EDIT then DELETE GROUPS **********" do # Created on : 26/04/2017

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"

	group_names = ["No APs copied", "Copy only one AP", "Copy 3 APs", "ALL COPIED"]
	group_descriptions = ["TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy only one AP", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy 3 APs", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: ALL COPIED"]
	group_description_for_change = group_descriptions[0]
	group_access_points = Hash[0 => "", 1 => "Auto-XR320-3", 2 => ["Auto-XR320-1", "Auto-X2-120-1", "Auto-XR520-1"], 3 => "Copy All"]

		group_names.each_with_index do |group_name, i|
			include_examples "add a group", group_name, group_descriptions[i], group_access_points[i]
		end

	edit_values_hash = Hash["Group Name" => nil, "Group Description" => group_description_for_change + " now 1 AP assigned", "Group AP(s)" => ["Auto-XR320-2"]]

		include_examples "edit group", "Grid view", group_names[0], edit_values_hash

	edit_values_hash = Hash["Group Name" => nil, "Group Description" => nil, "Group AP(s)" => ["Auto-XR320-3", "Auto-XR320-2"]]

		include_examples "edit group", "Grid view", group_names[0], edit_values_hash

	edit_values_hash = Hash["Group Name" => nil, "Group Description" => group_description_for_change, "Group AP(s)" => [""]]

		include_examples "edit group", "Grid view", group_names[0], edit_values_hash

		group_names.each_with_index do |group_name, i|
			group_verify = [Hash["Access Point Count" => "0", "Description" => group_descriptions[i], "Status" => "OK"], Hash["Access Point Count" => "1", "Description" => group_descriptions[i], "Status" => "Critical: 1 access point down"], Hash["Access Point Count" => "3", "Description" => group_descriptions[i], "Status" => "Critical: 3 access points down"], Hash["Access Point Count" => "16", "Description" => group_descriptions[i], "Status" => "Critical: " + "16" + " access points down"]]
			include_examples "verify group", group_name, group_verify[i]
		end

		include_examples "delete all groups from the grid"

end