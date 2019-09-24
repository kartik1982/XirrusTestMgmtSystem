require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
###############################################################################################################################
#################TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - GENERAL FEATURES####################################
###############################################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - GENERAL FEATURES **********" do
	include_examples "verify my network all access points tab general features"
end