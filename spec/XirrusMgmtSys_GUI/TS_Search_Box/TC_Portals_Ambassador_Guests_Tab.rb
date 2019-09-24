require_relative "./local_lib/search_box_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/guests_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
#########################################################################################################
##############TEST CASE: Test the SEARCH BOX - All tabs that it appears on##############################
#########################################################################################################
describe "********** TEST CASE: Test the SEARCH BOX - All tabs that it appears on **********" do
	context "********** VERIFY PORTALS - SELF REGISTRATION & AMBASSADOR - GUESTS TAB **********" do
		decription_prefix = "portal description for "
		portal_type = "ambassador"
		portal_name = "PORTAL - " + UTIL.ickey_shuffle(4) + " - tile"

		include_examples "scope to tenant", "Child Domain for Portal Second tab"

		include_examples "verify portal list view tile view toggle"
		include_examples "create portal from tile", portal_name, decription_prefix + portal_name, portal_type
		include_examples "go to portal guests tab", portal_name
		include_examples "verify search empty"
		include_examples "add several guests", 5 , portal_name, true
		include_examples "verify search", "athletics", "Jkkdsaonre231", false, false
		include_examples "verify search box tooltip", "Enter at least 3 characters. Search for Guest Name or Email."
    include_examples "add guest", portal_name, "Bill Murray", "bill.m@personalmail.com", false, "", "", "", "The Company Ltd.", "Test account", false
    include_examples "add guest", portal_name, "Sean Connery", "sean.con@personalmail.com", false, "", "", "", "The Company Ltd.", "Test account", false
    include_examples "verify search", "bill.m@personalmail.com", "Connery", true, true
	end
end