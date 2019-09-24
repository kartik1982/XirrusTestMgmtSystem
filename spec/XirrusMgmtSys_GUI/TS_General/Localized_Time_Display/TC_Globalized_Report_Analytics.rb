require_relative "../local_lib/localized_time_display_lib.rb"
require_relative "../../TS_Troubleshooting/local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Reports/local_lib/reports_lib.rb"
require_relative "../../TS_Reports/local_lib/analytics_lib.rb"
###################################################################################################################################
##############TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab##############
###################################################################################################################################
describe "********** TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab **********" do

	include_examples "set date time format to specific", "MM/DD/YYYY", "12 hour"

	include_examples "go to analytics area"

	vname = "Number of Visitors"
	type_of_data = "Number of Visitors"
	group = "All Access Points"
	date_from = "5/14/2017" #Hash["Year" => 2017, "Month" => "May", "Date" => 14, "Formated Date" => "5/14/2017"]
	date_to = "5/18/2017" # Hash["Year" => 2017, "Month" => "May", "Date" => 18, "Formated Date" => "5/18/2017"]
	expected_data = Hash["Visitors" => "0", "Visits" => "0", "Median Visit" => nil]

	include_examples "add a visualization widget", vname, type_of_data, group, date_from, date_to, true, false

	include_examples "verify analytics landing page", false, 1

	verify_timezones = false
	date_formats = ["MM/DD/YYYY", "DD/MM/YYYY", "YYYY/MM/DD", "MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD", "MM.DD.YYYY", "DD.MM.YYYY", "YYYY.MM.DD"]
	time_formats = ["12 hour", "24 hour"]
	css_of_string = ".widgets-list .xc-widget-container-header .timespan"
	date_formats.each do |date_format|
		include_examples "verify date time format", "Reports - Analytics", "go to analytics area", css_of_string, date_format, time_formats.sample
	end

end