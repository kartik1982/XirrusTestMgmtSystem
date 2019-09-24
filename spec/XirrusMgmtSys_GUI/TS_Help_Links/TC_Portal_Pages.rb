require_relative "local_lib/helplinks_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
######################################################################################
##############TEST CASE: Test the HELP LINKS - PORTAL CONFIGURATION - PAGES###########
######################################################################################
describe "********** TEST CASE: Test the HELP LINKS - PORTAL CONFIGURATION - PAGES **********" do
  portal_types = ["onetouch","personal","self_reg","ambassador","voucher","onboarding","google"]
  portal_types.each { |portal_type|
  	 portal_name = UTIL.random_title.downcase + " - " + portal_type
  	 decription = "Test portal - description text - " + portal_type
	 include_examples "create portal from header menu", portal_name, decription, portal_type
	 include_examples "test portal pages links", portal_name, portal_type
	 include_examples "delete portal from tile", portal_name
  }
end