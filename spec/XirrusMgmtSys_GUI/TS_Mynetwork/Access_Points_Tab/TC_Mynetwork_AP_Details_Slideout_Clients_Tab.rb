require_relative "../local_lib/clients_lib.rb"
require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Switches/local_lib/switches_lib.rb"
######################################################################################################
############TEST CASE: Test the MY NETWORK area - CLIENTS TAB########################################
######################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - CLIENTS TAB **********" do
   if $the_environment_used == "test01"
    client_name="MYPC"
    client_mac="00:21:5c:6b:d7:41"
  elsif $the_environment_used == "test03"
    client_name="MyPC"
    client_mac="ac:81:12:05:68:6b"
  end
  include_examples "change to tenant", "1-Macadamian Child XR-620-Auto", 1
  include_examples "device filter online-offline-all", "accesspoint"
  include_examples "verify clients tab in access point details slideout panel", client_name, client_mac

end