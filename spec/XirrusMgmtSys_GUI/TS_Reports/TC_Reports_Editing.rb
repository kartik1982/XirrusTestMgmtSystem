require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "./local_lib/reports_lib.rb"
#############################################################################################################
##############TEST CASE: Add, Duplicate, Favourite and Delete Reports in UI################################
#############################################################################################################
describe "TEST CASE: Add, Duplicate, Favourite and Delete Reports in UI" do

	report_from_btn_name = UTIL.random_title.downcase + " - button"
	report_from_header_name = UTIL.random_title.downcase + " - header menu"
	decription_prefix = "report description for "
	profile_name = UTIL.random_title.downcase + " - tile"
	decription_profile = "profile description for "
	date_now = Time.new.strftime('%-m/%-d/%Y')
	date_yesterday = Time.now - 86400
	date_now_verify = Time.new.strftime('%-m/%-d/%Y')

	include_examples "set timezone area to local"
	include_examples "set date time format to specific", "MM/DD/YYYY", "12 hour"

	include_examples "verify pre-canned reports"
	include_examples "create profile from header menu", profile_name, decription_profile + profile_name, false
	include_examples "create report from header menu", "8.15 changes " + report_from_header_name, "8.15 changes " + decription_prefix + report_from_header_name
	include_examples "edit report from report menu", "8.15 changes " + report_from_header_name, "8.15 changes " + decription_prefix + report_from_header_name, "Top Manufacturers by usage", "Last Day"
	include_examples "edit report from report menu", "8.15 changes " + report_from_header_name, "8.15 changes " + decription_prefix + report_from_header_name, "Top Clients by usage", "Last Hour"
	include_examples "report custom view", "8.15 changes " + report_from_header_name, "Top Clients by usage", profile_name, "1/31/2015", "10:00 am", "1/1/2015", "10:00 am", "1/1/2015 10:00 am - 1/31/2015 10:00 am"
	include_examples "report custom view one hour one minute increments" , "8.15 changes " + report_from_header_name, "Top Clients by usage", profile_name, "1/31/2015", "10:00 am", "1/1/2015", "10:00 am", "1/1/2015 10:00 am - 1/31/2015 10:00 am", 100
	include_examples "report custom view one hour one minute increments" , "8.15 changes " + report_from_header_name, "Top Clients by usage", profile_name, date_now, "10:00 am", date_yesterday.strftime('%-m/%-d/%Y'), "10:00 am", "#{date_yesterday.strftime('%-m/%-d/%Y')} 10:00 am - #{date_now_verify} 10:00 am", 1
	include_examples "negative testing on report custom view", "8.15 changes " + report_from_header_name
	include_examples "delete report from tile", "8.15 changes " + report_from_header_name
	include_examples "verify pre-canned reports"

	include_examples "set date time format to specific", "MM/DD/YYYY", "24 hour"

end