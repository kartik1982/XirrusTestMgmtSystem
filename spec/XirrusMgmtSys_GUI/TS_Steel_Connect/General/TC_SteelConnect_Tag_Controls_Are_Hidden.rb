require_relative "../local_lib/steel_connect_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profile/local_lib/ap_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/floorplans_lib.rb"
require_relative "../../environment_variables_library.rb"
#################################################################################################################################
###############TEST CASE: STEEL CONNECT - ACCESS POINTS Details Slideout - TAGS control HIDDEN & LOCATION control READ-ONLY######
#################################################################################################################################
describe "********** TEST CASE: STEEL CONNECT - ACCESS POINTS Details Slideout - TAGS control HIDDEN & LOCATION control READ-ONLY **********" do

  profile_name = "STEEL CONNECT - DEFAULT EXISTING PROFILE"
  ap_sn = "AUTOXR320CHROME001STEELCONNECT"
  ap_hostname = "AutomationXR320-CHROME-001-SteelConnect"

  building_name = "BUILDING - " + UTIL.ickey_shuffle(3)
  floor_name = "FLOOR - " + UTIL.ickey_shuffle(1)
  image_name = "/xirrus.png"
  environment = ["Apartment Building", "Convention Center", "Office (Cubicles)", "Hospital", "Hotel", "Outdoors", "School", "Office (Walled)", "Warehouse"].sample
  scale_amout = "5"
  scale_units = ["ft", "m"]
  scale_unit = scale_units.sample
  address_search = "FDR Dr, Manhattan, New York, New York 10075, United States"
  address_verify = ["CVS Pharmacy, 1569 1st Ave, New York, New York 10028, United States", "Main St, Manhattan, New York, New York 10044, United States", "37 River Rd, Manhattan, New York, New York 10044, United States", "East River Esplanade, Manhattan, New York, New York, United States", "Manhattan, New York, New York 10009, United States"]
  ap_status = "/img/floorArrayOffline.png"
  ap_model = "XR320"

  include_examples "scope to tenant", "Adrian-Automation-Chrome-SteelConnect-Child"

  include_examples "go to mynetwork access points tab"
  include_examples "reset grid to default view", "My Network - Access Points tab", ""
  include_examples "ap slideout tag control is hidden", ap_sn, false, nil
  include_examples "verify tags column not present in column selector", "My Network - Access Points tab", "", "Tags"

  include_examples "reset grid to default view", "Profile - Access Points tab (SteelConnect)", profile_name

  include_examples "delete all floorplans from the grid"
  include_examples "create building", building_name, floor_name, image_name, false, true
  include_examples "edit building", building_name, environment, scale_amout, scale_unit, address_search, address_verify
  include_examples "edit building set ap", building_name, ap_hostname, ap_status
  include_examples "ap slideout tag control is hidden", ap_sn, true, Hash["Building Name" => building_name, "AP Hostname" => ap_hostname, "AP Model" => ap_model]

end