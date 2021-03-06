require_relative "../local_lib/localized_time_display_lib.rb"
require_relative "../../TS_Troubleshooting/local_lib/troubleshooting_lib.rb"
###################################################################################################################################
##############TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab##############
###################################################################################################################################
describe "********** TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab **********" do
	verify_timezones = false
	date_formats = ["MM/DD/YYYY", "DD/MM/YYYY", "YYYY/MM/DD", "MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD", "MM.DD.YYYY", "DD.MM.YYYY", "YYYY.MM.DD"]
	time_formats = ["12 hour", "24 hour"]
	css_of_string = ".nssg-tbody tr:first-child td:nth-child(2) .nssg-td-text"
	date_formats.each do |date_format|
		include_examples "verify date time format", "Troubleshooting - Audit Trail",  "go to the troubleshooting area", css_of_string, date_format, time_formats.sample
	end
end