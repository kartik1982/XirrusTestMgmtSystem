require_relative "./local_lib/search_box_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
#########################################################################################################
##############TEST CASE: Test the SEARCH BOX - All tabs that it appears on##############################
#########################################################################################################
describe "********** TEST CASE: Test the SEARCH BOX - All tabs that it appears on **********" do
	context "********** VERIFY MY NETWORK - ACCESS POINTS TAB **********" do
	  include_examples "scope to tenant", "1-Macadamian Child XR-620-Auto"
		include_examples "go to my network access points tab"
		include_examples "verify search", "Romania", "RRRRRROOOOOOMMMMMAAAAAnnniiaaa", false, false
	end
end