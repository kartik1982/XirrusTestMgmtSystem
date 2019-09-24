require_relative "./local_lib/search_box_lib.rb"
#########################################################################################################
##############TEST CASE: Test the SEARCH BOX - All tabs that it appears on###############################
#########################################################################################################
describe "********** TEST CASE: Test the SEARCH BOX - All tabs that it appears on **********" do
	context "********** VERIFY SUPPORT MANAGEMENT - CUSTOMERS TAB **********" do
		include_examples "go to support management customers tab"
		include_examples "verify search", "xMacadamianx", "Maca2312`ra;_+sad1", false, false
    include_examples "verify search", "Macada", "MACADAMIAN", true, true
	end
end