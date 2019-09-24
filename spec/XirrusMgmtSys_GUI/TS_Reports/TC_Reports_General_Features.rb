require_relative "./local_lib/reports_lib.rb"
################################################################################################################
##############TEST CASE: Add, Duplicate, Favourite and Delete Reports in UI####################################
################################################################################################################
describe "TEST CASE: Add, Duplicate, Favourite and Delete Reports in UI" do
  page_types = ["Client Throughput","Top Clients by usage","Clients Over Time","Top Access Points by usage","Access Point Throughput","Top Devices by usage","Top Manufacturers by usage","Top Applications by usage","Top Application Categories by usage"]
  page_times = ["Last Hour","Last Day","Last 7 Days","Last 30 Days"]
  report_from_btn_name = UTIL.random_title.downcase + " - button"
  report_from_header_name = UTIL.random_title.downcase + " - header menu"
  decription_prefix = "report description for "

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
  
end