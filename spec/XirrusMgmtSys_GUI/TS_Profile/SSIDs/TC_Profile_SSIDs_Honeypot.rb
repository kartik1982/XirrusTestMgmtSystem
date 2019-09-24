require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
###################################################################################################
############TEST CASE: ADD, EDIT AND DELETE HONEYPOT SSIDs######################################
###################################################################################################
describe "********** TEST CASE: ADD, EDIT AND DELETE HONEYPOT SSIDs **********" do
  profile_name = UTIL.random_title.downcase
  decription_prefix = "profile description for "

  include_examples "create profile from header menu", profile_name, "Profile description", false
  sleep 2
  include_examples "add honeypot ssid", profile_name
  sleep 2
  include_examples "edit honeypot ssid", profile_name
  sleep 2
  include_examples "delete honeypot ssid", profile_name
  sleep 2
end