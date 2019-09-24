require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
#######################################################################################
#################TEST CASE: PORTAL - COMPOSITE - GENERAL TAB FEATURES##################
#######################################################################################
describe "********** TEST CASE: PORTAL - COMPOSITE - GENERAL TAB FEATURES **********" do # Creted on 15.05.2017

  portal_types = ["self_reg","ambassador","onetouch","voucher","google","azure"] #, "onboarding","personal"] #,"facebook"] #,"mega"]

  portal_name = "COMPOSITE - General - " + UTIL.ickey_shuffle(5)
  description = "Portal description for: "
  portal_type = "mega"

  include_examples "verify portal list view tile view toggle"

  portal_names_array = Array[]
  2.times do |i|
    portal_type_sample = portal_types.sample
    portal_names_array.push("#{portal_type_sample.upcase} portal #{i}")
    include_examples "create portal from header menu", "#{portal_type_sample.upcase} portal #{i}", "DESCRIPTION TEXT", portal_type_sample
  end

  include_examples "create portal from header menu", portal_name, description + portal_name, portal_type
  include_examples "portal general configurations", portal_name, description, portal_type, portal_names_array[1], portal_names_array[0], "", "", ""

end