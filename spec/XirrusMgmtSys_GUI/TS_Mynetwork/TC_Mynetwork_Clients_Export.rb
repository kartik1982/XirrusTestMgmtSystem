require_relative "./local_lib/clients_lib.rb"
######################################################################################################################
#################TEST CASE: Test the MY NETWORK area - CLIENTS TAB - EXPORT ENTRIES##################################
######################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - CLIENTS TAB - EXPORT ENTRIES **********" do

	include_examples "export all clients and verify the results contain a certain client", 'android-e66c7c6d90d4e140'

end