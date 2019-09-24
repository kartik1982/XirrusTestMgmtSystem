require_relative "./local_lib/eircom_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_XMSE/local_lib/xmse_lib.rb"
########################################################
#################TEST CASE: Test Eircom portals########
########################################################
describe "TEST CASE: Test Eircom portals" do

  portal_types = ["onboarding","self_reg","google","ambassador","onetouch","personal","voucher"]
  decription_prefix = "portal description for "

  include_examples "verify portal list view tile view toggle"
  portal_types.each { |portal_type|
    portal_name = UTIL.random_title.downcase + " " + portal_type.downcase
    include_examples "create portal from header menu", portal_name, decription_prefix + portal_name, portal_type
  }
  include_examples "verify portal list view tile view toggle"

end