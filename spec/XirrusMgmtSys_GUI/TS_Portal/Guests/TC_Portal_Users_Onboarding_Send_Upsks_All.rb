require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/users_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_Reports/local_lib/reports_lib.rb"
###########################################################################################################################################
###################TEST CASE: PORTALS area - Test the ONBOARDING PORTAL - USERS TAB - ADD SEVERAL USERS SEND U-PSKs TO ALL OF THEM#########
###########################################################################################################################################
describe  "********** TEST CASE: PORTALS area - Test the ONBOARDING PORTAL - USERS TAB - ADD SEVERAL USERS SEND U-PSKs TO ALL OF THEM **********" do

  domain_name = "Child Domain for Portal Second tab"
  portal_name = "ONBOARDING Access Service - Test email of U-PSKs " + UTIL.ickey_shuffle(4)
  portal_description = "Description text for the portal named " + portal_name
  portal_type = "onboarding"
  original_length = 0

  include_examples "scope to tenant", domain_name
  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, portal_description, portal_type

  users_hash = return_users_hash_function

  used_user_names = []

  7.times do
    user_name = users_hash["User Names"].sample
    while used_user_names.include?(user_name) do
      user_name = users_hash["User Names"].sample
    end
    used_user_names << user_name
  end
  @used_user_emails = []

  used_user_names.each do |user_name|
    needed_index = users_hash["User Names"].index(user_name)
    user_email = users_hash["User Emails"][needed_index]
    @used_user_emails << user_email
    user_note = users_hash["User Notes"][needed_index]
    user_id = users_hash["User IDs"][needed_index]

    include_examples "add user for onboarding", portal_name, user_name, user_email, user_id, user_note, users_hash["User Groups"].sample, original_length, false, nil
    original_length = original_length+=1
  end

  # include_examples "prepare bulk email inbox for upsks emails"

  include_examples "send upsk", portal_name, "ALL", @used_user_emails

  used_user_names.each do |user_name|
    needed_index = users_hash["User Names"].index(user_name)
    user_email = users_hash["User Emails"][needed_index]

    include_examples "launch new browser window and verify report email received", user_email, "Your Wi-Fi access.", nil, " - Hello #{user_name}, You can now access the Guest Wi-Fi", nil
  end

  # include_examples "scope to parent tenant"

end