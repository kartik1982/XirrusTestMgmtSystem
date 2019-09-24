require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
###########################################################################################
#################TEST CASE: Test My Network Access Points##################################
###########################################################################################
describe "*******************TEST CASE: Test My Network Access Points**************************" do

  profile_name_readonly = UTIL.random_profile_name + " - Access Points tab test (READ ONLY)"
  decription_prefix = "Test profile description ... "

  ############ READ-ONLY PROFILE TESTS ############
  include_examples "create read-only profile from header menu", profile_name_readonly, decription_prefix + profile_name_readonly
  include_examples "assign first access point to profile", profile_name_readonly
  include_examples "verify readonly on my network area access point", 1
  include_examples "unasign access point based on profile search", profile_name_readonly

end