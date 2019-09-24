require_relative "./local_lib/search_box_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/guests_lib.rb"
require_relative "../TS_Portal/local_lib/vouchers_lib.rb"
require_relative "../TS_Portal/local_lib/users_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
#########################################################################################################
##############TEST CASE: Test the SEARCH BOX - All tabs that it appears on##############################
#########################################################################################################
describe "********** TEST CASE: Test the SEARCH BOX - All tabs that it appears on **********" do
  context "********** VERIFY PORTALS - GOOGLE LOGIN & MICROSOFT AZURE - USERS TAB **********" do
    include_examples "scope to tenant", "Child Domain for Portal Second tab"
    ['google','azure'].each do |portal_type|

      portal_name = "PORTAL - " + UTIL.ickey_shuffle(4) + " - tile"

      include_examples "verify portal list view tile view toggle"
      include_examples "create portal from tile", portal_name, portal_name + " #{portal_type}", portal_type
      include_examples "navigate to the portal second page", portal_name
      include_examples "force the search box to be displayed"
      if portal_type == "google"
        include_examples "verify search box tooltip", "Enter at least 3 characters. Search for First Name, Last Name, Full Name, Email or Group."
      else
        include_examples "verify search box tooltip", "Enter at least 3 characters. Search for Guest Name, Email or Group."
      end
      context "verify search" do
        include_examples "verify the search box with or without results to display and cancel search using x", "Robert DeNiro", false
      end
      include_examples "force the search box to be displayed"
      context "verify search" do
        include_examples "verify the search box with or without results to display and cancel search using x", "patrick_swayze@personalmail.com", false
      end
    end
  end
end