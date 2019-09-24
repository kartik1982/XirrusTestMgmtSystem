require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
################################################################################################################################################
##############TEST CASE: Test the MY NETWORK area - ACCESS POINTS TAB - ASSIGN and then UNASSIGN and AP to and from a PROFILE###################
################################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - ACCESS POINTS TAB - ASSIGN and then UNASSIGN and AP to and from a PROFILE **********"  do


	profile_name = "Profile - " + UTIL.ickey_shuffle(9)
  	decription_prefix = "Test profile description ... "

	include_examples "create profile from header menu", profile_name, decription_prefix + profile_name
  	include_examples "assign first access point to profile", profile_name
  	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Profile: "+profile_name, "Access Point: FIND FROM PREVIOUS ASSIGN METHOD"], 1
  	include_examples "unasign access point based on profile search", profile_name
  	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Access Point: FIND FROM PREVIOUS ASSIGN METHOD"], 1
	include_examples "delete profile from tile", profile_name
end
