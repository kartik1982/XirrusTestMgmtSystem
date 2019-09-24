require_relative "./local_lib/settings_lib.rb"
###########################################################################################################################
#################TEST CASE: Test User Name display right top screen reflecting from 'My Account' page Settings##############
###########################################################################################################################
describe "****TEST CASE: Test User Name display right top screen reflecting from 'My Account' page Settings****" do
    # Test string
    name_to_set= 'test_firstname'
    include_examples "Verify user name display on top screen with info provided under My Account", name_to_set
    # Test max length 50
    name_to_set= '12345678901234567890123456789012345678901234567890'
    include_examples "Verify user name display on top screen with info provided under My Account", name_to_set
    # Test blank firstname, expect email
    name_to_set= ''
    include_examples "Verify user name display on top screen with info provided under My Account", name_to_set
end