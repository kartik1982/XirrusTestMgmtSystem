require_relative "../TS_Reports/local_lib/reports_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
##############################################################################################################
############TEST CASE: Add, Duplicate, Favourite and Delete Reports in UI EIRCOM tenant######################
##############################################################################################################
describe "TEST CASE: Add, Duplicate, Favourite and Delete Reports in UI EIRCOM tenant" do
  page_types = ["Client Throughput","Top Clients by usage","Clients Over Time","Top Access Points by usage","Access Point Throughput","Top Devices by usage","Top Manufacturers by usage","Top Applications by usage","Top Application Categories by usage"]
  page_times = ["Last Hour","Last Day","Last 7 Days","Last 30 Days"]
  report_from_btn_name = UTIL.random_title.downcase + " - button (Eircom)"
  report_from_header_name = UTIL.random_title.downcase + " - header menu (Eircom)"
  decription_prefix = "report description for "
  profile_name = UTIL.random_title.downcase + " - tile (Eircom)"
  decription_profile = "profile description for "

  include_examples "set timezone area to local"

  include_examples "verify pre-canned reports"
  include_examples "create report from header menu", report_from_header_name, decription_prefix + report_from_header_name
  include_examples "create report from new report button", report_from_btn_name, decription_prefix + report_from_btn_name
  include_examples "duplicate report from tile", report_from_header_name
  include_examples "duplicate report from report menu", report_from_btn_name
  include_examples "favourite report from tile", report_from_header_name
  include_examples "favourite report from report menu", report_from_btn_name
  include_examples "delete report from report menu", report_from_btn_name

  include_examples "delete report from tile", report_from_header_name
  include_examples "verify pre-canned reports"

  include_examples "create profile from header menu", profile_name, decription_profile + profile_name, false
  include_examples "create report from header menu", "8.15 changes " + report_from_header_name, "8.15 changes " + decription_prefix + report_from_header_name
  include_examples "edit report from report menu", "8.15 changes " + report_from_header_name, "8.15 changes " + decription_prefix + report_from_header_name, "Top Manufacturers by usage", "Last Day"
  include_examples "edit report from report menu", "8.15 changes " + report_from_header_name, "8.15 changes " + decription_prefix + report_from_header_name, "Top Clients by usage", "Last Hour"
  include_examples "report custom view", "8.15 changes " + report_from_header_name, "Top Clients by usage", profile_name, "6/22/2015", "10:00 am", "5/30/2015", "10:00 am", "5/30/2015 10:00 am - 6/22/2015 10:00 am"
  include_examples "negative testing on report custom view", "8.15 changes " + report_from_header_name
  include_examples "delete report from tile", "8.15 changes " + report_from_header_name

end