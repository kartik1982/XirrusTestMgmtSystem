require_relative "./local_lib/troubleshooting_lib.rb"
##############################################################################################################################
###############TEST CASE: Test the TROUBLESHOOTING area - GRID VERIFICATIONS & PAGINATION#####################################
##############################################################################################################################
describe "********** TEST CASE: Test the TROUBLESHOOTING area - GRID VERIFICATIONS & PAGINATION **********" do
	include_examples "go to the troubleshooting area"
	search_box = true, export_btn = true, refresh_btn = true
	include_examples "verify grid pagination", search_box, export_btn, refresh_btn, "", "500"

	include_examples "go to tab command line history"
	include_examples "verify grid pagination", search_box, export_btn, refresh_btn, "", "500"

	include_examples "go to tab messages"
	search_box = false, export_btn = false, refresh_btn = false
	include_examples "verify grid pagination", search_box, export_btn, refresh_btn, ".xc-messages" ,"500"

end