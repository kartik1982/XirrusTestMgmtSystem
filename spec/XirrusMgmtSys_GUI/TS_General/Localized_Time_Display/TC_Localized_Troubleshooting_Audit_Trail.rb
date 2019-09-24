require_relative "../local_lib/localized_time_display_lib.rb"
require_relative "../../TS_Troubleshooting/local_lib/troubleshooting_lib.rb"
##############################################################################################################################
##############TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab#########
##############################################################################################################################
describe "********** TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab **********" do
	verify_timezones = false

	timezones = ["(GMT-04:00) Faukland Islands", "(GMT-06:00) Saskatchewan, Central America", "(GMT+03:00) Minsk", "(GMT-09:00) Gambier Islands", "(GMT+11:00) Magadan", "(GMT-06:00) Guadalajara, Mexico City, Monterrey"]
	
	timezones.each do |timezone|

		css_of_string = ".nssg-tbody tr:first-child td:nth-child(2) .nssg-td-text"

		include_examples "settings my account set timezone", verify_timezones, timezone , "Troubleshooting - Audit Trail",  "go to the troubleshooting area", css_of_string, "MM/DD/YYYY", "12 hour"

	end
end