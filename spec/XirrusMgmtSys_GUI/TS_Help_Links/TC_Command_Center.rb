require_relative "local_lib/helplinks_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
######################################################################################
##############TEST CASE: Test the HELP LINKS - COMMAND CENTER#########################
######################################################################################
describe "********** TEST CASE: Test the HELP LINKS - COMMAND CENTER **********" do
	include_examples "test CommandCenter top link"
	include_examples "test CommandCenter tab links"
end