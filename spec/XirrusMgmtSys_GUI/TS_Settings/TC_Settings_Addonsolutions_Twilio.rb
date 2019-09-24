require_relative "./local_lib/settings_lib.rb"
#######################################################################################################
#######################TEST CASE: Test the SETTINGS area - ADD-ON SOLUTIONS TAB - TWILIO###############
#######################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - ADD-ON SOLUTIONS TAB - TWILIO **********" do

  include_examples "set twillio account" , "1234567890", "1234567890", "+400730973335"
  include_examples "set twillio account" , "", "", ""

end