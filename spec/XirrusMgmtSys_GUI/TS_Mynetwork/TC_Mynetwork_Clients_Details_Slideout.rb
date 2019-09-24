require_relative "./local_lib/clients_lib.rb"
require_relative "./local_lib/ap_lib.rb"
#####################################################################################################################
#################TEST CASE: Test the MY NETWORK area - CLIENTS TAB###################################################
#####################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - CLIENTS TAB **********" do
   if $the_environment_used == "test01"
    client_name="MYPC"
  elsif $the_environment_used == "test03"
    client_name="MyPC"
  end
	include_examples "change to tenant", "1-Macadamian Child XR-620-Auto", 1
	include_examples "verify slideout for client", client_name

end