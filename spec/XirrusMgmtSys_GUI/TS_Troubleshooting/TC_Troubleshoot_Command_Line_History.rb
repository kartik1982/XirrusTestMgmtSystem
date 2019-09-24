require_relative "./local_lib/troubleshooting_lib.rb"
require_relative "../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "../environment_variables_library.rb"
###########################################################################################################
#############TEST CASE: TROUBLESHOOTING AREA - COMMAND LINE HISTORY TAB####################################
###########################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - COMMAND LINE HISTORY TAB  **********" do

	customer_name = return_proper_value_based_on_the_used_environment($the_environment_used, "troubleshooting/command_line_history", "Customer Name")
	customer_count = return_proper_value_based_on_the_used_environment($the_environment_used, "troubleshooting/command_line_history", "Customer Count")
	ap_parameters = return_proper_value_based_on_the_used_environment($the_environment_used, "troubleshooting/command_line_history", "AP Parameters")

	#include_examples "change to tenant", customer_name, customer_count

	include_examples "set timezone area to local"
	include_examples "set date time format to specific", "MM/DD/YYYY", "12 hour"

	include_examples "run cli command on certain ap", ap_parameters["Serial Number"], ap_parameters["Name"], "show running-config", "hostname Romania-X620"
	include_examples "go to the troubleshooting area"
	include_examples "go to tab command line history"
	include_examples "perform action verify command line history", ap_parameters["Serial Number"], Array["show running-config"], 1

	include_examples "run cli command on certain ap", ap_parameters["Serial Number"], ap_parameters["Name"], "management \n show", "Management"
	include_examples "go to the troubleshooting area"
	include_examples "go to tab command line history"
	include_examples "perform action verify command line history", ap_parameters["Serial Number"], Array["management show"], 1

end