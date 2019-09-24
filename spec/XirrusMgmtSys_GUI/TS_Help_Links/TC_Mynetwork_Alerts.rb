require_relative "local_lib/helplinks_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
#############################################################################################
##############TEST CASE: Test the HELP LINKS - MY NETWORK - ALERTS##########################
#############################################################################################
describe "********** TEST CASE: Test the HELP LINKS - MY NETWORK - ALERTS **********" do
  include_examples "test alerts link"
end