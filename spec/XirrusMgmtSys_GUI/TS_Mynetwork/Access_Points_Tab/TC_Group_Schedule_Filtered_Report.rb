require_relative "../local_lib/groups_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "../../TS_Reports/local_lib/reports_lib.rb"
require_relative "../../environment_variables_library.rb"
###############################################################################################################################################################
#################TEST CASE: MY NETWORK AREA - GROUPS TAB - FROM PROFILE - ADD GROUP - VERIFY A REPORT CAN BE SCHEDULED AS FILTERED BY THAT GROUP###############
###############################################################################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - FROM PROFILE - ADD GROUP - VERIFY A REPORT CAN BE SCHEDULED AS FILTERED BY THAT GROUP **********" do # Created on : 27/04/2017

	group_name = "Copy only one AP"
	group_description = "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy only one AP"
	report_name = "Verify Groups Fitering and Email Scheduling " + UTIL.ickey_shuffle(5)
	report_description = "Description for report - " + report_name
	report_page = "Top Clients by usage"
	time_format = "24 hour"
    include_examples "delete all reports except for pre-canned"
		include_examples "set timezone area to specific one", "(GMT-11:00) Midway Island, Samoa"
		include_examples "set date time format to specific", nil, time_format

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"
		include_examples "add a group", group_name, group_description, "Auto-XR320-3" 
		include_examples "verify group", group_name, Hash["Access Point Count" => "1", "Description" => group_description]

		include_examples "create report from header menu", report_name, report_description
		include_examples "edit report from report menu", report_name, report_description, report_page, "Last Hour"
		include_examples "report custom view no changes to dates only set", report_name, report_page, group_name
		objects_hash = Hash["email_address" => "test_001@email.com", "see_recurring" => true, "make_recurring" => true, "time_span" => "Weekly", "time_span_day" => "Tuesday", "time_span_which_day" => "", "hour" => "8:48 pm", "offset" => "(GMT+09:30) Adelaide"]
    	include_examples "set email report", objects_hash["email_address"], objects_hash["see_recurring"], objects_hash["make_recurring"], objects_hash["time_span"], objects_hash["time_span_day"], objects_hash["time_span_which_day"], objects_hash["hour"], objects_hash["offset"], false

		email_address = "test_001@email.com"
		action = "invoke"
		email_address_new = ""
		see_recurring = true
		make_recurring = true

		recurring_on = "Weekly, Tuesday, 20:48" + " #{objects_hash["offset"]}"
		time_span = "Weekly"
		time_span_day = "Monday"
		time_span_which_day = "Second"
		hour = "11:22 pm"
		offset = "(GMT+02:00) Jerusalem"
		verify_recurring_on = "Weekly, Monday, 23:22" + " #{offset}"

		include_examples "verify reports scheduled tab"
		include_examples "certain action on scheduled report line", email_address, report_name, recurring_on, group_name, action, email_address_new, see_recurring, make_recurring, time_span, time_span_day, time_span_which_day, hour, offset, verify_recurring_on

		include_examples "go to groups tab"
		include_examples "delete all groups from the grid"

		include_examples "set timezone area to local"
		include_examples "set date time format to specific", nil, "12 hour"

end