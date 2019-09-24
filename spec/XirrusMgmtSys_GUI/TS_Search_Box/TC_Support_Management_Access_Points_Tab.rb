require_relative "./local_lib/search_box_lib.rb"
#########################################################################################################
##############TEST CASE: Test the SEARCH BOX - All tabs that it appears on###############################
#########################################################################################################
describe "********** TEST CASE: Test the SEARCH BOX - All tabs that it appears on **********" do
	context "********** VERIFY SUPPORT MANAGEMENT - ACCESS POINTS TAB **********" do
		include_examples "go to support management access points tab"
		include_examples "verify search", "X3035490460606", "x035490460606", false, true
    include_examples "verify search", "X333333DSASdsa", "aaaa123dsn+312ds", false, true
	end
end