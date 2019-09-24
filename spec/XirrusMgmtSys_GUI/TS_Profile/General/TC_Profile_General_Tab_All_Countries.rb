require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
########################################################################################################
###################TEST CASE: EDIT PROFILE SETTINGS ON THE GENERAL TAB - ALL COUNTRIES#################
########################################################################################################
describe "********** TEST CASE: EDIT PROFILE SETTINGS ON THE GENERAL TAB - ALL COUNTRIES **********" do

  profile_name = UTIL.random_title.downcase
  decription_prefix = "profile description for "

  include_examples "create profile from header menu", profile_name, "Profile description ...", false
  include_examples "go to profile", profile_name
  include_examples "update to all available countries", profile_name

end




