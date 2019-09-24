require_relative "./local_lib/rogues_lib.rb"
require_relative "./local_lib/clients_lib.rb"
###############################################################################################################
################TEST CASE: Test the MY NETWORK area - ROGUES TAB - GENERAL FEATURS############################
###############################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - ROGUES TAB - GENERAL FEATURS **********" do

  	include_examples "go to the rogues tab"

  	include_examples "general features"
  
  	include_examples "on rogues tab change the filter options", "All", "All time"

  	searched_string = [["abc", false], ["pctest", true], ["DDDDDDDDDDDD", false], ["Dirks-4836", true]]
  	searched_string.each do |element|
  		include_examples "search for a certain rogue element", element[0], element[1]
  	end	

end
