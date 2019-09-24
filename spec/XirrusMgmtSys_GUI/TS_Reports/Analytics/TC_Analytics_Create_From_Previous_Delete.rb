require_relative "../local_lib/analytics_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/groups_lib.rb"
#############################################################################################################
##############TEST CASE: REPORTS - ANALYTICS - CREATE FROM PREVIOUS MENU THEN DELETE#########################
#############################################################################################################
describe "********** TEST CASE: REPORTS - ANALYTICS - CREATE FROM PREVIOUS MENU THEN DELETE **********" do # Created on: 05/05/2017

	include_examples "go to analytics area"

	vname = "Number of Visitors " + UTIL.ickey_shuffle(9)
	type_of_data = "Number of Visitors"
	group = "All Access Points"
	date_from = "5/14/2017" #Hash["Year" => 2017, "Month" => "May", "Date" => 14, "Formated Date" => "5/14/2017"]
	date_to = "5/18/2017" #Hash["Year" => 2017, "Month" => "May", "Date" => 18, "Formated Date" => "5/18/2017"]
	expected_data = Hash["Visitors" => "0", "Visits" => "0", "Median Visit" => nil]

	include_examples "add a visualization widget", vname, type_of_data, group, date_from, date_to, true, false
	include_examples "verify widget", type_of_data, type_of_data, group, date_from, date_to, expected_data

	include_examples "verify analytics landing page", false, 1

	include_examples "action on widget", type_of_data, "Delete", nil, nil, nil, nil, nil, nil

	include_examples "go to groups tab"
	include_examples "go to analytics area"
	include_examples "verify analytics landing page", true, nil

	include_examples "add a visualization widget", vname, type_of_data, group, date_from, date_to, true, true
	include_examples "verify widget", type_of_data, type_of_data, group, date_from, date_to, expected_data

	include_examples "verify analytics landing page", false, 1

	include_examples "action on widget", type_of_data, "Delete", nil, nil, nil, nil, nil, nil

end

