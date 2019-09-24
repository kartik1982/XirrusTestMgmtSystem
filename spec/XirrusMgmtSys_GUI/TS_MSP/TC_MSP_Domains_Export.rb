require_relative "./local_lib/msp_lib.rb"
require_relative "../environment_variables_library.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
#############################################################################################################################
##################TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - EXPORT############################################
#############################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - EXPORT **********"  do

  first_ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/export", "serial number")[0]
  first_mac = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/export", "mac")[0]
  second_ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/export", "serial number")[1]
  second_mac = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/export", "mac")[1]
  
  include_examples "set timezone area to local"
  domain_names_array = []
  include_examples "go to commandcenter"
  3.times do |i|
    include_examples "create Domain", "Automation Export Domain " + i.to_s
    domain_names_array.push("Automation Export Domain " + i.to_s)
  end

  verified_parameters = Hash["CSV lines" => ["Domain,Online APs,Offline APs,Out-of-Service APs,Total APs","\"#{domain_names_array[0]}\",\"0\",\"1\",\"0\",\"1\"" , "\"#{domain_names_array[1]}\",\"0\",\"0\",\"0\",\"0\"" ,"\"#{domain_names_array[2]}\",\"0\",\"1\",\"0\",\"1\""]]
  
  include_examples "only assign array to domain", first_ap_sn, "Automation Export Domain 0"
  include_examples "only assign array to domain", second_ap_sn, "Automation Export Domain 2"
  include_examples "go to specific tab", "Dashboard"
  include_examples "export msp domains groups", verified_parameters
  include_examples "only unassign array to domain", first_ap_sn, "Automation Export Domain 0"
  include_examples "only unassign array to domain", second_ap_sn, "Automation Export Domain 2"
  3.times do |i|
    include_examples "delete Domain", "Automation Export Domain " + i.to_s
  end
  include_examples "export msp domains groups", nil
end
