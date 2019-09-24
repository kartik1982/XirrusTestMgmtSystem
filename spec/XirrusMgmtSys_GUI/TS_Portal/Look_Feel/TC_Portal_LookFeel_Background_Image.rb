require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/lookfeel_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
##############################################################################################################################
###################TEST CASE: Test the Portal - LOOK & FEEL TAB - Background Image###########################################
##############################################################################################################################
describe  "********** TEST CASE: Test the Portal - LOOK & FEEL TAB - Background Image **********" do

  decription_prefix = "portal description for "
  portal_types = ["self_reg"]#,"ambassador","onetouch","voucher"]

  include_examples "verify portal list view tile view toggle"

  portal_types.each { |portal_type|
      portal_name =  UTIL.random_title.downcase + " " + portal_type.downcase
      
      include_examples "create portal from header menu", portal_name, decription_prefix + portal_name, portal_type
      
      include_examples "verify background", portal_name, portal_type, "4tUTObk", "https://i.imgur.com/4tUTObk.jpg", "4tUTObk", "background"
  }


end