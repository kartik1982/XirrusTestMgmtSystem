require_relative "./local_lib/search_box_lib.rb"
#########################################################################################################
##############TEST CASE: Test the SEARCH BOX - All tabs that it appears on##############################
#########################################################################################################
describe "********** TEST CASE: Test the SEARCH BOX - All tabs that it appears on **********" do
	context "********** VERIFY MY NETWORK - CLIENTS TAB **********" do
		include_examples "go to my network clients tab"
		include_examples "verify search", "aur", "haur", false, false
	end
end