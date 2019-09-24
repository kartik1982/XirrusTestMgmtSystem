require_relative "../TS_Portals/local_lib/portals_lib.rb"

################################################################################################################
############# TEST CASE: Test the PORTALS area - Create, default, duplicate and delete - XMS USER ##############
################################################################################################################

describe "********** TEST CASE: Test the PORTALS area - Create, default, duplicate and delete - XMS USER **********" do

  include_examples "verify portal list view tile view toggle"

  portal_types = ["ambassador","self_reg"]

  portal_types.each { |portal_type|
    portal_name = "ACCESS SERVICE for testing XMS GUEST account - " + portal_type.downcase

    include_examples "create portal from header menu", portal_name, "DESCRIPTION " + portal_name, portal_type
  }

end