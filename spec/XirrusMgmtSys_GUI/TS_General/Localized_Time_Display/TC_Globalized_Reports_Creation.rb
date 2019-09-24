require_relative "../local_lib/localized_time_display_lib.rb"
require_relative "../../TS_Troubleshooting/local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Reports/local_lib/reports_lib.rb"
require_relative "../../TS_Reports/local_lib/analytics_lib.rb"
###################################################################################################################################
##############TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab#############
###################################################################################################################################
describe "********** TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab **********" do
	report_name = "Report for Date/Time format verification " + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9)
	include_examples "create report from header menu", report_name, "Description for: " + report_name

	verify_timezones = false
	date_formats = ["MM/DD/YYYY", "DD/MM/YYYY", "YYYY/MM/DD", "MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD", "MM.DD.YYYY", "DD.MM.YYYY", "YYYY.MM.DD"]
	time_formats = ["12 hour", "24 hour"]
	css_of_string = ".report-preview-body .report-cover-info div"
	date_formats.each do |date_format|
		include_examples "verify date time format", "Reports - Creation, Edit", ["go to a specific report" , report_name], css_of_string, date_format, time_formats.sample
	end
	include_examples "delete report from report menu", report_name
end