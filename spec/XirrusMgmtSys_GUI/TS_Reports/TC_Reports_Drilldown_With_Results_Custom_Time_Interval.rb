require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "./local_lib/reports_lib.rb"
#############################################################################################################
##############TEST CASE: Test the REPORTS AREA - DRILL DOWN FEATURE WHEN HAVING RESULTS######################
#############################################################################################################
describe "********** TEST CASE: Test the REPORTS AREA - DRILL DOWN FEATURE WHEN HAVING RESULTS **********" do

  report_name = "Report - " + UTIL.ickey_shuffle(5)
  decription_prefix = "Report description for "

  include_examples "scope to tenant", "1-Macadamian Child XR-620-Auto"
  include_examples "delete all reports except for pre-canned"
  include_examples "create report from header menu", report_name, decription_prefix + report_name
  include_examples "go to reports landing page"
  include_examples "edit report from tile", report_name, "Top Applications by usage", "Last 30 Days"
  include_examples "set end override to specific date and time", "10:00 am", "7/1/2017"
  include_examples "set start override to specific date and time", "10:00 am", "6/1/2017"
  include_examples "verify reports drilldown"
  include_examples "add drilldown application pages verify pages", 9, "Top Clients (by Usage)", true, "10:00 am", "7/1/2017", "10:00 am", "6/1/2017"
  include_examples "add drilldown application pages verify values", 9, "Access Points (by Usage)", true, "10:00 am", "7/1/2017", "10:00 am", "6/1/2017"
  include_examples "delete report from report menu", report_name

end