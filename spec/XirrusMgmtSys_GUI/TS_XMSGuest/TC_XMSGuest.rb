require_relative "local_lib/xmsguest_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
#############################################################################################
############# TEST CASE: TEST THE APPLICATION USING A GUEST AMBASSADOR ACCOUNT ##############
#############################################################################################
describe "TEST THE APPLICATION USING A GUEST AMBASSADOR ACCOUNT" do
  
  include_examples "general features guest ambassador"
  portal_types = ["self_reg","ambassador"] # "onboarding","google","onetouch","personal","voucher"
  include_examples "delete all guests select all lines"
  
  portal_types.each { |portal_type|
    portal_name = "ACCESS SERVICE for testing XMS GUEST account - " + portal_type.downcase
    include_examples "add guests", "Manage Guests", 1, portal_name, true
    include_examples "add guests", "Manage Guests", 1, portal_name, false
    include_examples "add guests", "Home", 1, portal_name, false
    include_examples "add guests", "Home", 1, portal_name, true
  }
  include_examples "add specific guest", "Tester Tom", "test@test.com", true, "Germany", "0123456778890", "T-Mobile", "Test Company Inc.", "TEXT TEXT TEXT TEXT", "ACCESS SERVICE for testing XMS GUEST account - ambassador"
  #include_examples "edit guest", "Tester Tom- NEW", true
  include_examples "delete all guests line by line"
end