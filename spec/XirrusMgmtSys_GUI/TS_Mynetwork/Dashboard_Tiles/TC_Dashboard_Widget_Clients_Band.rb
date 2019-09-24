require_relative "../local_lib/dashboard_tiles_lib.rb"
#####################################################################################################################################################
############TEST CASE: Test the MY NETWORK area - DASHBOARD - Widget - Clients On 2.4 Ghz Band, Clients on 5 Ghz Band, Total Clients#################
#####################################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - DASHBOARD - Widget - Clients On 2.4 Ghz Band, Clients on 5 Ghz Band, Total Clients **********" do
  include_examples "verify that Clients on Band widget has hyper link"
  for band in ["2.4 GHz", "5 GHz", "2.4 GHz & 5 GHz"] do
    include_examples "verify that clicking Clients on Band widget redirect to Client panel", band
  end
end