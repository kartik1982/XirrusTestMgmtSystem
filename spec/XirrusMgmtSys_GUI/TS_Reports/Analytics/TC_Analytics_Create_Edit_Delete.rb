require_relative "../local_lib/analytics_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/groups_lib.rb"
#############################################################################################################
##############TEST CASE: REPORTS - ANALYTICS - GENERAL FEATURES##############################################
#############################################################################################################
describe "********** TEST CASE: REPORTS - ANALYTICS - GENERAL FEATURES **********" do # Created on: 05/04/2017

	include_examples "go to analytics area"
	include_examples "verify add edit widget modal", true, true
	include_examples "verify analytics landing page", true, nil

	vname = "Number of Visitors"
	type_of_data = "Number of Visitors"
	group = "All Access Points"
	date_from = "5/14/2017" #Hash["Year" => 2017, "Month" => "May", "Date" => 14, "Formated Date" => "5/14/2017"]
	date_to = "5/18/2017" #Hash["Year" => 2017, "Month" => "May", "Date" => 18, "Formated Date" => "5/18/2017"]
	expected_data = Hash["Visitors" => "0", "Visits" => "0", "Median Visit" => nil]

	include_examples "add a visualization widget", vname, type_of_data, group, date_from, date_to, true, false
	include_examples "verify widget", vname, type_of_data, group, date_from, date_to, expected_data

	include_examples "verify analytics landing page", false, 1


	include_examples "action on widget", vname, "Delete", nil, nil, nil, nil, nil, nil

	include_examples "go to groups tab"
	include_examples "go to analytics area"
	include_examples "verify analytics landing page", true, nil

end