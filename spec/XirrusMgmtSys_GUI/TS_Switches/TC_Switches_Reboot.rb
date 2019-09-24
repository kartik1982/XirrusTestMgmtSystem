#XMSC-3344-Switch | Reboot a switch 
require_relative "./local_lib/switches_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
#############################################################################################################
##############TEST CASE: MY NETWORK area - Test SWITCH REBOOT OPTION########################################
#############################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test SWITCH REBOOT OPTION **********" do
  if $the_environment_used == "test03"
    switch_online_sn = "X030831A23A19"
    switch_offline_sn= "BBBBCCDD00DF"
  else
   switch_online_sn = "X030844A23A46"
   switch_offline_sn= "BBBBCCDD00DF"
  end
 profile_name = "Profile 1 for switch - " + UTIL.ickey_shuffle(5)
 description = "Profile description for " + profile_name
 # Delete all profiles and create profile for switch
 include_examples "delete all profiles when switch present"
 include_examples "Create profile from tile when switch present", profile_name, description, false
 #Assign single Switch to profile
 include_examples "assign switch(es) to profile", profile_name, [switch_online_sn, switch_offline_sn]
 include_examples "switch reboot feature", "online", profile_name, switch_online_sn
 include_examples "switch reboot feature", "offline", profile_name, switch_offline_sn
 include_examples "device filter online-offline-all", "switch"
end