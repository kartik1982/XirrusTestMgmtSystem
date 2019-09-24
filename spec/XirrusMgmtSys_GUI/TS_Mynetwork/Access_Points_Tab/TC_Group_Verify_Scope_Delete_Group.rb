require_relative "../local_lib/groups_lib.rb"
require_relative "../../environment_variables_library.rb"
########################################################################################################################
##################TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD, EDIT then DELETE GROUPS################################
########################################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD, EDIT then DELETE GROUPS **********" do # Created on : 26/04/2017

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"

	group_names = ["No APs copied", "Copy only one AP"] 
	group_descriptions = ["TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy only one AP"] 
	group_access_points = Hash[0 => "", 1 => "Auto-XR320-3"] 

		group_names.each_with_index do |group_name, i|
			include_examples "add a group", group_name, group_descriptions[i], group_access_points[i]
		end

		include_examples "verify group tile elements", group_names[1], "Critical", "AP_warning_grey", "Site Down"
		include_examples "verify dashboard group container controls", "View", "AP Groups", group_names[1], "Critical", "AP_warning_grey", "Site Down", 1 

		include_examples "go to groups tab"

		include_examples "verify access points tab filter value", "All Devices"

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"
		
end