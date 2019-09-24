require_relative "../local_lib/steel_connect_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/dashboard_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/dashboard_tiles_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
############################################################################################################
##########################TEST CASE: STEEL CONNECT - GO DIRECTLY TO AP DETAILS SLIDEOUT#####################
############################################################################################################
describe "********** TEST CASE: STEEL CONNECT - GO DIRECTLY TO AP DETAILS SLIDEOUT **********" do

  locations = ["Profiles","Access Points","Reports","MyNetwork / Access Points tab","MyNetwork / Clients tab","MyNetwork / Alerts tab","MyNetwork / Floor Plans tab","Settings / Support Management","Settings / Troubleshooting","Settings / Settings","Settings / Contact us"] #"Settings / Command Center",
  locations.each { |location|
    include_examples "scope to tenant", "Adrian-Automation-Chrome-SteelConnect-Child"
    include_examples "change locations and back to dashboard", nil, location, false
    include_examples "directly search for an ap using the url input of the browser", "AUTOXR320CHROME001STEELCONNECT", "AutomationXR320-CHROME-001-SteelConnect" , false
    include_examples "change locations and back to dashboard", nil, location, false
    include_examples "directly search for an ap using the url input of the browser", "NOTAVALIDSERIALNUMBER", nil, true
  }


end