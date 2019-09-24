require_relative "./local_lib/settings_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
#########################################################################################################################
############TEST CASE: Test the SETTINGS area - ADD-ON SOLUTIONS TAB - CONTENT FILTERING - POSITIVE TESTING##############
#########################################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - ADD-ON SOLUTIONS TAB - CONTENT FILTERING - POSITIVE TESTING **********" do

  type_of_testing = "POSITIVE"
  include_examples "test content filtering settings", "1.1.1.1", "", type_of_testing
  include_examples "test content filtering settings", "2.2.2.2", "3.4.5.6", type_of_testing
  include_examples "test content filtering settings", "", "", type_of_testing

end

describe "********** TEST CASE: Test the SETTINGS area - ADD-ON SOLUTIONS TAB - CONTENT FILTERING - NEGATIVE TESTING **********" do

  type_of_testing = "NEGATIVE"
  include_examples "test content filtering settings", "just a string value", "", type_of_testing
  include_examples "test content filtering settings", "999.0.1.2", "3333.0.0.1", type_of_testing
  include_examples "test content filtering settings", "a.1.1.54", "3.3.3.3", type_of_testing
  include_examples "test content filtering settings", "3.3.3.3", "just a string value", type_of_testing
  include_examples "test content filtering settings", "", "4.4.4.4", type_of_testing

end