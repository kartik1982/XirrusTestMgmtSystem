require_relative "./local_lib/rogues_lib.rb"
require_relative "./local_lib/clients_lib.rb"
###################################################################################################
#############TEST CASE: Test the MY NETWORK area - ROGUES TAB - FILTER & EXPORTS#################
###################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - ROGUES TAB - FILTER & EXPORTS **********" do

 	include_examples "go to the rogues tab"

	include_examples "verify rogues exports", "Active", nil
  	what_status_options = ["Inactive", "All"]
  	what_time_period_options = ["Seen in the last day", "Seen in the last week", "Seen in the last month", "All time"]

  	what_status_options.each do |what_status|
  		what_time_period_options.each do |what_time_period|
  			include_examples "on rogues tab change the filter options", what_status, what_time_period
  			include_examples "verify the rogues grid is properly displayed"
  			include_examples "verify rogues exports", what_status, what_time_period
  		end
  	end

end
