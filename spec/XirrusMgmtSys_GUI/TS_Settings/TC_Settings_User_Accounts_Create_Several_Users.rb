require_relative "./local_lib/settings_lib.rb"
###########################################################################################################
############TEST CASE: Test the SETTINGS area - USERS TAB - CREATE, EDIT then DELETE USERS################
###########################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - USERS TAB - CREATE, EDIT then DELETE USERS **********" do
  include_examples "delete all user accounts", "Dinte"
  include_examples "create several user accounts", 2, "User", "None", false
  include_examples "create several user accounts", 2, "Read Only", "None", false
  include_examples "create several user accounts", 2, "Admin", "None", false
  include_examples "create several user accounts", 2, "User", "Admin", false
  include_examples "create several user accounts", 2, "Read Only", "Admin", true
  include_examples "create several user accounts", 2, "Admin", "Admin", true
  include_examples "create several user accounts", 2, "Guest Ambassador", "None", true
  include_examples "delete all user accounts", "Dinte"
end