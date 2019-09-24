require_relative "../../TS_Reports/local_lib/reports_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
####################################################################################################################################
##############TEST CASE: TROUBLESHOOTING AREA - REPORTS - ADD, EDIT AND DELETE REPORT IN UI - VERIFY AUDIT TRAIL LOG################
####################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - REPORTS - ADD, EDIT AND DELETE REPORT IN UI - VERIFY AUDIT TRAIL LOG **********" do

  report_name = "Report - " + UTIL.ickey_shuffle(5) + " - button"
  decription_prefix = "Report description for: "

  include_examples "set timezone area to local"

  include_examples "verify pre-canned reports"
  include_examples "create report from header menu", report_name, decription_prefix + report_name
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "CREATE", Array["Report: "+report_name], 1

  include_examples "delete report from report menu", report_name
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "DELETE", Array["Report: "+report_name], 1
end