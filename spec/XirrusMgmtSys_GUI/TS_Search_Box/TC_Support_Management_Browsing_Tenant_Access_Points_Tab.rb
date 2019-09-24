require_relative "./local_lib/search_box_lib.rb"
#########################################################################################################
##############TEST CASE: Test the SEARCH BOX - All tabs that it appears on##############################
#########################################################################################################
describe "********** TEST CASE: Test the SEARCH BOX - All tabs that it appears on **********" do
	context "********** VERIFY SUPPORT MANAGEMENT - BROWSING TENANT - ACCESS POINTS TAB **********" do
		include_examples "go to support management customers tab"
		include_examples "open a certain customer", "1-Macadamian Child XR-620-Auto"
		include_examples "verify search", "X20641902ADDC", "X20641902ADDC", true, true
    include_examples "verify search", "*321dsa1`+++dsa3", "*321dsa1`+++dsa3", false, true
	end
end
