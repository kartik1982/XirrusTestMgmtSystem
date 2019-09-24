require_relative "./local_lib/clients_lib.rb"
###############################################################################################################
################TEST CASE: Test the MY NETWORK area - Client Name Change - GENERAL FEATURS ############################
###############################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - Client Name Change - GENERAL FEATURS **********" do
 if $the_environment_used == "test01"
    client_name="MYPC"
    client_mac="00:21:5c:6b:d7:41"
  elsif $the_environment_used == "test03"
    client_name="MyPC"
    client_mac="ac:81:12:05:68:6b"
  end
  client_new_name = "automation-changed-"+client_name
  
  include_examples "go to mynetwork clients tab"
  include_examples "change client name from client slidout and verify", client_name, client_new_name, client_mac
  include_examples "verify client name on dashboard", client_new_name
  include_examples "go to mynetwork clients tab"
  include_examples "change client name from client slidout and verify", client_new_name, client_name, client_mac
  include_examples "verify client name on dashboard", client_name
end