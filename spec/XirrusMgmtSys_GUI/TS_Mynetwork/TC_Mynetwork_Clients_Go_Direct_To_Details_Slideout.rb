require_relative "./local_lib/ap_lib.rb"
require_relative "./local_lib/clients_lib.rb"
require_relative "./local_lib/dashboard_lib.rb"
require_relative "./local_lib/dashboard_tiles_lib.rb"
######################################################################################################################
################TEST CASE: Test the MY NETWORK area - CLIENTS TAB - DIRECT LINK USING MAC ADDRESS IN URL##############
######################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - CLIENTS TAB - DIRECT LINK USING MAC ADDRESS IN URL **********" do

  include_examples "change to tenant", "1-Macadamian Child XR-620-Auto", 1
  include_examples "set filter to All Devices", "MyNetwork / Clients tab"

  locations = ["Profiles","Access Points","Reports","MyNetwork / Access Points tab","MyNetwork / Clients tab","MyNetwork / Alerts tab","MyNetwork / Floor Plans tab","Settings / Support Management","Settings / Troubleshooting","Settings / Settings","Settings / Contact us"] #"Settings / Command Center",
  locations.each { |location|
    include_examples "change locations and back to dashboard", nil, location, false
    if location.include?"tab"
      include_examples "directly search for an a client using the url input of the browser", "D8:30:62:53:C3:76", "Adrians-iMac", false
    else
      include_examples "directly search for an a client using the url input of the browser", "D0:92:9E:1B:52:E4", "Windows-Phone", false
    end
    include_examples "change locations and back to dashboard", nil, location, false
    include_examples "directly search for an a client using the url input of the browser", "NOT_A_VALID_MAC", nil, true
  }

end