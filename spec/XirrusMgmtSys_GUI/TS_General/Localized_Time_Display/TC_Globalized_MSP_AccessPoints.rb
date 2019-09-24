require_relative "../local_lib/localized_time_display_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
##############################################################################################################################
##############TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab#########
##############################################################################################################################
describe "********** TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab **********" do

	verify_timezones = false
	date_formats = ["MM/DD/YYYY", "DD/MM/YYYY", "YYYY/MM/DD", "MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD", "MM.DD.YYYY", "DD.MM.YYYY", "YYYY.MM.DD"]
	time_formats = ["12 hour", "24 hour"]
	css_of_string = "tbody tr:first-child td:nth-child(7) .nssg-td-text"
	date_formats.each do |date_format|
		include_examples "verify date time format", "MSP - Access Points", ["go to commandcenter", "go to specific tab", "Access Points"] , css_of_string, date_format, time_formats.sample
	end
end