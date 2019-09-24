require_relative "../local_lib/groups_lib.rb"
require_relative "../local_lib/dashboard_lib.rb"
require_relative "../../environment_variables_library.rb"
#############################################################################################################################################
###############TEST CASE: MY NETWORK AREA - GROUPS TAB - FROM PROFILE - ADD GROUPS - VERIFY THE DASHBOARD AREA###############################
#############################################################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - FROM PROFILE - ADD GROUPS - VERIFY THE DASHBOARD AREA **********" do

	locations = ["Profiles","Access Points","Reports","MyNetwork / Access Points tab","MyNetwork / Clients tab","MyNetwork / Alerts tab","MyNetwork / Floor Plans tab","Settings / Support Management","Settings / Troubleshooting","Settings / Settings","Settings / Contact us"] #"Settings / Command Center",

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"

	group_names = ["No APs copied", "Copy only one AP"]
	group_descriptions = ["TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy only one AP"]
	group_access_points = Hash[0 => "", 1 => "Auto-XR320-3"]

		group_names.each_with_index do |group_name, i|
			include_examples "add a group", group_name, group_descriptions[i], group_access_points[i]
		end

		group_names.each_with_index do |group_name, i|
			group_verify = [Hash["Access Point Count" => "0", "Description" => group_descriptions[i], "Status" => "OK"], Hash["Access Point Count" => "1", "Description" => group_descriptions[i]]]
			include_examples "verify group", group_name, group_verify[i]
		end

		include_examples "change to a certain profile from dashboard", group_names[0]
		include_examples "verify dashboard data", "#dashboard4", "0", "0", "0"

		include_examples "change to a certain profile from dashboard", group_names[1]
		include_examples "verify dashboard data", "#dashboard4", "1", "0", "1"
		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"


end