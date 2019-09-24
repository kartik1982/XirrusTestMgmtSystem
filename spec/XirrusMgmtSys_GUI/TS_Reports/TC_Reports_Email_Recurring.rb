require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "./local_lib/reports_lib.rb"
#############################################################################################################
##############TEST CASE: REPORTS - EMAIL REPORTS - RECURRING################################################
#############################################################################################################
describe "********** TEST CASE: REPORTS - EMAIL REPORTS - RECURRING **********" do

  include_examples "set timezone area to specific one", "(GMT-11:00) Midway Island, Samoa"

  report_name = "Report - Email - " + UTIL.ickey_shuffle(7)
  description = "Report description for " + report_name

  include_examples "create report from header menu", report_name, description
  include_examples "verify the email report modal", true, true

  objects_hash = Hash["email_address" => "test4@email.com", "see_recurring" => true, "make_recurring" => true, "time_span" => "Weekly", "time_span_day" => "Tuesday", "time_span_which_day" => "", "hour" => "8:48 pm", "offset" => "(GMT+02:00) Jerusalem"] # "subject" => "",
  include_examples "set email report", objects_hash["email_address"], objects_hash["see_recurring"], objects_hash["make_recurring"], objects_hash["time_span"], objects_hash["time_span_day"], objects_hash["time_span_which_day"], objects_hash["hour"], objects_hash["offset"], false #objects_hash["subject"]

  objects_hash = Hash["email_address" => "test2223@email.com", "see_recurring" => true, "make_recurring" => true, "time_span" => "Weekly", "time_span_day" => "Friday", "time_span_which_day" => "", "hour" => "10:22 am", "offset" => "(GMT+09:30) Adelaide"] #"subject" => "The main Subject",
  include_examples "set email report", objects_hash["email_address"], objects_hash["see_recurring"], objects_hash["make_recurring"], objects_hash["time_span"], objects_hash["time_span_day"], objects_hash["time_span_which_day"], objects_hash["hour"], objects_hash["offset"], false #objects_hash["subject"]


end

