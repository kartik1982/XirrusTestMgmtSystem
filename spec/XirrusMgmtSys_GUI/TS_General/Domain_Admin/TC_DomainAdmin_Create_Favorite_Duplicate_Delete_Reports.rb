require_relative "../../TS_Reports/local_lib/reports_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../local_lib/domain_admin_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_XMSE/local_lib/xmse_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
##############################################################################################################################
##############TEST CASE: Test the PORTALS area - Create, default, duplicate and delete - DOMAINS ADMIN#######################
##############################################################################################################################
describe "********** TEST CASE: Test the PORTALS area - Create, default, duplicate and delete - DOMAINS ADMIN **********" do

  tenant_name = "Domain Admin Tenant To be deleted child"
  include_examples "scope to tenant", tenant_name
  
  report_from_btn_name = "REPORT - " + UTIL.ickey_shuffle(4) + " - button"
  report_from_header_name = "REPORT - " + UTIL.ickey_shuffle(4) +" - header menu"
  decription_prefix = "Report description for TESTING XMS USER FEATURES"

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