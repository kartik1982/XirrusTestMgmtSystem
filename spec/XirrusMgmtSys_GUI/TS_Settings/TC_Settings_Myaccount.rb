require_relative "./local_lib/settings_lib.rb"
##############################################################################################
#####################TEST CASE: Test settings Myaccount######################################
##############################################################################################
describe "TEST CASE: Test settings Myaccount" do
  include_examples "test my account basic settings"
  include_examples "test my account notification settings"
end