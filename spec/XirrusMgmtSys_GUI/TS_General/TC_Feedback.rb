require_relative "./local_lib/feedback_lib.rb"
#############################################################################
##############TEST CASE: Test the FEEDBACK area##############################
#############################################################################
describe "********** TEST CASE: Test the FEEDBACK area **********" do
  include_examples "test support request to riverbed"
  include_examples "test feedback"
end