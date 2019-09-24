require_relative "./local_lib/search_box_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/users_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "../TS_Portal/local_lib/vouchers_lib.rb"
#########################################################################################################
##############TEST CASE: Test the SEARCH BOX - All tabs that it appears on###############################
#########################################################################################################
describe "********** TEST CASE: Test the SEARCH BOX - All tabs that it appears on **********" do
  context "********** VERIFY PORTALS - ONBOARDING - USERS TAB **********" do

    include_examples "scope to tenant", "Child Domain for Portal Second tab"

    portal_name = "VOUCHER_PORTAL-" + UTIL.ickey_shuffle(5)
    portal_description = "Description text for the portal named " + portal_name
    portal_type = "voucher"

    include_examples "verify portal list view tile view toggle"
    include_examples "create portal from header menu", portal_name, portal_description, portal_type
    include_examples "navigate to the portal second page", portal_name, true
    include_examples "add voucher", portal_name
    include_examples "import voucher", portal_name
    5.times do
        include_examples "add voucher", portal_name
    end
    include_examples "verify search", "athletics", "Jkkdsaonre231", false, false
    include_examples "verify search box tooltip", "Enter at least 3 characters. Search for Access Code, Note or Group."
    include_examples "verify search", "import", "IMPORT", true, true

  end
end