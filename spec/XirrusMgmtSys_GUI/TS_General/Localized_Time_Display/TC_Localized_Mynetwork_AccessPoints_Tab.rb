require_relative "../local_lib/localized_time_display_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
########################################################################################################################
##############TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area MY NETWORK - ACCESS POINTS tab#############
########################################################################################################################
describe "********** TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area MY NETWORK - ACCESS POINTS tab **********" do

	verify_timezones = false
	timezones = ["(GMT-11:00) Midway Island, Samoa", "(GMT-09:00) Gambier Islands", "(GMT-08:00) Pitcairn Islands", "(GMT-07:00) Arizona", "(GMT-05:00) Bogota, Lima, Quito, Rio Branco", "(GMT+06:30) Yangon (Rangoon)"]
	timezones.each do |timezone|
		css_of_string = ".nssg-tbody tr:nth-child(1) .recentActivation .nssg-td-text"
		include_examples "settings my account set timezone", verify_timezones, timezone, "My Network - Access Points tab",  "go to mynetwork access points tab", css_of_string, "MM/DD/YYYY", "12 hour"
	end
end