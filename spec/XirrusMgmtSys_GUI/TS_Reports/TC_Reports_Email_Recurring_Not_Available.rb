require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "./local_lib/reports_lib.rb"
################################################################################################################
##############TEST CASE: REPORTS - EMAIL REPORTS - RECURRING NOT AVAILABLE######################################
################################################################################################################
describe "********** TEST CASE: REPORTS - EMAIL REPORTS - RECURRING NOT AVAILABLE **********" do

  include_examples "set timezone area to specific one", "(GMT-11:00) Midway Island, Samoa"

  report_name = "Report - Email - " + UTIL.ickey_shuffle(7)
  description = "Report description for " + report_name

  include_examples "create report from header menu", report_name, description
  include_examples "verify the email report modal", true, true

  include_examples "edit report from tile", report_name, "Client Throughput", "Last Day"
  include_examples "verify the email report modal", true, true

  include_examples "set end override to specific date and time", "10:00 am", "2/12/2017"
  include_examples "set start override to specific date and time", "10:00 am", "1/1/2017"

  include_examples "verify the email report modal", false, true

  objects_hash = Hash["email_address" => "test@email.com", "see_recurring" => false,  "make_recurring" => false, "time_span" => "", "time_span_day" => "", "time_span_which_day" => "", "hour" => "", "offset" => ""] #
  include_examples "set email report", objects_hash["email_address"], objects_hash["see_recurring"], objects_hash["make_recurring"], objects_hash["time_span"], objects_hash["time_span_day"], objects_hash["time_span_which_day"], objects_hash["hour"], objects_hash["offset"], false #objects_hash["subject"]

end

