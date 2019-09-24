require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
########################################################################################################
###################TEST CASE: EDIT PROFILE SETTINGS ON  THE GENERAL TAB################################
########################################################################################################
describe "********** TEST CASE: EDIT PROFILE SETTINGS ON  THE GENERAL TAB **********" do

  profile_name = UTIL.random_title.downcase
  decription_prefix = "profile description for "
  
  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, "Profile description ...", false
  include_examples "go to profile", profile_name
  include_examples "update profile general settings", profile_name , decription_prefix + "profile"
  include_examples "reset the profile general settigs to default", profile_name, "Profile description ...", "United States", "(GMT - 08:00) Pacific Time (US & Canada); Tijuana"
  include_examples "update profile advanced settings", profile_name

end




