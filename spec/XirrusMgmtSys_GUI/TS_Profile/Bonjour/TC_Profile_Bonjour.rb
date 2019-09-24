require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/bonjour_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
###########################################################################################
##################TEST CASE: Edit profile bonjour settings################################
###########################################################################################
describe "*********TEST CASE: Edit profile bonjour settings********************" do

  profile_name = UTIL.random_title.downcase

  include_examples "create profile from header menu", profile_name, "Profile description", false
  sleep 2
  include_examples "update profile bonjour settings", profile_name
  sleep 2
end