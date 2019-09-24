require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Mynetwork/local_lib/groups_lib.rb"
require_relative "./local_lib/settings_lib.rb"
###############################################################################################################################
############TEST CASE: Test the SETTINGS area - USERS TAB - Change User Privileges for Proffile Group Easy pass################
###############################################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - USERS TAB - Change User Privileges for Proffile Group Easy pass **********" do
  child_domain = "Child Domain for User Privileges Second tab"
  user_email = "user+privileges+auotmation+xms+admin@xirrus.com"
  profiles = ["Profile_Normal_01", "Profile_Normal_02", "Profile_Restricted_01", "Profile_Restricted_02"]
  groups = ["Group_Normal_01", "Group_Normal_02", "Group_Restricted_01", "Group_Restricted_02"]
  easypasses = ["Easypass_Normal_01", "Easypass_Normal_02", "Easypass_Restricted_01", "EasyProfile_Restricted_02"]
  #Create child domain and user
  include_examples "go to commandcenter"
  include_examples "create Domain", child_domain
  include_examples "assign and Unassign several arrays to a domain", child_domain, "Assign"
  include_examples "go to specific tab", "Users"
  include_examples "edit administrator from administrators tab", user_email, "Add to Account", child_domain, "XMS User"
  #Scope tenant and create Profile, Group and Easy pass
  include_examples "scope to tenant", child_domain
  #Delete all Profiles, Group and Easy pass
  include_examples "verify portal list view tile view toggle"
  include_examples "delete all profiles from the grid"
  include_examples "go to groups tab"
  include_examples "delete all groups from the grid"
  profiles.each do |profile|
    include_examples "create profile from header menu", profile, "Profile description for"+profile, false
  end
  easypasses.each do |easypass|
    include_examples "create portal from header menu", easypass, "Description for"+easypass, "self_reg"
  end
  include_examples "go to groups tab"
  groups.each do |group|
    include_examples "add a group", group, "Group Description for"+group, ""
  end

  #Verify User Privileges panel
  include_examples "verify user privileges panel", user_email
  #Assign Profile, Group and Easypass privileges to User
  include_examples "assign user privileges for profiles-groups-easypass", user_email, ["Profile_Normal_01", "Profile_Normal_02"], ["Group_Normal_01", "Group_Normal_02"], ["Easypass_Normal_01", "Easypass_Normal_02"]
  #Login with user and verify that only can access profile, group and easypass assigned
  include_examples "logout and login with user and password", user_email, "Qwerty1@"
  #Scope tenant and verify Profile, Group and Easy pass
  include_examples "scope to tenant", child_domain
  include_examples "verify restricted profile-group-easypass only available", ["Profile_Normal_01", "Profile_Normal_02"], ["Group_Normal_01", "Group_Normal_02"], ["Easypass_Normal_01", "Easypass_Normal_02"]
  
  describe "********** Unassign all Access POints and delete child domain **********"  do
    child_domain = "Child Domain for User Privileges Second tab"
    include_examples "logout and login with user and password", @username, @password
    include_examples "go to commandcenter"
    include_examples "assign and Unassign several arrays to a domain", child_domain, "Unassign"
    include_examples "delete Domain", child_domain
  end
end