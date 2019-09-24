require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Refresh_Grids/local_lib/refresh_grids_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
###########################################################################################
###################TEST CASE: PORTAL - ONBOARDING - SELF-ONBOARDING########################
###########################################################################################
describe "********** TEST CASE: PORTAL - ONBOARDING - SELF-ONBOARDING **********" do

  profile_name = "Profile for SELF-ONBOARDING portal SSID settings"
  portal_name = "ONBOARDING - General - " + UTIL.ickey_shuffle(5)
  description = "DESCRIPTION FOR ... "
  portal_type = "onboarding"
  ssids_array = ["Registration SSID", "Network SSID 1"]
  ssids = Hash["Registration" => "Registration SSID", "Network" => ["Network SSID 1"], "Verify" => false]
  domains = ["test.com", "test.edu"]
  verify_control = true
  include_examples "delete all profiles from the grid"
  include_examples "verify portal list view tile view toggle"
  include_examples "create profile from header menu", profile_name, description + profile_name, false
  ssids_array.each do |ssid|
    include_examples "add profile ssid", profile_name, ssid
  end
  include_examples "create portal from header menu", portal_name, description + portal_name, portal_type
  include_examples "verify self onboarding", portal_name, portal_type, verify_control, ssids, domains, profile_name
  include_examples "update selfonboarding optional user authentication azure google", portal_name, portal_type, "Google", $google_user, $google_password
  ssids_array.each do |ssid|
    if ssids["Network"].include?(ssid)
      verified_ssid_hash = Hash["ssidName" => ssid, "band" => "2.4GHz & 5GHz", "encryptionAuth" => "WPA2/802.1x", "enabled" => "Yes", "broadcast" => "Yes", "accessControl" => portal_name]
    elsif ssid == ssids["Registration"]
      verified_ssid_hash = Hash["ssidName" => ssid, "band" => "2.4GHz & 5GHz", "encryptionAuth" => "None/Open", "enabled" => "Yes", "broadcast" => "Yes", "accessControl" => portal_name]
    else
      verified_ssid_hash = Hash["ssidName" => ssid, "band" => "2.4GHz & 5GHz", "encryptionAuth" => "None/Open", "enabled" => "Yes", "broadcast" => "Yes", "accessControl" => "None"]
    end
    include_examples "verify certain ssid line on certain profile", profile_name, ssid, verified_ssid_hash
  end
end