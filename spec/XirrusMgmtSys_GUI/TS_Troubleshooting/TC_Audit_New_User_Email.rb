require_relative "./local_lib/troubleshooting_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
####################################################################################
###########TEST CASE:*******New user email audit####################################
####################################################################################
describe "TEST CASE:*******New user email audit ***************" do
  new_user_email = "audit_first@audit.com"
  include_examples "set date time format to specific", "MM/DD/YYYY", "24 hour"
  include_examples "test user account general settings - add user", "TEST", "ACCOUNT", new_user_email, "THIS IS A TEST ACCOUNT (should be deleted!)", "Admin", "Admin"
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "EMAIL", Array["User: "+ new_user_email, 'Maintenance Window: Default'], 1
  include_examples "delete all user accounts", "Dinte"
end
