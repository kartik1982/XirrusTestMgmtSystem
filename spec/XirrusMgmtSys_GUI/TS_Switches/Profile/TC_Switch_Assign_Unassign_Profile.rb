require_relative "../local_lib/switches_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
##############################################################################################################
##############TEST CASE: MY NETWORK area - Test the SWITCH tab - Switch ASSIGNED / UNASSIGNED TO A PROFILE####
##############################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test the SWITCH tab - Switch ASSIGNED / UNASSIGNED TO A PROFILE **********" do
 profile_name = "Profile 1 for switch - " + UTIL.ickey_shuffle(5)
 description = "Profile description for " + profile_name
 profile_name_2 = "Profile 2 for switch - " + UTIL.ickey_shuffle(5)
 description = "Profile description for " + profile_name 
 single_switch = ["BBBBCCDD00B0"]
 multiple_switches=["BBBBCCDD00B2","BBBBCCDD00B3","BBBBCCDD00B5"]
 
 # include_examples "go to profile tile when switch present" 
 include_examples "delete all profiles when switch present"
 include_examples "Create profile from tile when switch present", profile_name, description, false
 # include_examples "go to profile tile when switch present" 
 include_examples "Create profile from tile when switch present", profile_name_2, description, false
 #Assign single Switch to profile
 include_examples "assign switch(es) to profile", profile_name, single_switch 
 #move between profiles
 include_examples "assign switch(es) to profile", profile_name_2, single_switch 
 #Unassign single switch from profile
 include_examples "unasign Switch(es) from profile", single_switch
 #Assign multiple switch to profile
 include_examples "assign switch(es) to profile", profile_name, multiple_switches
 #Unassign multiple switches from profile
 include_examples "unasign Switch(es) from profile", multiple_switches
 include_examples "delete all profiles when switch present"

end