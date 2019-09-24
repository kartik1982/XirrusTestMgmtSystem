require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "./local_lib/reports_lib.rb"
################################################################################################################
##############TEST CASE: REPORTS - EMAIL REPORTS###############################################################
################################################################################################################
describe "********** TEST CASE: REPORTS - EMAIL REPORTS **********" do

	include_examples "set timezone area to specific one", "(GMT-11:00) Midway Island, Samoa"

  report_name = "Report - Email - Non-Recurring - Email Verification"
  description = "Report description for " + report_name
  user_email = "report_non_recurring@testqa.com"

  include_examples "delete all reports except for pre-canned"
  include_examples "create report from header menu", report_name, description
  include_examples "edit report from tile", report_name, "Top Access Points by usage", "Last Hour"

  objects_hash = Hash["email_address" => user_email, "see_recurring" => true,  "make_recurring" => false, "time_span" => "", "time_span_day" => "", "time_span_which_day" => "", "hour" => "", "offset" => ""] #
  include_examples "set email report", objects_hash["email_address"], objects_hash["see_recurring"], objects_hash["make_recurring"], objects_hash["time_span"], objects_hash["time_span_day"], objects_hash["time_span_which_day"], objects_hash["hour"], objects_hash["offset"], false #objects_hash["subject"]

  # include_examples "delete report from report menu", report_name

end
