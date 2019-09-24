require_relative "../local_lib/groups_lib.rb"
require_relative "../local_lib/dashboard_lib.rb"
require_relative "../local_lib/dashboard_tiles_lib.rb"
require_relative "../../environment_variables_library.rb"
#######################################################################################################################################################################
###############TEST CASE: MY NETWORK AREA - GROUPS TAB - FROM PROFILE - ADD GROUPS - VERIFY THE DASHBOARD AREA WHEN NAVIGATING TO AND FROM ANOTHER AREA################
#######################################################################################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - FROM PROFILE - ADD GROUPS - VERIFY THE DASHBOARD AREA WHEN NAVIGATING TO AND FROM ANOTHER AREA **********" do # Created on : 27/04/2017

	locations = ["Profiles","Access Points","Reports","MyNetwork / Access Points tab","MyNetwork / Clients tab","MyNetwork / Alerts tab","MyNetwork / Floor Plans tab","Settings / Support Management","Settings / Troubleshooting","Settings / Settings","Settings / Contact us"] #"Settings / Command Center",

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"

	group_name = "Copy only one AP"
	group_description = "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy only one AP"

		include_examples "add a group", group_name, group_description, "Auto-XR320-3" 

		include_examples "verify group", group_name, Hash["Access Point Count" => "1", "Description" => group_description]

		include_examples "change to a certain profile from dashboard", group_name
		include_examples "verify dashboard data", "#dashboard4", "1", "0", "1"
		locations.each { |location|
			include_examples "change locations and back to dashboard", group_name , location, true
		}

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"


end