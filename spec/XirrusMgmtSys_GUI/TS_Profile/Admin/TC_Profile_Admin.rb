require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/admin_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
#####################################################################################################
#######################TEST CASE: Edit profile admin settings######################################
#####################################################################################################
describe "*****************TEST CASE: Edit profile admin settings**************" do

  profile_name = UTIL.random_title.downcase

  include_examples "create profile from header menu", profile_name, "Profile description", false
  sleep 2
  include_examples "update profile admin settings", profile_name
  sleep 2

end