require_relative "../local_lib/analytics_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/groups_lib.rb"
#############################################################################################################
##############TEST CASE: REPORTS - ANALYTICS - GENERAL FEATURES############################################
#############################################################################################################
describe "********** TEST CASE: REPORTS - ANALYTICS - GENERAL FEATURES **********" do # Created on: 05/02/2017

	group_name = "Copy only one AP"
	group_description = "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy only one AP"

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"
		include_examples "add a group", group_name, group_description, ""
		include_examples "verify group", group_name, Hash["Access Point Count" => "0", "Description" => group_description]

	vname = "Number of Visitors"
	type_of_data = "Number of Visitors"
	date_from = "5/14/2017" #Hash["Year" => 2017, "Month" => "May", "Date" => 14, "Formated Date" => "5/14/2017"]
	date_to = "5/18/2017" #Hash["Year" => 2017, "Month" => "May", "Date" => 18, "Formated Date" => "5/18/2017"]
	expected_data = "No data available"

		include_examples "add a visualization widget", vname, type_of_data, group_name, date_from, date_to, true, false
		include_examples "verify widget", vname, type_of_data, group_name, date_from, date_to, expected_data

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"

		include_examples "go to analytics area"
		include_examples "verify analytics landing page", false, 1

		include_examples "verify widget", vname, type_of_data, group_name, date_from, date_to, expected_data

end