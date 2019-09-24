require_relative "./local_lib/rogues_lib.rb"
require_relative "./local_lib/alerts_lib.rb"
require_relative "./local_lib/clients_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
#######################################################################################################
############TEST CASE: Test the MY NETWORK area - ROGUES TAB - List rogues max 90 days#################
#######################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - ROGUES TAB - List rogues max 90 days **********" do
 	include_examples "set date time format to specific", "DD/MM/YYYY", "12 hour"
 	include_examples "go to the rogues tab"
	include_examples "on rogues tab change the filter options", "All", "All time"
  include_examples "verify the rogues grid display only last 90 days rogues"
  include_examples "verify the Alert grid display after clean-up data", "High"
  include_examples "verify the Alert grid display after clean-up data", "Low"
  include_examples "verify the Alert grid display after clean-up data", "Medium"
  include_examples "set date time format to specific", "MM/DD/YYYY", "12 hour"
  
end
