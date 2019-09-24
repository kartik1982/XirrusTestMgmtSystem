require_relative "./local_lib/filter_by_groups_profiles_ssids_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Mynetwork/local_lib/groups_lib.rb"
#################################################################################################
##############TEST CASE: Filter by Group-Profile-SSID########################################
#################################################################################################
describe "********** TEST CASE: Filter by Group-Profile-SSID **********" do
  sections=["none"]
  groups=[]
  profiles=[]
  ssids=[]
  
  #clean up delete all Profile and Groups
  include_examples "go to groups tab"
  include_examples "delete all groups from the grid"
  include_examples "delete all profiles from the grid"
  
  #verify that if there is no Group, No Profile and no SSIDs drop-down list shows only "All Access Points"
  include_examples "verify that filter for groups-profiles-ssids drop-down display list", sections, groups, profiles, ssids
  
  #create profile with SSIDs and Groups
  sections=["all"]
  groups=["Group-Automation-01", "Group-Automation-02","Group-Automation-03"]
  profiles=["Profile-Automation-01","Profile-Automation-02", "Profile-Automation-03"]
  ssids=["Profile-Automation-01-SSID-01", "Profile-Automation-01-SSID-02", "Profile-Automation-01-SSID-03"]
  profiles.each do |profile_name|
    include_examples "if profile name does not exist then create it", profile_name, "description of "+profile_name, false
  end
  groups.each do |group_name|
    include_examples "go to groups tab"
    include_examples "add a group", group_name, "description of "+group_name, ""
  end
  ssids.each do |ssid_name|
    include_examples "add profile ssid", profiles[0], ssid_name
  end
  #verify that Profile-Groups and SSIDs drop-down list shows all entries
  include_examples "verify that filter for groups-profiles-ssids drop-down display list", sections, groups, profiles, ssids

  #clean up delete all Profile and Groups
  include_examples "go to groups tab"
  include_examples "delete all groups from the grid"
  include_examples "delete all profiles from the grid"
end




