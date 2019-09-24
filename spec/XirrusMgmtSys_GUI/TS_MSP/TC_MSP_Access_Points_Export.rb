require_relative "./local_lib/msp_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
#################################################################################################################
###############TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB - Export Arrays#######################
#################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB - Export Arrays **********"  do
  include_examples "set timezone area to local"
	include_examples "go to commandcenter"
	include_examples "export all access points"
end
