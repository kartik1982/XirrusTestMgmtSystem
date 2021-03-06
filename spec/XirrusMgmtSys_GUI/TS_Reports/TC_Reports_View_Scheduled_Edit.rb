require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "./local_lib/reports_lib.rb"
#############################################################################################################
##############TEST CASE: REPORTS - EMAIL REPORTS - VERIFY SCHEDULED TAB######################################
#############################################################################################################
describe "********** TEST CASE: REPORTS - EMAIL REPORTS - VERIFY SCHEDULED TAB **********" do

  report_name = "Report - Email - " + UTIL.ickey_shuffle(7)
  description = "Report description for " + report_name

  include_examples "set timezone area to specific one", "(GMT-11:00) Midway Island, Samoa"
  include_examples "set date time format to specific", nil, "24 hour"

  include_examples "create report from header menu", report_name, description
  #include_examples "verify the email report modal", true, true

  objects_hash = Hash["email_address" => "test_001@email.com", "see_recurring" => true, "make_recurring" => true, "time_span" => "Weekly", "time_span_day" => "Tuesday", "time_span_which_day" => "", "hour" => "8:48 pm", "offset" => "(GMT+09:30) Adelaide"]
  include_examples "set email report", objects_hash["email_address"], objects_hash["see_recurring"], objects_hash["make_recurring"], objects_hash["time_span"], objects_hash["time_span_day"], objects_hash["time_span_which_day"], objects_hash["hour"], objects_hash["offset"], false

  email_address = "test_001@email.com"
  conditions = "All Access Points"
  action = "invoke"
  email_address_new = ""
  see_recurring = true
  make_recurring = true

  recurring_on = "Weekly, Tuesday, 20:48" + " #{objects_hash["offset"]}"
  time_span = "Weekly"
  time_span_day = "Monday"
  time_span_which_day = "Second"
  hour = "11:22 pm"
  offset = "(GMT+02:00) Jerusalem"
  verify_recurring_on = "Weekly, Monday, 23:22" + " #{offset}"

  include_examples "verify reports scheduled tab"
  include_examples "certain action on scheduled report line", email_address, report_name, recurring_on, conditions, action, email_address_new, see_recurring, make_recurring, time_span, time_span_day, time_span_which_day, hour, offset, verify_recurring_on

  recurring_on = "Weekly, Monday, 23:22" + " #{offset}"
  time_span = "Weekly"
  time_span_day = "Friday"
  time_span_which_day = "Second"
  hour = "10:15 am"
  offset = "(GMT+09:30) Adelaide"
  verify_recurring_on = "Weekly, Friday, 10:15" + " #{offset}"

  include_examples "verify reports scheduled tab"
  include_examples "certain action on scheduled report line", email_address, report_name, recurring_on, conditions, action, email_address_new, see_recurring, make_recurring, time_span, time_span_day, time_span_which_day, hour, offset, verify_recurring_on

  recurring_on = "Weekly, Friday, 10:15" + " #{objects_hash["offset"]}"
  action = "delete"
  email_address_new, see_recurring, make_recurring, time_span, time_span_day, time_span_which_day, hour, offset, verify_recurring_on = nil

  include_examples "verify reports scheduled tab"
  include_examples "certain action on scheduled report line", email_address, report_name, recurring_on, conditions, action, email_address_new, see_recurring, make_recurring, time_span, time_span_day, time_span_which_day, hour, offset, verify_recurring_on


end

