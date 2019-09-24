require_relative "./local_lib/clients_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
##############################################################################################################
##############TEST CASE: TEST CASE: Mynetwork - Clients - Delete Clients Data################################
#############################################################################################################
describe "***********TEST CASE: Mynetwork - Clients - Delete Clients Data******************" do
  #Verify offline clients only shpows delete button
  include_examples "go to mynetwork clients tab"
  include_examples "delete button available only for offline clients"
  #Verify Settings => System tab =" Data Retention"
  include_examples "go to settings then to tab", "System"
  include_examples "verify system data retention"
end
