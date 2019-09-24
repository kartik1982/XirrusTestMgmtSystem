require_relative "../local_lib/groups_lib.rb"
require_relative "../../environment_variables_library.rb"
########################################################################################################################
##################TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD, EDIT then DELETE GROUPS###############################
########################################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD, EDIT then DELETE GROUPS **********" do 

	include_examples "go to groups tab"
	include_examples "delete all groups from the grid"

	group_names = ["No APs copied", "Copy only one AP"] 
	group_descriptions = ["TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy only one AP"] 
	group_description_for_change = group_descriptions[0]
	group_access_points = Hash[0 => "", 1 => "Auto-XR320-3"] 

	group_names.each_with_index do |group_name, i|
		include_examples "add a group", group_name, group_descriptions[i], group_access_points[i]
	end

	tile_elements = Hash["Status" => ["good", "warning"], "Reason" => [nil, "reason0"], "Warning Message" => [nil, "Site Down"]]
	tile_elements_detailed_view = Hash["Status" => ["OK", "Critical"], "Icon" => ["dash_arrays", "AP_warning_grey"], "APs" => ["0 APs", "Site Down"]]

	group_names.each_with_index do |group_name, i|
		include_examples "verify group tile elements", group_name, tile_elements["Status"][i], tile_elements["Reason"][i], tile_elements["Warning Message"][i]
		include_examples "verify dashboard domain detailed view", "AP Groups", group_name, tile_elements_detailed_view["Status"][i], tile_elements_detailed_view["Icon"][i], tile_elements_detailed_view["APs"][i]
	end


	edit_values_hash = Hash["Group Name" => nil, "Group Description" => group_description_for_change + " now 1 AP assigned", "Group AP(s)" => ["Auto-XR320-2"]]#return_proper_value_based_on_the_used_environment($the_environment_used, "mynetwork/access_points_tab/groups/", "1 tenant array")]

	include_examples "edit group", "Tile view", group_names[0], edit_values_hash

	include_examples "verify group tile elements", group_names[0], "warning", "reason0", "Site Down"
	include_examples "verify dashboard domain detailed view", "AP Groups", group_names[0], "Critical", "AP_warning_grey", "Site Down"

	edit_values_hash = Hash["Group Name" => nil, "Group Description" => nil, "Group AP(s)" => ["Auto-XR320-3", "Auto-XR320-2"]]#return_proper_value_based_on_the_used_environment($the_environment_used, "mynetwork/access_points_tab/groups/", "2 tenants")]

	include_examples "edit group", "Tile view", group_names[0], edit_values_hash

	include_examples "verify group tile elements", group_names[0], "warning", "reason0", "Site Down"
	include_examples "verify dashboard domain detailed view", "AP Groups", group_names[0], "Critical", "AP_warning_grey", "Site Down"

	include_examples "go to groups tab"

end