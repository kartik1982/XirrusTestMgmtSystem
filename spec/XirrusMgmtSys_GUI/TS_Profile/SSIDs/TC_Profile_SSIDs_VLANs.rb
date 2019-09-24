require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
###################################################################################################
#################TEST CASE: ADD, EDIT AND DELETE SSIDs VLANs####################################
###################################################################################################
describe "********** TEST CASE: ADD, EDIT AND DELETE SSIDs VLANs **********" do

  profile_name = UTIL.random_profile_name.downcase
  decription_prefix = "profile description for "

  include_examples "create profile from header menu", profile_name, "Profile description", false

  include_examples "toggle vlans from ssids", profile_name
  include_examples "add profile ssid", profile_name, 'ssid'
  include_examples "profile ssids vlans", profile_name
  include_examples "delete profile ssids", profile_name
  include_examples "toggle vlans from ssids", profile_name

end