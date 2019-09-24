require_relative "../../TS_Reports/local_lib/reports_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
####################################################################################################################################
##############TEST CASE: TROUBLESHOOTING AREA - REPORTS - SCHEDULING - VERIFY AUDIT TRAIL LOG######################################
####################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - REPORTS - SCHEDULING - VERIFY AUDIT TRAIL LOG **********" do

  include_examples "set timezone area to specific one", "(GMT-11:00) Midway Island, Samoa"
  include_examples "set date time format to specific", nil, "24 hour"

  report_name = "Report - " + UTIL.ickey_shuffle(5) + " Audit Trail Scheduling"
  decription_prefix = "Report description for: "

  include_examples "verify pre-canned reports"
  include_examples "create report from header menu", report_name, decription_prefix + report_name
  include_examples "verify the email report modal", true, true
  objects_hash = Hash["email_address" => "test4@email.com", "see_recurring" => true, "make_recurring" => true, "time_span" => "Weekly", "time_span_day" => "Tuesday", "time_span_which_day" => "", "hour" => "8:48 pm", "offset" => "(GMT+02:00) Jerusalem"] # "subject" => "",
  include_examples "set email report", objects_hash["email_address"], objects_hash["see_recurring"], objects_hash["make_recurring"], objects_hash["time_span"], objects_hash["time_span_day"], objects_hash["time_span_which_day"], objects_hash["hour"], objects_hash["offset"], false #objects_hash["subject"]

  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "CREATE", Array["Scheduled Report Event: "], 1

  user_email = "report_non_recurring@testqa.ro"
  include_examples "go to a specific report", report_name
  objects_hash = Hash["email_address" => user_email, "see_recurring" => true,  "make_recurring" => false, "time_span" => "", "time_span_day" => "", "time_span_which_day" => "", "hour" => "", "offset" => ""] #
  include_examples "set email report", objects_hash["email_address"], objects_hash["see_recurring"], objects_hash["make_recurring"], objects_hash["time_span"], objects_hash["time_span_day"], objects_hash["time_span_which_day"], objects_hash["hour"], objects_hash["offset"], false #objects_hash["subject"]

  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "CREATE", Array["Scheduled Report Event: "], 1

  include_examples "delete report from report menu", report_name
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "DELETE", Array["Report: "+report_name], 1
end