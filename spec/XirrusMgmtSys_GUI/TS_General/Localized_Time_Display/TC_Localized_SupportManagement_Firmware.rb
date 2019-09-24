require_relative "../local_lib/localized_time_display_lib.rb"
##############################################################################################################################
##############TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab#########
##############################################################################################################################
describe "********** TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab **********" do
	verify_timezones = false
	timezones = ["(GMT-10:00) Hawaii-Aleutian", "(GMT) Greenwich Mean Time : Belfast","(GMT) Greenwich Mean Time : Dublin", "(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi"]
	
	timezones.each do |timezone|

		include_examples "set timezone area to local"

		css_of_string = ".nssg-tobdy tr:first-child td:nth-child(4) .nssg-td-text"

		if timezone == timezones.first
			include_examples "settings my account set timezone", verify_timezones, timezone, "Support Management - Firmware - Add", "go to support management", css_of_string, "MM/DD/YYYY", "12 hour"
		elsif timezone == timezones.last
			include_examples "settings my account set timezone", verify_timezones, timezone, "Support Management - Firmware - Delete", "go to support management", css_of_string, "MM/DD/YYYY", "12 hour"
		else
			include_examples "settings my account set timezone", verify_timezones, timezone, "Support Management - Firmware", "go to support management", css_of_string, "MM/DD/YYYY", "12 hour"
		end

	end
end