require_relative "../local_lib/localized_time_display_lib.rb"
require_relative "../../TS_SupportManagement/local_lib/support_management_lib.rb"
##############################################################################################################################
##############TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area SUPPORT MANAGEMENT - ACCESS POINTS tab###########
##############################################################################################################################
describe "********** TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area SUPPORT MANAGEMENT - ACCESS POINTS tab **********" do
	verify_timezones = false
	timezones = ["(GMT-06:00) Saskatchewan, Central America", "(GMT+03:00) Minsk", "(GMT-09:00) Gambier Islands",  "(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi"]

	include_examples "go to support management"
	include_examples "verify grid columns on access points tab"

	timezones.each do |timezone|

		css_of_string = ".nssg-tobdy tr:first-child .nssg-td-text:nth-child(15) .nssg-td-text"

			include_examples "settings my account set timezone", verify_timezones, timezone, "Support Management - Access Points tab", "go to support management", css_of_string, "MM/DD/YYYY", "12 hour"

	end
end