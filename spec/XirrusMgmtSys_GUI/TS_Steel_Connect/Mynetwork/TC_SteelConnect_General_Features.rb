require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../local_lib/steel_connect_lib.rb"
#################################################################################################################################
######################TEST CASE: STEEL CONNECT - MY NETWORK area - Test the ACCESS POINTS tab - GENERAL FEATURES##############
#################################################################################################################################
describe "********** TEST CASE: STEEL CONNECT - MY NETWORK area - Test the ACCESS POINTS tab - GENERAL FEATURES **********" do

  profile_name = "STEEL CONNECT - DEFAULT EXISTING PROFILE"
  include_examples "scope to tenant", "Adrian-Automation-Chrome-SteelConnect-Child"
  include_examples "verify steelconnect info tooltip"
  include_examples "verify my network all access points tab general features on new domain"
  include_examples "verify my network all access points tab general features on new profile", profile_name, true

end