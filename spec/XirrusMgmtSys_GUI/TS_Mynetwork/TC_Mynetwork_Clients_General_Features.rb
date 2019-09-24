require_relative "./local_lib/clients_lib.rb"
############################################################################################################
##################TEST CASE: Test the MY NETWORK area - CLIENTS TAB - GENERAL FEATURS######################
############################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - CLIENTS TAB - GENERAL FEATURS **********" do
	include_examples "test general features are present"
	include_examples "test PR 26750 - remove non valid search input using backspace"
end
