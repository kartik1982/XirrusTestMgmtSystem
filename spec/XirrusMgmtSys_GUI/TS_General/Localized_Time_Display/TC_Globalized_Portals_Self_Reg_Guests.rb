require_relative "../local_lib/localized_time_display_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Portal/local_lib/general_lib.rb"
require_relative "../../TS_Portal/local_lib/guests_lib.rb"
require_relative "../../TS_Search_Box/local_lib/search_box_lib.rb"
require_relative "../../TS_Troubleshooting/local_lib/troubleshooting_lib.rb"
###################################################################################################################################
##############TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab##############
###################################################################################################################################
describe "********** TEST CASE: Test the LOCALIZED TIME DISPLAY feature on the area ACCESS SERVICES - ONE-CLICK - GUESTS tab **********" do
	portal_type = "self_reg"
	portal_name = "Portal for testing timezones - #{UTIL.ickey_shuffle(9)} - #{portal_type.upcase}"
	portal_description = "Random description text: " + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9)
	timeframe = "15 minutes"

	include_examples "create portal from header menu", portal_name, portal_description, portal_type
	include_examples "update portal session expiration to custom", portal_name, portal_type, timeframe
	include_examples "verify guests grid", portal_name
	include_examples "add several guests", 1, portal_name, false

	verify_timezones = false
	date_formats = ["MM/DD/YYYY", "DD/MM/YYYY", "YYYY/MM/DD", "MM-DD-YYYY", "DD-MM-YYYY", "YYYY-MM-DD", "MM.DD.YYYY", "DD.MM.YYYY", "YYYY.MM.DD"]
	time_formats = ["12 hour", "24 hour"]
	css_of_string = ".nssg-tbody tr:nth-child(1) .accessTerminationDate .nssg-td-text"
	date_formats.each do |date_format|
		include_examples "verify date time format", "Portal - Guests tab", ["go to portal guests tab", portal_name], css_of_string, date_format, time_formats.sample
	end
end