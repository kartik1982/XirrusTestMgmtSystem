require_relative "./local_lib/clients_lib.rb"
require_relative "./local_lib/ap_lib.rb"
##############################################################################################
####################TEST CASE: Test the MY NETWORK area - CLIENTS TAB - ATERNETY##############
##############################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - CLIENTS TAB - ATERNETY  **********" do

  include_examples "change to tenant", "Aternity1", 1
  include_examples "open slideout and aternity for client", "XMS-SQA-1-PC" # "Marketing-Demo-6910p"

end