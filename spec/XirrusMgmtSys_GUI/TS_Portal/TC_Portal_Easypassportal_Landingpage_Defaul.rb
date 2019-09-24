require_relative "./local_lib/portal_lib.rb"
require_relative "./local_lib/general_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
################################################################################################
###################TEST CASE: PORTAL - AMBASSADOR - LANDING PAGE DEFAULT########################
################################################################################################
describe "********** TEST CASE: PORTAL - AMBASSADOR - LANDING PAGE DEFAULT **********" do

  portal_name = "AMBASSADOR - General - " + UTIL.ickey_shuffle(5)
  decription_prefix = "Portal description for: "
  portal_types = ["self_reg","ambassador","onetouch","onboarding","voucher","google","azure"]
  portal_types.each do |portal_type|
    portal_name = portal_type.upcase + UTIL.ickey_shuffle(5)
    include_examples "create portal from header menu", portal_name, decription_prefix + portal_name, portal_type
    include_examples "verify the default landingpage and delete after", portal_name
  end
end