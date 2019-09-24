require_relative "./local_lib/reports_lib.rb"
################################################################################################################
##############TEST CASE: Test the REPORTS AREA - DRILL DOWN FEATURE - WHEN NOT HAVING ANY RESULTS###############
################################################################################################################
describe "********** TEST CASE: Test the REPORTS AREA - DRILL DOWN FEATURE - WHEN NOT HAVING ANY RESULTS **********" do

  report_name = "Report - " + UTIL.ickey_shuffle(5)
  decription_prefix = "Report description for "

  include_examples "create report from header menu", report_name, decription_prefix + report_name
  include_examples "go to reports landing page"
  include_examples "edit report from tile", report_name, "Top Applications by usage", "Last 30 Days"
  include_examples "verify reports drilldown"
  include_examples "add drilldown application pages verify pages", 2, "Top Clients (by Usage)", false, nil, nil, nil, nil
  include_examples "add drilldown application pages verify values", 2, "Access Points (by Usage)", false, nil, nil, nil, nil
  include_examples "delete report from report menu", report_name

end