shared_examples "set name value for admin settings" do |name|
  describe "Set the value '#{name}'' for the Profile Administrator Settings" do
    before :all do
      @ui.click('#profile_config_tab_admin')
      sleep 3
    end
    it "Set the name value to '#{name}' and save the profile" do
      @ui.set_input_val('#profile_config_admin_name', name)
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end
    it "Verify that the text value is '#{name}'" do
      expect(@ui.get(:text_field, { id: 'profile_config_admin_name' }).value).to eq(name)
    end
  end
end

shared_examples "update profile admin settings" do |profile_name|
  describe "Update profile admin settings" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_config_tab_admin')
    end

    it "Update name, email and save" do
      name = @ui.get(:text_field, { id: 'profile_config_admin_name' })
      name.wait_until_present

      nameval = name.value
      name.set "update name"

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      name.wait_until_present
      expect(name.value).to eq("update name")

      #reset
      name.set nameval

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end

    it "Update email and save" do
      email = @ui.get(:text_field, { id: 'profile_config_admin_email' })
      email.wait_until_present

      emailval = email.value
      email.set "updateemail@xirrus.com"

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      email.wait_until_present
      expect(email.value).to eq("updateemail@xirrus.com")

      #reset

      email.set emailval

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end

    it "Update phone number and save" do
      phone = @ui.get(:text_field, { id: 'profile_config_admin_phone' })
      phone.wait_until_present

      phoneval = phone.value
      phone.set "555-555-5555"

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      phone.wait_until_present
      expect(phone.value).to eq("5555555555")

      #reset

      phone.set phoneval

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end

    it "Update password and save" do
      @ui.click('#showSetPassword .switch_label')
      @ui.set_input_val('#profile_config_admin_password','A1234567')
      @ui.set_input_val('#profile_config_admin_password2','A1234567')

      expect(@ui.get(:checkbox, {id: "showSetPassword_switch"}).set?).to eq(true)

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 3

      expect(@ui.get(:checkbox, {id: "showSetPassword_switch"}).set?).to eq(false)
    end
  end
end