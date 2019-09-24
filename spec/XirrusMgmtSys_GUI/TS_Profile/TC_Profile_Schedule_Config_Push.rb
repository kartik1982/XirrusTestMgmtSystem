#Author "Kartik Aiyar"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "./local_lib/profile_lib.rb"
###################################################################################################
############TEST CASE: Profile - Schedule Profile Configuration Push##############################
###################################################################################################
describe "****TEST CASE: Profile - Schedule Profile Configuration Push *****" do   
  profile_name = "Profile for schedule - " + UTIL.ickey_shuffle(5)
  decription = "Profile description for " + profile_name
  start_date=  2.days.from_now.strftime("%-m/%-d/%Y") #'12/10/2022'
  start_time= '10:51 am'
  time_zone = "(GMT-08:00) Tijuana, Baja California"
  push_note = "Profile config push will be trigger at above set date and time '#{start_date}'- '#{start_time}'"
   
  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, decription
  include_examples "verify schedule config push panel", profile_name 
  include_examples "verify schedule profile config push with Push Now button", profile_name, start_date, start_time, time_zone, push_note
  include_examples "verify schedule profile config push with Cancel button", profile_name, start_date, start_time, time_zone, push_note
  include_examples "verify schedule profile config push with Schedule button", profile_name, start_date, start_time, time_zone, push_note
end
  