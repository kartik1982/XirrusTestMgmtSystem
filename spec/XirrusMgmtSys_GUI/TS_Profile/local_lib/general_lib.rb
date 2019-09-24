shared_examples "update profile name" do |profile_name, profile_name_new|
  describe "Update the profile '#{profile_name}' to '#{profile_name_new}'" do
    it "Update the profile name from '#{profile_name}' to '#{profile_name_new}' and press the 'Save All' button" do
      @ui.set_input_val("#profile_config_basic_profilename", profile_name_new)
      sleep 1
      @ui.click(".commonTitle span")
      sleep 1
      expect(@ui.get(:input, {id: "profile_config_basic_profilename"}).value).to eq(profile_name_new)
    end
  end
end

shared_examples "update network time protocol" do
  describe "Update the Network Time Protocol settings" do
    it "Press the 'Show Advanced' hyperlink to display the advanced settings options" do
      adv = @ui.click("#general_show_advanced")
    end
    it "Network Time Protocol: Set the Primary Server value to 'ntp.custom.com'" do
      @ui.set_input_val("#profile_config_basic_primaryserver", "ntp.custom.com")
    end
    it "Network Time Protocol: Set the Primary Authentication comboBox to 'SHA1'" do
      @ui.set_dropdown_entry('profile_config_basic_primaryauthentication', 'SHA1')
      sleep 1
    end
    it "Network Time Protocol: Set the Primary Authentication Key ID to '111' and Primary Authentication Key to '12345678'" do
      @ui.set_input_val("#profile_config_basic_primaryauthenticationkeyid", "111")
      @ui.set_input_val("#profile_config_basic_primaryauthenticationkey", "12345678")
    end
    it "Press the 'Save All' button" do
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end
    it "Expected Result: all the changes are properly saved and remembered " do
      primary = @ui.get(:text_field, {id: "profile_config_basic_primaryserver"})
      primary.wait_until_present
      expect(primary.type).to eq("text")
      expect(primary.attribute_value("maxlength")).to eq("256")
      expect(primary.value).to eq("ntp.custom.com")

      expect(@ui.id('profile_config_basic_primaryauthentication').element(:css => ".ko_dropdownlist_button .text").text).to eq('SHA1')

      keyid = @ui.get(:text_field, {id: "profile_config_basic_primaryauthenticationkeyid"})
      keyid.wait_until_present
      expect(keyid.type).to eq("text")
      expect(keyid.attribute_value("maxlength")).to eq("5")
      expect(keyid.value).to eq("111")

      key = @ui.get(:text_field, {id: "profile_config_basic_primaryauthenticationkey"})
      key.wait_until_present
      expect(key.type).to eq("password")
      expect(key.attribute_value("maxlength")).to eq("20")
      expect(key.value).to eq("--------")
    end
  end
end

shared_examples "update profile general settings" do |profile_name, profile_description|
  describe "Update profile general settings" do
    it "Update the profile name from '#{profile_name}' to '#{profile_name} update' and press the 'Save All' button" do
      @ui.set_input_val("#profile_config_basic_profilename", profile_name + " update")
      sleep 0.5
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end
    it "Expected Result: the profile name input box has the value '#{profile_name} update' and supports a maxLength of 255 characters" do
      pn = @ui.get(:text_field, {id: "profile_config_basic_profilename"})
      pn.wait_until_present
      expect(pn.type).to eq("text")
      expect(pn.attribute_value("maxlength")).to eq("255")
      expect(pn.value).to eq(profile_name + " update")
    end
    it "Update the profile description from '#{profile_description}' to '#{profile_description} update' and press the 'Save All' button" do
      @ui.set_textarea_val('#profile_config_basic_description', profile_description + " update")
      sleep 0.5
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end
    it "Expected Result: the profile description input box has the value '#{profile_description} update' and supports a maxLength of 1000 characters" do
      pd = @ui.get(:textarea, {id: "profile_config_basic_description"})
      pd.wait_until_present
      expect(pd.attribute_value("maxlength")).to eq("1000")
      expect(pd.value).to eq(profile_description + " update")
    end
  end
end

shared_examples "update to all available countries" do |profile_name|
  describe "Update the profile named '#{profile_name}' to all available countries and save" do
    all_countries = Array["Algeria","Argentina","Australia","Austria","Bahamas","Bahrain","Belgium","Brazil","Brunei","Canada","Chile","China","Colombia","Denmark","Dominican Republic","Ecuador","Egypt","Finland","France","Germany","Greece","Hong Kong","Hungary","India","Indonesia","Ireland","Israel","Italy","Japan","Kuwait","Lebanon","Luxembourg","Macau","Malaysia","Mexico","Netherlands","New Zealand","Norway","Oman","Peru","Philippines","Poland","Portugal","Qatar","Russia","Saudi Arabia","Singapore","Slovenia","South Africa","South Korea","Spain","Sweden","Switzerland","Taiwan","Thailand","Trinidad and Tobago","Turkey","Ukraine","United Arab Emirates","United Kingdom","United States","Venezuela","Vietnam"]
    all_countries.each { |country|
      it "Update the profile country to the option '#{country.upcase}', press the 'Save All' button and verify the correct entry is displayed" do
          @ui.set_dropdown_entry('profile_config_basic_country', country)
          sleep 0.5
          save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
          sleep 1
          expect(@ui.css('#profile_config_basic_country .ko_dropdownlist_button .text').text).to eq(country)
          sleep 0.5
      end
    }
  end
end

shared_examples "update to all available time zones" do |profile_name|
  describe "Update the profile named '#{profile_name}' to all available time zones, save and verify" do
    all_timezones = Array["(GMT - 12:00) Eniwetok Kwajalein","(GMT - 11:00) Midway Island, Samoa","(GMT - 10:00) Hawaii","(GMT - 09:00) Alaska","(GMT - 08:00) Pacific Time (US & Canada); Tijuana","(GMT - 07:00) Mountain Time (US & Canada)","(GMT - 06:00) Central Time (US & Canada)","(GMT - 05:00) Eastern Time (US & Canada)","(GMT - 04:00) Atlantic Time (Canada)","(GMT - 03:30) Newfoundland","(GMT - 03:00) Buenos Aires, Georgetown","(GMT - 02:00) Mid-Atlantic","(GMT - 01:00) Azores, Cape Verde Is.","(GMT) Greenwich Mean Time: Dublin, Lisbon, London","(GMT + 01:00) Amsterdam, Copenhagen, Madrid, Paris","(GMT + 02:00) Israel","(GMT + 03:00) Moscow, St. Petersburg, Volgograd","(GMT + 03:30) Tehran","(GMT + 04:00) Abu Dhabi, Muscat","(GMT + 04:30) Kabul","(GMT + 05:00) Islamabad, Karachi, Tashkent","(GMT + 05:30) Bombay, Calcutta, Madras, New Delhi","(GMT + 06:00) Almaty, Dhaka","(GMT + 07:00) Bangkok, Hanoi, Jakarta","(GMT + 08:00) Beijing, Chongqing, Hong Kong","(GMT + 09:00) Osaka, Sapporo, Tokyo","(GMT + 09:30) Adelaide","(GMT + 10:00) New South Wales","(GMT + 11:00) Magadan, Solomon Islands, New Caledonia","(GMT + 12:00) Auckland, Wellington"]
    all_timezones.each { |time|
      it "Update the time zone to the option '#{time.upcase}', press the 'Save All' button and verify the correct option is displayed" do
        @ui.set_dropdown_entry('profile_config_basic_timezone', time)
        sleep 0.5
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.css('#profile_config_basic_timezone .ko_dropdownlist_button .text').text).to eq(time)
        sleep 0.5
      end
    }
  end
end

shared_examples "reset the profile general settigs to default" do |profile_name, profile_description, country, time| #'United States' ||| '(GMT - 08:00) Pacific Time (US & Canada); Tijuana'
  describe "Reset the profile named '#{profile_name}' to the default general settings" do
    it "Reset the field values from the profile general settings to their default state" do
      @ui.set_input_val("#profile_config_basic_profilename", profile_name)
      @ui.set_textarea_val("#profile_config_basic_description", profile_description)
      @ui.set_dropdown_entry('profile_config_basic_country', country)
      @ui.set_dropdown_entry('profile_config_basic_timezone', time)
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end
    it "Expected Result: #{profile_name} ||| #{profile_description} ||| '#{country}' ||| '#{time}'" do
      pn = @ui.get(:text_field, {id: "profile_config_basic_profilename"})
      pn.wait_until_present
      expect(pn.value).to eq(profile_name)
      pd = @ui.get(:textarea, {id: "profile_config_basic_description"})
      pd.wait_until_present
      expect(pd.value).to eq(profile_description)
      expect(@ui.id('profile_config_basic_country').element(:css => ".ko_dropdownlist_button .text").text).to eq(country)
      expect(@ui.id('profile_config_basic_timezone').element(:css => ".ko_dropdownlist_button .text").text).to eq(time)
    end
  end
end

shared_examples "update profile advanced settings" do |profile_name|
  describe "Update profile advanced settings" do
    it "Press the 'Show Advanced' hyperlink to display the advanced settings options" do
      adv = @ui.click("#general_show_advanced")
    end
    it "Expected Result: the following options are displayed: Daylight Switch ||| Network Time Protocol container ||| Active Directory Configuration container ||| LEDs switch ||| Syslog container" do
      dls = @ui.id('daylightswitch')
      dls.wait_until_present
      ntp = @ui.id('general_ntp_toggle')
      ntp.wait_until_present
      led = @ui.id('ledoff')
      led.wait_until_present
      sys = @ui.id('enableSyslogSwitch')
      sys.wait_until_present
      ads = @ui.id('has_ADswitch')
      ads.wait_until_present

      expect(dls).to be_visible
      expect(ads).to be_visible
      expect(ntp).to be_visible
      expect(led).to be_visible
      expect(sys).to be_visible
    end
    it "Set the Daylight Savings switch to NO and press the 'Save All' button" do
      @ui.click("#daylightswitch .switch_label")

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end
    it "Expected Result: the value of the Daylight Switch is FALSE" do
      expect(@ui.get(:checkbox, {id: "daylightswitch_switch"}).set?).to eq(false)
    end

    it "Network Time Protocol: Set the Primary Server value to 'ntp.custom.com'" do
      @ui.set_input_val("#profile_config_basic_primaryserver", "ntp.custom.com")
    end
    it "Network Time Protocol: Set the Primary Authentication comboBox to 'SHA1'" do
      @ui.set_dropdown_entry('profile_config_basic_primaryauthentication', 'SHA1')
      sleep 1
    end
    it "Network Time Protocol: Set the Primary Authentication Key ID to '111' and Primary Authentication Key to '12345678'" do
      @ui.set_input_val("#profile_config_basic_primaryauthenticationkeyid", "111")
      @ui.set_input_val("#profile_config_basic_primaryauthenticationkey", "12345678")
    end
    it "Press the 'Save All' button" do
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end
    it "Expected Result: all the changes are properly saved and remembered " do
      primary = @ui.get(:text_field, {id: "profile_config_basic_primaryserver"})
      primary.wait_until_present
      expect(primary.type).to eq("text")
      expect(primary.attribute_value("maxlength")).to eq("256")
      expect(primary.value).to eq("ntp.custom.com")

      expect(@ui.id('profile_config_basic_primaryauthentication').element(:css => ".ko_dropdownlist_button .text").text).to eq('SHA1')

      keyid = @ui.get(:text_field, {id: "profile_config_basic_primaryauthenticationkeyid"})
      keyid.wait_until_present
      expect(keyid.type).to eq("text")
      expect(keyid.attribute_value("maxlength")).to eq("5")
      expect(keyid.value).to eq("111")

      key = @ui.get(:text_field, {id: "profile_config_basic_primaryauthenticationkey"})
      key.wait_until_present
      expect(key.type).to eq("password")
      expect(key.attribute_value("maxlength")).to eq("20")
      expect(key.value).to eq("--------")
    end

    it "Press the 'Add Secondary Server' button from the Network Time Protocol container" do
      @ui.click("#profile_config_general_add_secondary_ntp")
    end
    it "Network Time Protocol: Set the Secondary Server value to 'ntp.custom.com'" do
      @ui.set_input_val("#profile_config_basic_secondaryserver", "ntp.custom.com")
    end
    it "Network Time Protocol: Set the Secondary Authentication comboBox to 'MD5'" do
      @ui.set_dropdown_entry('profile_config_basic_secondaryauthentication', 'MD5')
      sleep 1
    end
    it "Network Time Protocol: Set the Secondary Authentication Key ID to '222' and Secondary Authentication Key to '22345678'" do
      @ui.set_input_val("#profile_config_basic_secondaryauthenticationkeyid", "222")
      @ui.set_input_val("#profile_config_basic_secondaryauthenticationkey", "22345678")
    end
    it "Press the 'Save All' button" do
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end
    it "Expected Result: all the changes are properly saved and remembered " do
      secondary = @ui.get(:text_field, {id: "profile_config_basic_secondaryserver"})
      secondary.wait_until_present
      expect(secondary.type).to eq("text")
      expect(secondary.attribute_value("maxlength")).to eq("256")
      expect(secondary.value).to eq("ntp.custom.com")

      expect(@ui.id('profile_config_basic_secondaryauthentication').element(:css => ".ko_dropdownlist_button .text").text).to eq('MD5')

      keyid = @ui.get(:text_field, {id: "profile_config_basic_secondaryauthenticationkeyid"})
      keyid.wait_until_present
      expect(keyid.type).to eq("text")
      expect(keyid.attribute_value("maxlength")).to eq("5")
      expect(keyid.value).to eq("222")

      key = @ui.get(:text_field, {id: "profile_config_basic_secondaryauthenticationkey"})
      key.wait_until_present
      expect(key.type).to eq("password")
      expect(key.attribute_value("maxlength")).to eq("20")
      expect(key.value).to eq("--------")
    end
    it "Set the Network Time Protocol switch to NO and press the 'Save All' button" do
      ntp = @ui.click("#has_NTPswitch .switch_label")

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
    end
    it "Expected Result: the NTPswitch control has the value set to FALSE " do
      expect(@ui.get(:checkbox, {id: "has_NTPswitch_switch"}).set?).to eq(false)
    end
    enable_and_populate_active_directory_control(["Admin", "Admini$trator1", "dc01.xirrus.alfa.com", "ALFA", "Earth"])
    it "Set the Syslog switch to YES" do
      @ui.click("#enableSyslogSwitch .switch_label")
    end
    logLevel_types = ["Debug", "Notice", "Warning", "Error", "Critical", "Alert", "Emergency", "Info"]
    logLevel_types.each do |logLevel|
      it "Set the Server Hostname/IP value to '1.2.3.4' , set the Server Port value to '555' and the Log Level comboBox to '#{logLevel.upcase}' then press the 'SAVE ALL' button and verify all the changes are properly saved and remembered" do
        @ui.set_input_val("#profile_config_general_syslogIp", "1.2.3.4")
        @ui.set_input_val("#profile_config_general_syslogPort", "555")
        @ui.set_dropdown_entry('profile_config_general_syslogLevel', logLevel)
        sleep 0.5
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1.5
        expect(@ui.get(:checkbox, {id: "enableSyslogSwitch_switch"}).set?).to eq(true)
        sysip = @ui.get(:text_field, {id: "profile_config_general_syslogIp"})
        sysip.wait_until_present
        expect(sysip.value).to eq("1.2.3.4")
        sysport = @ui.get(:text_field, {id: "profile_config_general_syslogPort"})
        sysport.wait_until_present
        expect(sysport.value).to eq("555")
        expect(@ui.id('profile_config_general_syslogLevel').element(:css => ".ko_dropdownlist_button .text").text).to eq(logLevel)
      end
    end
    it "Set the LEDs switch to YES and press the 'Save All' button" do
      @ui.click("#ledoff .switch_label")
      sleep 0.5
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
    end
    it "Expected Result: the LEDoff control has the value set to TRUE " do
      expect(@ui.get(:checkbox, {id: "ledoff_switch"}).set?).to eq(true)
    end
    it "Reset all the profile advanced settings field values and press the 'Save All' button" do
      @ui.click("#ledoff .switch_label")
      @ui.click("#enableSyslogSwitch .switch_label")
      @ui.click("#has_NTPswitch .switch_label")
      @ui.click("#daylightswitch .switch_label")
      sleep 0.5
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
    end
    it "Expected Result: all the changes are properly saved and remembered" do
      expect(@ui.get(:checkbox, {id: "daylightswitch_switch"}).set?).to eq(true)
      expect(@ui.get(:checkbox, {id: "has_NTPswitch_switch"}).set?).to eq(true)
      expect(@ui.get(:checkbox, {id: "enableSyslogSwitch_switch"}).set?).to eq(false)
      expect(@ui.get(:checkbox, {id: "ledoff_switch"}).set?).to eq(false)
    end
  end
end

shared_examples "update active directory controls" do |active_domain_settings|
  describe "Update the 'Active Directory' control with the values: '#{active_domain_settings}'" do
    enable_and_populate_active_directory_control(active_domain_settings)
  end
end

def enable_and_populate_active_directory_control(active_domain_settings)
    it "If needed go to the General tab" do
      if !@ui.css('#profile_config_tab_general').attribute_value("class").include?("selected")
        @ui.click('#profile_config_tab_general')
        sleep 3
      end
    end
    it "If needed press the 'Show Advanced' hyperlink to display the advanced settings options" do
      if @ui.css('#general_show_advanced').text == "Show Advanced"
        @ui.click("#general_show_advanced")
        sleep 3
      end
    end
    it "Set the Active Directory switch to TRUE" do
      @ui.click("#has_ADswitch .switch_label")
      sleep 5
    end
    it "Expected Result: the Domain Admin/ Password/ Controller/ Workgroup and Realm input boxes are dispalyed" do
      controls = ['profile_config_basic_domain_administrator', 'profile_config_basic_domain.password', 'profile_config_basic_domain.controller', 'profile_config_basic_workgroup.domain', 'profile_config_basic_realm']
      controls.each do |control_css|
        @ui.id(control_css).wait_until_present
      end
    end
    it "Set the following values in the Active Directory input boxes: #{active_domain_settings[0]} / #{active_domain_settings[1]} / d#{active_domain_settings[2]} / #{active_domain_settings[3]} / #{active_domain_settings[4]}" do
      sleep 1
      @ui.set_input_val('#profile_config_basic_domain_administrator', active_domain_settings[0])
      sleep 2
      ad_pass_input = @ui.get(:text_field, {id: "profile_config_basic_domain.password"})
      ad_pass_input.click
      sleep 2
      @browser.send_keys active_domain_settings[1]
      sleep 2
      ad_contr_input = @ui.get(:text_field, {id: "profile_config_basic_domain.controller"})
      ad_contr_input.click
      sleep 2
      @browser.send_keys active_domain_settings[2]
      sleep 2
      ad_wkg_input = @ui.get(:text_field, {id: "profile_config_basic_workgroup.domain"})
      ad_wkg_input.click
      sleep 2
      @browser.send_keys active_domain_settings[3]
      sleep 2
      @ui.set_input_val('#profile_config_basic_realm', active_domain_settings[4])
      sleep 2
    end
    it "Press the 'Save All' button" do
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
    end
    it "If needed press the 'Show Advanced' hyperlink to display the advanced settings options" do
      if @ui.css('#general_show_advanced').text == "Show Advanced"
        @ui.click("#general_show_advanced")
        sleep 3
      end
    end
    it "Expected Result: all the changes are properly saved and remembered " do
      controls = Hash[0 => ['profile_config_basic_domain_administrator', "20"], 1 => ['profile_config_basic_domain.password', "20"], 2 => ['profile_config_basic_domain.controller', "256"], 3 => ['profile_config_basic_workgroup.domain', "256"], 4 => ['profile_config_basic_realm', "256"]]
      controls.each do |key, value|
        @ui.id(value[0]).wait_until_present
        if key == 1
          expect(@ui.get(:text_field, {id: value[0]}).value).to eq("--------")
        else
          expect(@ui.get(:text_field, {id: value[0]}).value).to eq(active_domain_settings[key])
        end
        expect(@ui.get(:text_field, {id: value[0]}).attribute_value("maxlength")).to eq(value[1])
      end
    end
end

