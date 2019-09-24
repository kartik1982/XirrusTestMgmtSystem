require_relative "./local_lib/ap_lib.rb"
require_relative "./local_lib/clients_lib.rb"
require_relative "./local_lib/dashboard_lib.rb"
#####################################################################################################################################################
################TEST CASE: Test the MY NETWORK area - Access Point tab -CLIENTS TAB - DIRECT LINK USING MAC ADDRESS and TIME IN URL##################
#####################################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - Access Point tab -CLIENTS TAB - DIRECT LINK USING MAC ADDRESS and TIME IN URL **********" do
   if $the_environment_used == "test01"
    client_mac="00:21:5c:6b:d7:41"
    ap_mac="50:60:28:05:15:be"
    client_name="MYPC"
  elsif $the_environment_used == "test03"
    client_mac="ac:81:12:05:68:6b"
    ap_mac="50:60:28:02:78:b0"
    client_name="MyPC"
  end
    include_examples "change to tenant", "1-Macadamian Child XR-620-Auto", 1
    time_filter=["Last 24 Hours", "Last 7 Days","Last 30 Days"]
    time_filter.each{ |timeslot|
      include_examples "directly search for an a client using the url input with time filter", client_mac, client_name, timeslot
      include_examples "directly search for an a access point using the url input with time filter", ap_mac, "Romania-X620", timeslot
    }
end