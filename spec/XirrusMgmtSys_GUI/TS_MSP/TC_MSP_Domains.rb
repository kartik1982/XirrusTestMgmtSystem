require_relative "./local_lib/msp_lib.rb"
#################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - DOMAINS TAB###############################
#################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - DOMAINS TAB **********"  do

	include_examples "go to commandcenter"
	include_examples "create Domain", "Automation Domains Tab 1"
	include_examples "edit a specific domain in the grid", "Automation Domains Tab 1", "Automation Domains Tab 1 (edited)" , nil
	include_examples "delete Domain", "Automation Domains Tab 1 (edited)"
	include_examples "create Domain", "Automation Domains Tab 2"
	include_examples "delete Domain", "Automation Domains Tab 2"

end


