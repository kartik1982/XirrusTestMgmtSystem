require_relative "./local_lib/clients_lib.rb"
###########################################################################################################################
###############TEST CASE: Test the MY NETWORK area - CLIENTS TAB - 'PROFILE/GROUP' FILTER##################################
###########################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - CLIENTS TAB - 'PROFILE/GROUP' FILTER **********" do
  include_examples "go to mynetwork clients tab"
  if $the_environment_used == "test03"
    include_examples "use profile group filter on clients", ["(group) (T03) Romania X320", "(profile) (T03) Romania 3 APs", "(profile) (T03) Romania X320", "(group) (T03) Romania 3 APs", "(group) No APs"]
 elsif $the_environment_used == "test01"
  include_examples "use profile group filter on clients", ["(group) (T01) Romania X320", "(profile) (T01) Romania 3 APs", "(profile) (T01) Romania X320", "(group) (T01) Romania 3 APs", "(group) No APs"]
  end
end
