require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_XMSE/local_lib/xmse_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
##############################################################################################################################
##############TEST CASE: Test the PORTALS area - Create, default, duplicate and delete - DOMAIN ADMIN########################
##############################################################################################################################
describe "********** TEST CASE: Test the PORTALS area - Create, default, duplicate and delete - DOMAIN ADMIN **********" do

  tenant_name = "Domain Admin Tenant To be deleted child"
  include_examples "scope to tenant", tenant_name
  
  include_examples "verify portal list view tile view toggle"

  portal_types = ["onboarding","self_reg","google","ambassador","onetouch","personal","voucher"]

  if $the_environment_used == "test03"
      #portal_types.push("facebook")

      include_examples "go to settings then to tab", "Firmware Upgrades"
      include_examples "change default firmware for new domains", "Technology"
  end

  portal_types.each { |portal_type|
    portal_name = "ACCESS SERVICE for testing Domain Administrator - " + portal_type.downcase

    include_examples "create portal from header menu", portal_name, "DESCRIPTION " + portal_name, portal_type
	}

  portal_name = "ACCESS SERVICE - Domain Admin - OTHER TESTS " + UTIL.ickey_shuffle(6)

  include_examples "create portal from header menu", portal_name, "DESCRIPTION " + portal_name, "self_reg"
  include_examples "duplicate portal from tile", portal_name, "DESCRIPTION " + portal_name, "self_reg"
  include_examples "search for portal", portal_name
  include_examples "delete portal from portal menu", "Copy of " + portal_name
  include_examples "duplicate portal from portal menu", portal_name, "DESCRIPTION " + portal_name, "self_reg"
  include_examples "delete portal from tile", "Copy of " + portal_name
  include_examples "delete portal from portal menu", portal_name

end