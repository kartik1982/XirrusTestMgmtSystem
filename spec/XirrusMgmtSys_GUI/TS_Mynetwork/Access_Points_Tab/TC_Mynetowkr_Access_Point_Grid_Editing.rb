require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
############################################################################################################
#################TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - GRID EDITING####################
############################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - GRID EDITING **********" do

	include_examples "go to mynetwork access points tab"
	include_examples "test my network access point list", "Auto", "Model"

end