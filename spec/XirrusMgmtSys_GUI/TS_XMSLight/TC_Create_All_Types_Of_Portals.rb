require_relative "../TS_Portals/local_lib/portals_lib.rb"

######################################################################################################################
################TEST CASE: XMS-LIGHT TENANT - Create all types of PORTALS#############################################
######################################################################################################################

describe "********** TEST CASE: XMS-LIGHT TENANT - Create all types of PORTALS  **********" do

  portal_types = ["azure","google","ambassador","onboarding","personal","onetouch","self_reg","voucher"]

  include_examples "verify portal list view tile view toggle"
  portal_types.each { |portal_type|
    portal_name = "#{portal_type.upcase} - XMS Light Tenant"
    include_examples "create portal from header menu", portal_name, "Description", portal_type
  }

end