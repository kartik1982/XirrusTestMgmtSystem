require_relative "./local_lib/dashboard_lib.rb"
require_relative "./local_lib/dashboard_tiles_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
##################################################################################################
##############TEST CASE: My network / dashboard test#############################################
##################################################################################################
describe "************TEST CASE: My network / dashboard test**************" do

	locations = ["Profiles","Access Points","Reports","MyNetwork / Access Points tab","MyNetwork / Clients tab","MyNetwork / Alerts tab","MyNetwork / Floor Plans tab","Settings / Support Management","Settings / Troubleshooting","Settings / Settings","Settings / Contact us"] #"Settings / Command Center",
	profile_name = "Filter to profile - " + UTIL.random_title.downcase + " TEST"
    description_prefix = "(TEST) Profile description for "

    include_examples "create profile from header menu", profile_name, description_prefix + profile_name, false
	include_examples "change to a certain profile from dashboard", profile_name
	include_examples "verify dashboard data", "#dashboard4", "0", "0", "0"
	locations.each { |location|
		include_examples "change locations and back to dashboard", profile_name , location, true
	}
	include_examples "change to a certain profile from dashboard", profile_name
	include_examples "verify dashboard data", "#dashboard4", "0", "0", "0"
	include_examples "delete profile from profile menu", profile_name

	end
