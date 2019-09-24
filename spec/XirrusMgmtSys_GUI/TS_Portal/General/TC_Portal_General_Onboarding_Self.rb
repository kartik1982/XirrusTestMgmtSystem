require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Refresh_Grids/local_lib/refresh_grids_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
###########################################################################################
###################TEST CASE: PORTAL - ONBOARDING - SELF-ONBOARDING#######################
###########################################################################################
describe "********** TEST CASE: PORTAL - ONBOARDING - SELF-ONBOARDING **********" do

  profile_name = "Profile for SELF-ONBOARDING portal SSID settings"
  portal_name = "ONBOARDING - General - " + UTIL.ickey_shuffle(5)
  description = "DESCRIPTION FOR ... "
  portal_type = "onboarding"
  ssids_array = ["Registration SSID", "Network SSID 1", "Network SSID 2", "Network SSID 3", "Network SSID 4", "Network SSID 5"]
  ssids = Hash["Registration" => "Registration SSID", "Network" => ["Network SSID 1", "Network SSID 3", "Network SSID 5"], "Verify" => false]
  domains = ["test.com", "test.org", "test.ro", "test.edu"]
  verify_control = true
  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, description + profile_name, false
  ssids_array.each do |ssid|
    include_examples "add profile ssid", profile_name, ssid
  end
  include_examples "create portal from header menu", portal_name, description + portal_name, portal_type
  include_examples "verify self onboarding", portal_name, portal_type, verify_control, ssids, domains, profile_name
  ssids_array.each do |ssid|
    if ssid == ssids["Registration"]
      verified_ssid_hash = Hash["ssidName" => ssid, "band" => "2.4GHz & 5GHz", "encryptionAuth" => "None/Open", "enabled" => "Yes", "broadcast" => "Yes", "accessControl" => portal_name]
      include_examples "verify certain ssid line on certain profile", profile_name, ssid, verified_ssid_hash
    elsif ssids["Network"].include?(ssid)
      verified_ssid_hash = Hash["ssidName" => ssid, "band" => "2.4GHz & 5GHz", "encryptionAuth" => "WPA2/802.1x", "enabled" => "Yes", "broadcast" => "Yes", "accessControl" => portal_name]
      include_examples "verify certain ssid line on certain profile", profile_name, ssid, verified_ssid_hash
    else
      verified_ssid_hash = Hash["ssidName" => ssid, "band" => "2.4GHz & 5GHz", "encryptionAuth" => "None/Open", "enabled" => "Yes", "broadcast" => "Yes", "accessControl" => "None"]
      include_examples "verify certain ssid line on certain profile", profile_name, ssid, verified_ssid_hash
    end
  end
=begin
  include_examples "add honeypot ssid", profile_name

  ssids = Hash["Registration" => nil, "Network" => ["Network SSID 4", "honeypot"], "Verify" => false]
  verify_control = false

  include_examples "verify self onboarding", portal_name, portal_type, verify_control, ssids, domains, profile_name

  ssids_array = ["Registration SSID", "Network SSID 1", "Network SSID 2", "Network SSID 3", "Network SSID 4", "Network SSID 5", "honeypot"]
  ssids = Hash["Registration" => "Registration SSID", "Network" => ["Network SSID 1", "Network SSID 3", "Network SSID 4", "Network SSID 5", "honeypot"], "Verify" => false]

   ssids_array.each do |ssid|
    if ssid == ssids["Registration"]
      verified_ssid_hash = Hash["ssidName" => ssid, "band" => "2.4GHz & 5GHz", "encryptionAuth" => "None/Open", "enabled" => "Yes", "broadcast" => "Yes", "accessControl" => portal_name]
      include_examples "verify certain ssid line on certain profile", profile_name, ssid, verified_ssid_hash
    elsif ssids["Network"].include?(ssid)
      verified_ssid_hash = Hash["ssidName" => ssid, "band" => "2.4GHz & 5GHz", "encryptionAuth" => "WPA2/802.1x", "enabled" => "Yes", "broadcast" => "Yes", "accessControl" => portal_name]
      include_examples "verify certain ssid line on certain profile", profile_name, ssid, verified_ssid_hash
    else
      verified_ssid_hash = Hash["ssidName" => ssid, "band" => "2.4GHz & 5GHz", "encryptionAuth" => "None/Open", "enabled" => "Yes", "broadcast" => "Yes", "accessControl" => "None"]
      include_examples "verify certain ssid line on certain profile", profile_name, ssid, verified_ssid_hash
    end
  end
=end
  include_examples "delete portal", portal_name
=begin
  ssids_array.each do |ssid|
    verified_ssid_hash = Hash["ssidName" => ssid, "band" => "2.4GHz & 5GHz", "encryptionAuth" => "None/Open", "enabled" => "Yes", "broadcast" => "Yes", "accessControl" => "None"]
    include_examples "verify certain ssid line on certain profile", profile_name, ssid, verified_ssid_hash
  end

  include_examples "create portal from header menu", portal_name, description + portal_name, portal_type

  verify_control = true

  include_examples "verify self onboarding", portal_name, portal_type, verify_control, ssids, domains, profile_name

  include_examples "delete profile from tile", profile_name

  ssids = Hash["Registration" => "Empty", "Network" => ["Empty"], "Verify" => true]
  domains = "Empty"
  verify_control = false

  include_examples "verify self onboarding", portal_name, portal_type, verify_control, ssids, domains, profile_name
=end
end