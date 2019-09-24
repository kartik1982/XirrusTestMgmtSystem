require_relative "./local_lib/settings_lib.rb"
################################################################################################
#################TEST CASE: Test the SETTINGS area - USERS TAB - GENERAL SETTINGS################
################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - USERS TAB - GENERAL SETTINGS **********" do
  include_examples "test user account general settings - add user", "TEST", "ACCOUNT", "test@account.ro", "THIS IS A TEST ACCOUNT (should be deleted!)", "Admin", "Admin"
  include_examples "test user account general settings - edit user", "TEST", "NEW_TEST", "ACCOUNT", "ACCOUNT_NEW", "test@account.ro", "new_test@account.ro", "THIS IS A TEST ACCOUNT (should be deleted!)", "NEW DETAILS: THIS IS A TEST ACCOUNT (should be deleted!)", "Admin", "User", "Admin", "Admin"
  include_examples "delete all user accounts", "Dinte"
end


