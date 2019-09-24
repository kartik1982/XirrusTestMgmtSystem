require_relative "./local_lib/settings_lib.rb"
#############################################################################################
###############TEST CASE: SETTINGS AREA - PROVIDER MANAGEMENT TAB##########################
#############################################################################################
describe "********** TEST CASE: SETTINGS AREA - PROVIDER MANAGEMENT TAB **********" do

	provider_name = "Albania_" + UTIL.ickey_shuffle(5)

	include_examples "go to settings then to tab", "Provider Management"
  	include_examples "add mobile provider", provider_name , "al.com", "Albania", "TEST", "END"
  	include_examples "disable mobile provider", provider_name
  	include_examples "edit certain mobile provider", provider_name, "", "test.co.al", "", "NEWTEST", "NEWEND"
  	include_examples "edit certain mobile provider", provider_name, "", "", "", "", "STOP"
  	include_examples "enable mobile provider", provider_name

  	provider_name_new = "Canada_" + UTIL.ickey_shuffle(5)
  	include_examples "edit certain mobile provider", provider_name, provider_name_new, "", "Canada", "", "STOP"

  	include_examples "delete mobile provider", provider_name_new
end