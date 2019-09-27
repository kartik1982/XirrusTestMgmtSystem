require_relative "portal_lib.rb"
require_relative "lookfeel_lib.rb"

def save_portal_ensure_no_error_is_displayed(portal_type)
  @ui.css('#guestportal_config_save_btn').wait_until_present
  @ui.click('#guestportal_config_save_btn')
  15.times do
    sleep 0.1
    expect(@ui.css('.temperror')).not_to be_present
    if @ui.css('.error').present?
      if @ui.css('.error').parent.attribute_value("class") != "whitelist"
        expect(@ui.css('.error')).not_to be_present
      end
    end
  end
  ensure_voucher_portal_is_properly_handled(portal_type)
  for css_path in ['#guestportal_config_tab_general .dirtyIcon', '#guestportal_config_tab_lookfeel .dirtyIcon', '#guestportal_config_tab_ssids .dirtyIcon']
    expect(@ui.css(css_path)).not_to be_present
  end
  for css_path in ['#guestportal_config_tab_general .invalidIcon', '#guestportal_config_tab_lookfeel .invalidIcon', '#guestportal_config_tab_ssids .invalidIcon']
    expect(@ui.css(css_path)).not_to be_present
  end
end

shared_examples "go to portal" do |portal_name|
  describe "Go to the portal named: '#{portal_name}'" do
    it "Go to the Portals landing page, then click on the tile with the needed portal" do
      not_on_proper_portal = true
      if @browser.url.include? "/#guestportals/"
        if @ui.css('#profile_name').present?
          if @ui.css('#profile_name').text == portal_name
            not_on_proper_portal = false
          end
        end
      end
      if not_on_proper_portal == true
        navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
      end
      sleep 3
      expect(@browser.url).to include("/#guestportals/")
      expect(@ui.css('#profile_name').text).to eq(portal_name)
    end
  end
end

shared_examples "update portal name" do |portal_name, portal_type|
  describe "Update the name value (with ' + Update' string) of the portal type '#{portal_type.upcase}'" do
    it "Update the portal name to '#{portal_name} + Update', save & verify then return it to default" do
      @ui.set_input_val("#guestportal_config_basic_guestportalname", portal_name + " update")
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      pn = @ui.get(:text_field, {id: "guestportal_config_basic_guestportalname"})
      pn.wait_until_present
      expect(pn.attribute_value("maxlength")).to eq("255")
      expect(pn.value).to eq(portal_name + " update")
      ensure_voucher_portal_is_properly_handled(portal_type)
      #reset name
      @ui.set_input_val("#guestportal_config_basic_guestportalname", portal_name)
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
    end
  end
end

shared_examples "update portal description" do |portal_name, portal_description, portal_type|
  describe "Update the description value (with ' + Update' string) of the portal type '#{portal_type.upcase}'" do
  it "Update the portal description value to '#{portal_description} + Update' and save" do
      @ui.set_textarea_val('#guestportal_config_basic_description', portal_description + " update")
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      pd = @ui.id('guestportal_config_basic_description')
      pd.wait_until_present
      expect(pd.attribute_value("maxlength")).to eq("255")
      expect(@ui.get(:textarea, {id: 'guestportal_config_basic_description'}).value).to eq(portal_description + " update")
    end
  end
end

shared_examples "update portal language" do |portal_name, portal_type|
  describe "Update the language of the portal to all available ones - #{portal_type.upcase}" do
    it "Update, save and verify that the language can be set on each of the following: 简体中文, 繁體中文, Nederlands, English, Français, Deutsch, Ελληνικά, Bahasa Indonesia, Italiano, 日本語, Bahasa Malaysia, Norsk, Português (Brasil), Pусский, Español, Español (América Latina), Svenska, Filipino, Українська" do
      if ["mega", "onetouch"].include? portal_type
        languages = ["English", "Français", "Deutsch", "Español"]
      else
        languages = ["简体中文", "繁體中文", "Nederlands", "English", "Français", "Deutsch", "Ελληνικά", "Bahasa Indonesia", "Italiano", "日本語", "Bahasa Malaysia", "Norsk", "Português (Brasil)", "Pусский", "Español", "Español (América Latina)", "Svenska", "Filipino", "Українська"]
      end
      languages.each do |language|
        @ui.set_dropdown_entry('guestportal_config_basic_language', language)
        sleep 0.5
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        sleep 1
        @ui.click('#profile_name')
        expect(@ui.css('#guestportal_config_basic_language .ko_dropdownlist_button .text').text).to eq(language)
      end
    end
  end
end

shared_examples "update portal session expiration to custom" do |portal_name, portal_type, timeframe|
  describe "Update the session exipration to the option #{timeframe} - #{portal_type.upcase}" do
    if timeframe.class == String
      it "Update, save and verify that the portal session expiration can be saved as: #{timeframe}" do
        @ui.set_dropdown_entry('guestportal_config_general_expiration', timeframe)
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        expect(@ui.css('#guestportal_config_general_expiration .ko_dropdownlist_button .text').text).to eq(timeframe)
        sleep 1
        @ui.click('#profile_name')
      end
    elsif timeframe.class == Hash
      it "Update, save and verify that the portal session expiration custom time can be saved as: #{timeframe}" do
        @ui.set_dropdown_entry('guestportal_config_general_expiration', "Custom")
        sleep 1
        d = @ui.get(:text_field, {id: "guestportal_ExpirationDays"})
        d.wait_until_present
        d.clear
        d.value = timeframe["Days"]
        sleep 0.5
        @ui.set_input_val('#guestportal_ExpirationDHours',timeframe["Hours"])
        sleep 0.5
        @ui.set_input_val('#guestportal_ExpirationMinutes',timeframe["Minutes"])
        sleep 0.5
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        d = @ui.get(:text_field, {id: "guestportal_ExpirationDays"})
        d.wait_until_present
        expect(d.value).to eq(timeframe["Days"])
        h = @ui.get(:text_field, {id: "guestportal_ExpirationDHours"})
        h.wait_until_present
        expect(h.value).to eq(timeframe["Hours"])
        m = @ui.get(:text_field, {id: "guestportal_ExpirationMinutes"})
        m.wait_until_present
        expect(m.value).to eq(timeframe["Minutes"])
      end
    end
  end
end

shared_examples "update portal session expiration" do |portal_name, portal_type|
  describe "Update the session exipration to all available options - #{portal_type.upcase}" do
    it "Update, save and verify that the portal session expiration can be saved as: '15 minutes','1 hour','1 day','1 month','End of Day (midnight)','End of week (saturday)','Forever'" do
      for period in ['15 minutes','1 hour','1 day','1 month','End of Day (midnight)','End of week (saturday)','Forever'] do
        if portal_type== "onetouch" || portal_type== "voucher"
          @ui.set_dropdown_entry_by_path('#guestportal_config_general_expiration span:nth-child(2) #general_expiration_days', period)
        else
          @ui.set_dropdown_entry('guestportal_config_general_expiration', period)
        end        
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        if portal_type== "onetouch" || portal_type== "voucher"
          if period=="Forever"
            expect(@ui.css("#guestportal_config_general_expiration #use_no_limit_expiration0").attribute_value("checked")).to eq("true")
          else
            expect(@ui.css('#guestportal_config_general_expiration span:nth-child(2) #general_expiration_days .ko_dropdownlist_button .text').text).to eq(period)
          end          
        else
          expect(@ui.css('#guestportal_config_general_expiration .ko_dropdownlist_button .text').text).to eq(period)
        end        
      end 
      sleep 1
      @ui.click('#profile_name')
    end
    it "Update, save and verify that the portal session expiration custom time can be saved as: '0,1,999' days '0,1,23' hours and '15,30,45' minutes" do
      if portal_type== "onetouch" || portal_type== "voucher"
        if @ui.css("#guestportal_config_general_expiration #use_no_limit_expiration0").attribute_value("checked") == "true"
          @ui.css("#guestportal_config_general_expiration #use_no_limit_expiration1_label").click
        end
        @ui.set_dropdown_entry_by_path('#guestportal_config_general_expiration span:nth-child(2) #general_expiration_days', "Custom")
        path_days = "#guestportal_config_general_expiration span:nth-child(2) #guestportal_ExpirationDays"
        path_hrs = "#guestportal_config_general_expiration span:nth-child(2) #guestportal_ExpirationDHours"
        path_mins = "#guestportal_config_general_expiration span:nth-child(2) #guestportal_ExpirationMinutes"
      else
        @ui.set_dropdown_entry('guestportal_config_general_expiration', "Custom")
        path_days = "#guestportal_ExpirationDays"
        path_hrs = "#guestportal_ExpirationDHours"
        path_mins = "#guestportal_ExpirationMinutes"
      end      
      sleep 1
      for days in ['0','1','999'] do
        for hours in ['0','1','23'] do
          for minutes in ['15', '30', '45'] do
            sleep 0.5
            d = @ui.get(:text_field, {css: path_days})
            d.wait_until_present
            d.clear
            @ui.set_input_val(path_days, days)
            sleep 0.5
            @ui.set_input_val(path_hrs,hours)
            sleep 0.5
            @ui.set_input_val(path_mins,minutes)
            sleep 0.5
            save_portal_ensure_no_error_is_displayed(portal_type)
            sleep 1
            ensure_voucher_portal_is_properly_handled(portal_type)
            d = @ui.get(:text_field, {css: path_days})
            d.wait_until_present
            expect(d.value).to eq(days)
            h = @ui.get(:text_field, {css: path_hrs})
            h.wait_until_present
            expect(h.value).to eq(hours)
            m = @ui.get(:text_field, {css: path_mins})
            m.wait_until_present
            expect(m.value).to eq(minutes)
          end
        end
      end
    end
  end
end

shared_examples "update portal landing page" do |portal_name, portal_type, landing_page|
  describe "Update the landing page to #{landing_page} - #{portal_type.upcase}" do
    it "Update the portal landing page and save" do
      @ui.set_input_val("#landingpage", landing_page)
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      lp = @ui.get(:text_field, {id: "landingpage"})
      lp.wait_until_present
      expect(lp.attribute_value("maxlength")).to eq("255")
      expect(lp.value).to eq(landing_page)
    end
  end
end

shared_examples "update portal session timeout" do |portal_name, portal_type|
  describe "Update the session timeout - #{portal_type.upcase}" do
    it "Update, save and verify that the portal session timeout can be saved as '5','23','60' for each of the following options: 'Minutes','Hours', 'Days' " do
      if @ui.get(:checkbox, {id: "has_timeoutSwitch_switch"}).set? == false
        @ui.css('#has_timeoutSwitch').hover
        sleep 1
        @ui.click('#has_timeoutSwitch .switch_label')
      end
      if portal_type == 'onboarding'
        period_type_entries = ['Hours', 'Days']
      else
        period_type_entries = ['Minutes','Hours', 'Days']
      end
      for period_type in period_type_entries do
        for period_time in ['5','23','60'] do
          if period_time == '60' and period_type == 'Hours'
            period_time = '24'
          end
          sleep 1
          @ui.set_input_val("#guestportal_config_basic_timeout", period_time)
          @ui.set_dropdown_entry('guestportal_config_general_timeouttype', period_type)
          sleep 1
          save_portal_ensure_no_error_is_displayed(portal_type)
          sleep 1
          ensure_voucher_portal_is_properly_handled(portal_type)
          expect(@ui.css('#guestportal_config_general_timeouttype .ko_dropdownlist_button .text').text).to eq(period_type)
          t = @ui.get(:text_field, {id: "guestportal_config_basic_timeout"})
          t.wait_until_present
          expect(t.value).to eq(period_time)
        end
      end
      sleep 1
      @ui.css('#has_timeoutSwitch').hover
      sleep 1
      @ui.click('#has_timeoutSwitch .switch_label')
    end
  end
end

shared_examples "update portal lockout time" do |portal_name, portal_type|
  describe "Update the lockout time - #{portal_type.upcase}" do
    it "Update the portal lockout time and save" do
      @ui.click('#has_sessionExpiryDurationSwitch')
      for period in ["1 hour", "3 hours", "6 hours", "12 hours", "1 day", "2 days", "5 days", "7 days", "1 month", "End of Day (midnight)", "End of week (saturday)", "Forever"]
        sleep 1
        @ui.set_dropdown_entry('general_lockout_days', period)
        sleep 1
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 2
        expect(@ui.css('#general_lockout_days .ko_dropdownlist_button .text').text).to eq(period)
      end
    end
  end
end

shared_examples "update portal sponsor" do |portal_name, portal_type, sponsor, sponsor_type|
  describe "Update the portal sponsor with '#{sponsor.length}' entries for - '#{portal_name}' (#{portal_type.upcase})" do
    it "Update the portal sponsor and save" do
      if @ui.get(:checkbox , {id: 'has_sponsor_switch'}).set? == false
        @ui.click('#has_sponsor .switch_label')
      end
      sleep 1
      ul = @ui.css('#guestportal_config_general_sponsors ul')
      ul.wait_until_present
      original_sponsor_entries = ul.lis.length
      log "OLD SPONSOR ENTRIES: #{original_sponsor_entries}"
      sleep 0.5
      if sponsor.class == Array
        sponsor.each do |string|
          @ui.set_input_val("#new_sponsor_item", string)
          sleep 0.5
          @ui.click('#add_sponsor_item')
          sleep 0.5
          if @ui.css('#new_sponsor_item + .xirrus-error').present?
            log "!!!!!!!!!!!!!!!!!!!!! FAILED THE ENTRY : #{string} !!!!!!!!!!!!!!!!!!!!!"
          end
        end
      else
        @ui.set_input_val("#new_sponsor_item", sponsor)
        sleep 0.5
        @ui.click('#add_sponsor_item')
      end
      sleep 0.5
      dropdown = @ui.css('#guestportal_config_basic_autoAcceptSponsor').a(css: ".ko_dropdownlist_button")
      @position = dropdown.wd.location
      @browser.execute_script("body.scrollTop=#{@position[1]}")
      sleep 1
      dropdown.click
      sleep 2
      @ui.get(:lis , {css: ".ko_dropdownlist_list.active li"}).each do |li|
        if li.attribute_value("data-value") == sponsor_type
          li.click
        end
      end
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ul = @ui.css('#guestportal_config_general_sponsors ul')
      ul.wait_until_present
      new_sponsor_entries = ul.lis.length
      log "NEW SPONSOR ENTRIES: #{new_sponsor_entries}"
      if sponsor.class == Array
        expect(new_sponsor_entries).to eq(original_sponsor_entries + sponsor.length)
      else
        expect(new_sponsor_entries).to eq(original_sponsor_entries + 1)
      end
      @bool_found = false
      while new_sponsor_entries != 0
        if sponsor.class == Array
          sponsor.each do |string|
            if @ui.css("#guestportal_config_general_sponsors ul li:nth-child(#{new_sponsor_entries}) .whitelist_record").text == string
              @bool_found = true
            end
          end
        else
          if @ui.css("#guestportal_config_general_sponsors ul li:nth-child(#{new_sponsor_entries}) .whitelist_record").text == sponsor
            @bool_found = true
          end
        end
        new_sponsor_entries-=1
      end
      expect(@bool_found).to eq(true)
      expect(@ui.css('#guestportal_config_basic_autoAcceptSponsor .ko_dropdownlist_button .text').text).to eq(sponsor_type)
    end
  end
end

shared_examples "update authentication to connect" do |portal_name, portal_type|
  describe "Update the Authentication to Connect - - #{portal_type.upcase}" do
    it "Update the 'Require Authentication to Connect' switch" do
      @ui.click('#require_self_validation .switch_label')
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      expect(@ui.get(:checkbox , {id: "require_self_validation_switch"}).set?).to eq(true)
    end
  end
end

shared_examples "show advanced" do
  describe "Click the 'Show Advanced' link" do
    it "Show advanced options" do
      if @ui.css('#general_show_advanced').text == "Show Advanced"
        @ui.click('#general_show_advanced')
        sleep 2
      end
      expect(@ui.css('#general_show_advanced').text).to eq("Hide Advanced")
    end
  end
end

shared_examples "update portal whitelist" do |portal_name, portal_type, whitelist_element|
  describe "Update the portal whitelist with the entry '#{whitelist_element}' - #{portal_type.upcase}" do
    it "Update the whitelist and save" do
     if @ui.get(:checkbox , {id: "whitelist_switch_switch"}).set? == false
        @ui.click('#whitelist_switch .switch_label')
        sleep 1
      end
      ul = @ui.css('#guestportal_config_general_whitelist ul')
      ul.wait_until_present
      original_whitelist_entries = ul.lis.length
      sleep 0.5
      @ui.set_input_val("#new_whitelist_item", whitelist_element)
      @ui.click('#add_whitelist_item')
      sleep 0.5
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      ul = @ui.css('#guestportal_config_general_whitelist ul')
      ul.wait_until_present
      new_whitelist_entries = ul.lis.length
      expect(new_whitelist_entries).to eq(original_whitelist_entries + 1)
      @bool_found = false
      while new_whitelist_entries != 0
        log @ui.css("#guestportal_config_general_whitelist ul li:nth-child(#{new_whitelist_entries}) .whitelist_record").text
        if @ui.css("#guestportal_config_general_whitelist ul li:nth-child(#{new_whitelist_entries}) .whitelist_record").text == whitelist_element
          @bool_found = true
        end
        new_whitelist_entries-=1
      end
      expect(@bool_found).to eq(true)
    end
  end
end

def return_whitelist_elements
  ul = @ui.css('#guestportal_config_general_whitelist ul')
  ul.wait_until_present
  original_length = ul.lis.length
  length = original_length
  if length > 0
    entries_hash = Hash[]
    while length > 0
      @ui.css("#guestportal_config_general_whitelist ul li:nth-child(#{length}) .whitelist_record").hover
      entry_name = @ui.css("#guestportal_config_general_whitelist ul li:nth-child(#{length}) .whitelist_record").text
      entries_hash[entry_name] = "#guestportal_config_general_whitelist ul li:nth-child(#{length}) .whitelist_record"
      length-=1
    end
    return Hash["Length" => original_length, "Entries Hash" => entries_hash]
  else
    return original_length
  end
end

shared_examples "comprehensive portal whitelist tests" do |portal_name, portal_type, enable_whitelist, whitelist_action, whitelist_element|
  describe "Update the portal whitelist with the entry '#{whitelist_element}' - #{portal_type.upcase}" do
    it "Verify the Whitelist switch control" do
      expect(@ui.css('#whitelist_switch').parent.parent.element(:css => ".field_heading").text).to eq("Whitelist")
      expect(@ui.css('#whitelist_switch').parent.element(:css => ".togglebox_heading").text).to eq("Would you like to add a list of web sites that can bypass the portal process?")
      expect(@ui.css('#whitelist_switch')).to be_present
    end
    if enable_whitelist == true
      it "Enable the Whitelist control" do
        if @ui.get(:checkbox , {id: "whitelist_switch_switch"}).set? == false
          @ui.click('#whitelist_switch .switch_label')
          sleep 1
        end
      end
    end
    if whitelist_action == "Add"
      it "Add the '#{whitelist_element}' to the Whitelist control and save the portal" do
        original_whitelist_entries = return_whitelist_elements
        sleep 0.5
        whitelist_element.each do |entry|
          @ui.set_input_val("#new_whitelist_item", entry)
          sleep 1
          @ui.click('#add_whitelist_item')
          sleep 1
        end
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        8.times do
          expect(@ui.css('.temperror')).not_to be_present
          sleep 0.5
        end
        expect(@ui.css('#guestportal_config_general_whitelist ul')).to be_present
        new_whitelist_entries = return_whitelist_elements
        puts new_whitelist_entries["Length"]
        if original_whitelist_entries.class == Hash
            expect(new_whitelist_entries["Length"]).to eq(original_whitelist_entries["Length"] + whitelist_element.length)
        else
            expect(new_whitelist_entries["Length"]).to eq(whitelist_element.length)
        end
      end
      it "Verify the entries in the Whitelist" do
        new_whitelist_entries = return_whitelist_elements
        while new_whitelist_entries["Length"] != 0
          expect(whitelist_element).to include(@ui.css("#guestportal_config_general_whitelist ul li:nth-child(#{new_whitelist_entries["Length"]}) .whitelist_record").text)
          new_whitelist_entries["Length"]-=1
        end
      end
    elsif whitelist_action == "Delete All"
      it "Delete all the elements in the Whitelist control and save the portal" do
        original_whitelist_entries = return_whitelist_elements
        sleep 0.5
        whitelist_entries_length = @ui.css("#guestportal_config_general_whitelist ul").lis.length
        puts whitelist_entries_length
        while whitelist_entries_length > 0
          @ui.click("#guestportal_config_general_whitelist ul li:nth-child(#{whitelist_entries_length}) .whitelist_record")
          sleep 0.6
          @ui.click("#guestportal_config_general_whitelist ul li:nth-child(#{whitelist_entries_length}) .deleteIcon")
          @ui.css('.dialogOverlay.confirm').wait_until_present
          @ui.click('#_jq_dlg_btn_1')
          sleep 2
          puts whitelist_entries_length
          whitelist_entries_length-=1
        end
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        8.times do
          expect(@ui.css('.temperror')).not_to be_present
          sleep 0.5
        end
        @browser.refresh
        @ui.css('#profile_name').wait_until_present
        if @ui.css('#general_show_advanced').text == "Show Advanced"
          @ui.click('#general_show_advanced')
          sleep 2
        end
        expect(@ui.css('#general_show_advanced').text).to eq("Hide Advanced")
        sleep 2
        if @ui.get(:checkbox , {id: "whitelist_switch_switch"}).set? == false
          @ui.click('#whitelist_switch .switch_label')
          sleep 1
        end
        @ui.css('#whitelist_switch .switch_label').wait_until_present
        expect(@ui.css('#guestportal_config_general_whitelist ul').lis.length).to eq(0)
        @browser.refresh
      end
    elsif whitelist_action == "Delete certain"
      it "Delete certain element(s) in the Whitelist control and save the portal" do
        original_whitelist_entries = return_whitelist_elements
        sleep 0.5
        whitelist_entries_length = @ui.css("#guestportal_config_general_whitelist ul").lis.length
        puts "length of the entries in the control - #{whitelist_entries_length}"
        iteration = 0
        puts "elements hash - #{whitelist_element}"
        whitelist_element.each do |element|
          new_whitelist_entries_length = whitelist_entries_length - iteration
          puts "new length = #{new_whitelist_entries_length}"
          while new_whitelist_entries_length > 0
            puts "list element " + @ui.css("#guestportal_config_general_whitelist ul li:nth-child(#{new_whitelist_entries_length}) .whitelist_record").text
            puts "searched for element #{element}"
            if @ui.css("#guestportal_config_general_whitelist ul li:nth-child(#{new_whitelist_entries_length}) .whitelist_record").text == element
              @ui.click("#guestportal_config_general_whitelist ul li:nth-child(#{new_whitelist_entries_length}) .whitelist_record")
              sleep 1
              @ui.click("#guestportal_config_general_whitelist ul li:nth-child(#{new_whitelist_entries_length}) .deleteIcon")
              @ui.css('.dialogOverlay.confirm').wait_until_present
              @ui.click('#_jq_dlg_btn_1')
              sleep 2
              new_whitelist_entries_length-=1
              puts "new length -= #{new_whitelist_entries_length}"
              iteration+=1
              break
            end
            new_whitelist_entries_length-=1
            puts "new length -= #{new_whitelist_entries_length}"
            iteration+=1
          end
        end
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        8.times do
          expect(@ui.css('.temperror')).not_to be_present
          sleep 0.5
        end
        @browser.refresh
        @ui.css('#profile_name').wait_until_present
        if @ui.css('#general_show_advanced').text == "Show Advanced"
          @ui.click('#general_show_advanced')
          sleep 2
        end
        expect(@ui.css('#general_show_advanced').text).to eq("Hide Advanced")
        sleep 2
        if @ui.get(:checkbox , {id: "whitelist_switch_switch"}).set? == false
          @ui.click('#whitelist_switch .switch_label')
          sleep 1
        end
        if original_whitelist_entries["Length"] == whitelist_element.length
          @ui.css('#whitelist_switch .switch_label').wait_until_present
          expect(@ui.css('#guestportal_config_general_whitelist ul')).not_to be_present
          expect(@ui.get(:checkbox , {id: "whitelist_switch_switch"}).set?).to eq(false)
        else
          @ui.css('#whitelist_switch .switch_label').wait_until_present
          expect(@ui.css('#guestportal_config_general_whitelist ul')).to be_present
          expect(@ui.get(:checkbox , {id: "whitelist_switch_switch"}).set?).to eq(true)
          whitelist_entries_length = @ui.css("#guestportal_config_general_whitelist ul").lis.length
          expect(whitelist_entries_length).to eq(original_whitelist_entries["Length"]-whitelist_element.length)
        end
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        8.times do
          expect(@ui.css('.temperror')).not_to be_present
          sleep 0.5
        end
      end
    end
  end
end

shared_examples "update quite tolerance" do |portal_name, portal_type|
  describe "Update the portal quiet tolerance - #{portal_type.upcase}" do
    it "Update the quiet tolerance and save" do
      for value in ["2", "6", "44", "1440"] do
        @ui.set_input_val("#guestportal-quietclienttimeout-spinner", value)
        sleep 1
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        t = @ui.get(:text_field, {id: "guestportal-quietclienttimeout-spinner"})
        t.wait_until_present
        expect(t.value).to eq(value)
      end
    end
  end
end

shared_examples "update optional user authentication" do |portal_name, portal_type|
  describe "Update the portal optional user authentication - #{portal_type.upcase}" do
    it "Update the optional user authentication, save the portal and verify" do
      @ui.click('#userauthentication_switch .switch_label')
      @ui.set_input_val("#host", "1.2.3.4")
      @ui.set_input_val("#share", "12345678")
      @ui.set_input_val("#share_confirm", "12345678")
      sleep 0.5
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      h = @ui.get(:text_field, {id: "host"})
      h.wait_until_present
      expect(h.value).to eq("1.2.3.4")
      sh = @ui.get(:text_field, {id: "share"})
      sh.wait_until_present
      expect(sh.value).to eq("--------")
    end
    it "Update the optional secondary radius server user authentication, save the portal and verify" do
      @ui.click('#ssid_modal_addsecnd_sec_btn')
      sleep 0.5
      @ui.set_dropdown_entry('guestportal_authtype', "MSCHAP")
      sleep 0.5
      @ui.set_input_val("#secondary_host", "www.myDomain.co.uk")
      @ui.set_input_val("#secondary_port", "2222")
      @ui.set_input_val("#secondary_share", "12345678")
      @ui.set_input_val("#secondary_share_confirm", "12345678")
      sleep 0.5
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      expect(@ui.css('#guestportal_authtype .ko_dropdownlist_button span:first-child').text).to eq('MSCHAP')
      h = @ui.get(:text_field, {id: "host"})
      h.wait_until_present
      expect(h.value).to eq("1.2.3.4")
      sh = @ui.get(:text_field, {id: "share"})
      sh.wait_until_present
      expect(sh.value).to eq("--------")
      h2 = @ui.get(:text_field, {id: "secondary_host"})
      h2.wait_until_present
      expect(h2.value).to eq("www.myDomain.co.uk")
      p = @ui.get(:text_field, {id: "secondary_port"})
      p.wait_until_present
      expect(p.value).to eq("2222")
      sh2 = @ui.get(:text_field, {id: "secondary_share"})
      sh2.wait_until_present
      expect(sh2.value).to eq("--------")
    end
  end
end

shared_examples "update selfonboarding optional user authentication azure google" do |portal_name, portal_type, authentication_type, user_name, user_password|
  describe "Update the Microsoft Azure Authorization for an Azure Portal" do
    it "Go to the home page and back to the portal" do
      @ui.click('#header_logo')
      sleep 5
      @browser.refresh
      sleep 10
      @ui.goto_guestportal(portal_name)
    end
    it "Click the appropriate authentication type '#{authentication_type}'" do
      #@ui.click('#userauthentication_switch .switch_label')
      sleep 2
      expect(@ui.css('.segmented_ctn')).to be_present
      if authentication_type == "Google"
        @ui.click('.segmented_ctn button:nth-of-type(2)')
        sleep 1
        expect(@ui.css('.segmented_ctn button:nth-of-type(2)').attribute_value("class")).to eq("control selected")
      elsif authentication_type == "Microsoft Azure"
        @ui.click('.segmented_ctn button:nth-of-type(3)')
        sleep 1
        expect(@ui.css('.segmented_ctn button:nth-of-type(3)').attribute_value("class")).to eq("control selected")
      else
        # RADIUS
      end
    end
    if authentication_type == "Microsoft Azure"
      it "Enable the Microsoft Azure Authorization for the portal named '#{portal_name}'" do
          2.times do
            expect(@ui.css('xc-guestportals-azure .orange.push-down')).to be_present
            @ui.click('xc-guestportals-azure .orange.push-down')
            sleep 2
            break if !@browser.window(:url => /login.microsoftonline.com/).exists?
            @browser.window(:url => /login.microsoftonline.com/) do
                if @browser.input(:css => '.placeholderContainer .form-control').exists?
                  @browser.input(:css => '.placeholderContainer .form-control').send_keys user_name
                  sleep 1
                end
                if @browser.div(:css => '.form-group .tile-container .row .table').exists?
                  @browser.div(:css => '.form-group .tile-container .row .table').click
                  sleep 2
                end
                if @browser.button(:text => 'Next').exists?
                  @browser.button(:text => 'Next').click
                else
                  @browser.button(:text => 'Accept').click
                end
                sleep 1
                break if !@browser.window(:url => /login.microsoftonline.com/).exists?
                if @browser.input(:css => '.placeholderContainer .form-control').exists?
                  @browser.input(:css => '.placeholderContainer .form-control').send_keys user_password
                  sleep 2
                end
                if @browser.button(:text => 'Sign in').exists?
                  @browser.button(:text => 'Sign in').click
                  sleep 1
                end
                if @browser.element(:id => 'cred_accept_button').exists?
                  sleep 1
                  @browser.element(:id => 'cred_accept_button').click
                  sleep 1
                end
                sleep 3
                if @browser.input(:css => '.col-xs-12.primary .btn').exists?
                  sleep 1
                  @browser.input(:css => '.col-xs-12.primary .btn').click
                  sleep 1
                end
                sleep 3
                if @browser.window(:url => /login.microsoftonline.com/).exists?
                   if @browser.button(:text => 'Accept').exists?
                      @browser.button(:text => 'Accept').click
                  end
                   if @browser.button(:text => 'Yes').exists?
                    @browser.button(:text => 'Yes').click
                  end
                end
              end
            sleep 10
          end
        @ui.css('xc-guestportals-azure .azure-domain-input').wait_until_present
        expect(@ui.css('xc-guestportals-azure .azure-domain-input')).to be_visible
        expect(@ui.css('xc-guestportals-azure .azure-auth-container span').text).to eq("Successfully integrated with Azure by:\n" + user_name)
        expect(@ui.css('xc-guestportals-azure .azure-auth-container span:nth-child(2)').attribute_value("class")).to include("UP")
        expect(@ui.css('xc-guestportals-azure .azure-domain-input').parent.span.text).to eq("Users visiting your network will connect from your selected groups in the following domain:")
        expect(@ui.css('xc-guestportals-azure .azure-domain-input input')).to exist
        expect(@ui.css('xc-guestportals-azure .azure-domain-input .xirrus-error')).to exist
        expect(@ui.get(:input , {css: 'xc-guestportals-azure .azure-domain-input input'}).value).to eq("alexxirrusoutlook.onmicrosoft.com")
        expect(@ui.css('xc-guestportals-azure .togglebox_heading').text).to eq("Would you like to restrict access to specific groups?")
        expect(@ui.css('xc-guestportals-azure .switch')).to exist
        sleep 1
      end
    elsif authentication_type == "Google"
      it "Enable the Directory Synchronization for the portal named '#{portal_name}'" do
        2.times do
          @ui.click('xc-guestportals-google .orange.push-down')
          sleep 3

          if @browser.window(:url => /accounts.google.com/).exists?
            @browser.window(:url => /accounts.google.com/) do
              if @browser.element(:id => 'submit_approve_access').exists?
                sleep 1
                @browser.element(:id => 'submit_approve_access').click
                sleep 1
              elsif @browser.element(:id => 'headingText').text == "Choose an account"
                expect(@browser.element(:css => 'ul')).to exist
                @browser.element(:css => 'ul li:first-child div').click
                sleep 2
              else
                @browser.input(:id => 'identifierId').send_keys user_name
                sleep 1
                @browser.element(:id => 'identifierNext').click
                sleep 2
                @browser.input(:type => 'password').send_keys user_password #whs0nd
                sleep 1
                @browser.element(:id => 'passwordNext').click
                sleep 2
                if @browser.window.exists?
                  if @browser.element(:id => 'submit_approve_access').exists?
                    sleep 1
                    @browser.element(:id => 'submit_approve_access').click
                    sleep 1
                  end
                end
              end
            end
          else
            sleep 10
          end
        end
        @ui.css('xc-guestportals-google .google-auth-container .online_status.UP').wait_until_present
        expect(@ui.css('#guestportal_config_tab_general .dirtyIcon')).to be_present
        sleep 5
        expect(@ui.css('xc-guestportals-google .google-auth-container span:first-child').text).to eq("Directory sync is Active")
        expect(@ui.css('xc-guestportals-google .google-auth-container span:nth-child(2)').attribute_value("class")).to include("online_status UP")
        expect(@ui.css('xc-guestportals-google .centered span:nth-child(3)').text).to eq("Google Directory Administrator: #{user_name}")
        expect(@ui.css('xc-guestportals-google .togglebox_heading').text).to eq("Would you like to restrict access to specific Organizations?")
        if @ui.get(:checkbox , {css: 'xc-guestportals-google .switch .switch_checkbox'}).set? != true
          @ui.click('xc-guestportals-google .switch .switch_label')
          sleep 0.5
          expect(@ui.css("#google_orgsync .selected").text).to eq("0 Selections")
        else
          organization_boolean = true
        end
        sleep 1
        expect(@ui.css('#google_orgsync .select-all')).to be_present
        expect(@ui.css('#google_orgsync .clear')).to be_present
        sleep 1
        @ui.click('xc-guestportals-google .switch .switch_label')
        sleep 1
        expect(@ui.get(:checkbox , {css: 'xc-guestportals-google .switch .switch_checkbox'}).set?).to eq(false)
        sleep 0.5
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 2
        expect(@ui.get(:checkbox , {css: 'xc-guestportals-google .switch .switch_checkbox'}).set?).to eq(false)
      end
    end
    if authentication_type != "Google"
      it "Save the portal" do
        expect(@ui.css('#guestportal_config_tab_general .dirtyIcon')).to be_present
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 5
      end
    end
  end
end

shared_examples "update portal maximum device registration" do |portal_name, portal_type, max_devices|
  describe "Update the portal maximum device registration to '#{max_devices}' - #{portal_type.upcase}" do
    max_devices.each do |max_device_val|
      it "Update the maximum device registration value to '#{max_device_val}', save the portal and verify" do
        @ui.set_input_val("#guestportal_config_maxdevices", max_device_val)
        sleep 1
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        md = @ui.get(:text_field, {id: "guestportal_config_maxdevices"})
        md.wait_until_present
        expect(md.value).to eq(max_device_val)
      end
    end
  end
end

shared_examples "update portal session timeout on onboarding" do
  describe "Update portal session timeout - ONBOARDING ONLY VERIFICATION" do
    it "Verify that the Portal Session Timeout togglebox isn't visible when the Optional User Authentication is set to false" do
      @ui.css('#userauthentication_switch .switch_label').hover
      sleep 0.5
      @ui.click('#userauthentication_switch .switch_label')
      sleep 1
      expect(@ui.css('#guestportal_config_general_timeout')).not_to be_visible
      sleep 1
      @ui.css('#userauthentication_switch .switch_label').hover
      sleep 0.5
      @ui.click('#userauthentication_switch .switch_label')
      sleep 1
      expect(@ui.css('#guestportal_config_general_timeout')).to be_visible
      save_portal_ensure_no_error_is_displayed("onboarding")
    end
  end
end


shared_examples "update portal personal ssid expiration time" do |portal_name, portal_type|
  describe "Update the Personal SSID Expiration time - #{portal_type.upcase}" do
    it "Update the Personal SSID Expiration time - Fixed ('2016-01-01' & '01:23 pm')" do
      @ui.click('#guestportal_config_general_pssidexpiration div:nth-child(3) .switch .switch_label')
      sleep 1
      @ui.set_input_val("#general_expiration_fixed_day", "")
      10.times do
        @ui.send_keys :backspace
      end
      @ui.set_input_val("#general_expiration_fixed_day", "2016-01-01")
      sleep 1
      @ui.set_input_val("#general_expiration_time3", "01:23 pm")
      sleep 1
      @ui.click('#guestportal_config_general_pssidexpiration .switch_label')
      sleep 1
      @ui.click(".togglebox .switch_label")
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      xo = @ui.get(:text_field, {id: "general_expiration_fixed_day"})
      xo.wait_until_present
      expect(xo.value).to eq("2016-01-01")
      xcc = @ui.get(:text_field, {id: "general_expiration_time3"})
      xcc.wait_until_present
      expect(xcc.value).to eq("1:30 pm")
    end
    it "Update the Personal SSID Expiration time - Relative ('2 days 3 hours and 45 minutes')" do
      if @ui.get(:checkbox , {css: '#guestportal_config_general_pssidexpiration div:nth-child(3) .switch input'}).set? != false
        @ui.click('#guestportal_config_general_pssidexpiration div:nth-child(3) .switch .switch_label')
      end
      sleep 1
      @ui.set_input_val('#guestportal_ssidExpirationDays', '2')
      sleep 1
      @ui.set_input_val('#guestportal_ssidExpirationHours', '3')
      sleep 1
      @ui.set_input_val('#guestportal_ssidExpirationMinutes', '45')
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      expect(@ui.get(:input , {id: "guestportal_ssidExpirationDays"}).value).to eq('2')
      expect(@ui.get(:input , {id: "guestportal_ssidExpirationHours"}).value).to eq('3')
      expect(@ui.get(:input , {id: "guestportal_ssidExpirationMinutes"}).value).to eq('45')
    end
    it "Update the Personal SSID Expiration - Allow returning user to re-enable the expired Personal Wi-Fi (true / false)" do
      if @ui.get(:checkbox , {css: '#guestportal_config_general_pssidexpiration div:nth-child(4) input'}).set? == true
        @ui.click('#guestportal_config_general_pssidexpiration div:nth-child(4) .switch_label')
      end
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      expect(@ui.get(:checkbox , {css: '#guestportal_config_general_pssidexpiration div:nth-child(4) input'}).set?).to eq(false)
      sleep 1
      @ui.click('#guestportal_config_general_pssidexpiration div:nth-child(4) .switch_label')
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      expect(@ui.get(:checkbox , {css: '#guestportal_config_general_pssidexpiration div:nth-child(4) input'}).set?).to eq(true)
    end
  end
end

shared_examples "update portal personal ssid broadcasting" do |portal_name, portal_type, broadcasting|
  describe "Update the Personal SSID Broadcasting switch to '#{broadcasting}' for the portal '#{portal_name}'" do
    it "Set the Personal SSID Broadcasting switch to '#{broadcasting}'" do
      switch = @ui.get(:checkbox, {css: '#guestportal_config_general_view .innertab .innertab_content div:nth-child(3) div:nth-child(4) .switch input'})
      if broadcasting == true
        if switch.set? == false
          @ui.click('#guestportal_config_general_view .innertab .innertab_content div:nth-child(3) div:nth-child(4) .switch .switch_label')
          sleep 1
          expect(@ui.get(:checkbox, {css: '#guestportal_config_general_view .innertab .innertab_content div:nth-child(3) div:nth-child(4) .switch input'}).set?).to eq(true)
        end
      else
        if switch.set? == true
          @ui.css('#guestportal_config_general_view .innertab .innertab_content div:nth-child(3) div:nth-child(4) .switch .switch_label').hover
          @ui.click('#guestportal_config_general_view .innertab .innertab_content div:nth-child(3) div:nth-child(4) .switch .switch_label')
          sleep 1
          expect(@ui.get(:checkbox, {css: '#guestportal_config_general_view .innertab .innertab_content div:nth-child(3) div:nth-child(4) .switch input'}).set?).to eq(false)
        end
      end
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 2
      expect(@ui.get(:checkbox, {css: '#guestportal_config_general_view .innertab .innertab_content div:nth-child(3) div:nth-child(4) .switch input'}).set?).to eq(broadcasting)
    end
  end
end

def login_domains_add_procedure(portal_type, login_domain)
  previous_ul_entries = @ui.css('#guestportal_config_general_domain ul').lis.length
  @ui.set_input_val('#new_domain_item', login_domain)
  sleep 0.5
  @ui.click('#add_domain_item')
  sleep 0.5
  save_portal_ensure_no_error_is_displayed(portal_type)
  #expect(@ui.css('.msgbody')).to exist
  #expect(@ui.css('.msgbody div').text).to eq("Guest Portal saved successfully.\nChanges will take effect momentarily")
  sleep 1
  ul = @ui.css('#guestportal_config_general_domain ul')
  ul.wait_until_present
  expect(ul.lis.length).to eq(previous_ul_entries + 1)
end

shared_examples "update login domains" do |portal_name, portal_type, login_domain|
  describe "Update the login domain to '#{login_domain}' - #{portal_type.upcase}" do
    it "Update, save and verify that the portal Login Domains can be saved with the value: #{login_domain}" do #www.myDomain.com, www.myDomain.co.uk, www.myDomain.ro, www.myDomain.org, www.myDomain.test
      @browser.execute_script('$("#suggestion_box").hide()')
      previous_ul_entries = @ui.css('#guestportal_config_general_domain ul').lis.length
      login_domains_add_procedure(portal_type, login_domain)
      sleep 1
      @ui.ul_list_select_by_string('#guestportal_config_general_domain ul', login_domain)
      @ui.click('.deleteIcon')
      sleep 1
      @ui.click('#_jq_dlg_btn_1')
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ul = @ui.css('#guestportal_config_general_domain ul')
      ul.wait_until_present
      expect(ul.lis.length).to eq(previous_ul_entries)
    end
  end
end

shared_examples "update login domains add dont delete" do |portal_name, portal_type, login_domains|
  describe "Update the login domain to '#{login_domains.length}' for #{portal_type.upcase} '#{portal_name}'" do
    login_domains.each do |login_domain|
      it "Update, save and verify that the portal Login Domains can be saved with the value: #{login_domain}" do #www.myDomain.com, www.myDomain.co.uk, www.myDomain.ro, www.myDomain.org, www.myDomain.test
        @browser.execute_script('$("#suggestion_box").hide()')
        login_domains_add_procedure(portal_type, login_domain)
      end
    end
  end
end

shared_examples "update login domains dont delete" do |portal_name, portal_type, login_domain|
  describe "Update the login domain to '#{login_domain}' - #{portal_type.upcase}" do
    it "Update, save and verify that the portal Login Domains can be saved with the value: #{login_domain}" do #www.myDomain.com, www.myDomain.co.uk, www.myDomain.ro, www.myDomain.org, www.myDomain.test
      @browser.execute_script('$("#suggestion_box").hide()')
      login_domains_add_procedure(portal_type, login_domain)
    end
  end
end

shared_examples "update directory synchronization on" do |portal_name, portal_type, user_name, user_password|
  describe "Update the Directory Synchronization for a Google Portal" do
    it "Enable the Directory Synchronization for the portal named '#{portal_name}'" do
      expect(@ui.css('#guestportal_config_general_google span').text).to eq("Would you like to enable synchronization with Google Directory?")
      @ui.click('#guestportal_config_general_google .switch .switch_label')
      sleep 1
      expect(@ui.css('#guestportal_config_general_google .togglebox_contents').attribute_value("class")).to include("active")
      expect(@ui.css('#guestportal_config_general_google .active div:nth-child(1) a').text).to eq("Follow these steps...")
      expect(@ui.css('#guestportal_config_general_google .active .note').text).to eq("Enabling synchronization will allow you to provide access for a sub-set of users (Organization) in your Google Directory. EasyPass will automatically remove users which have been removed in your Google Directory.")
      expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) span:first-child').text).to eq("Directory sync is Inactive")
      expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) span:nth-child(2)').attribute_value("class")).to include("online_status DOWN")
      expect(@ui.css('#guestportal_config_general_domain ul')).not_to exist
      sleep 1
      expect(@ui.css('.google-directory-help')).not_to be_present
      @ui.click('#guestportal_config_general_google .active .centered .orange')
      sleep 5
      if @browser.window(:url => /accounts.google.com/).exists?
        @browser.window(:url => /accounts.google.com/) do
          if @browser.element(:id => 'submit_approve_access').exists?
            sleep 1
            @browser.element(:id => 'submit_approve_access').click
            sleep 1
          elsif @browser.element(:id => 'headingText').text == "Choose an account"
            expect(@browser.element(:css => 'ul')).to exist
            @browser.element(:css => 'ul li:first-child div').click
            sleep 2
          else
            @browser.input(:id => 'identifierId').send_keys user_name
            sleep 1
            @browser.element(:id => 'identifierNext').click
            sleep 2
            @browser.input(:type => 'password').send_keys user_password #whs0nd
            sleep 1
            @browser.element(:id => 'passwordNext').click
            sleep 2
            if @browser.window.exists?
              if @browser.element(:id => 'submit_approve_access').exists?
                sleep 1
                @browser.element(:id => 'submit_approve_access').click
                sleep 1
              end
            end
          end
        end
      else
        sleep 3
      end
      expect(@ui.css('#guestportal_config_tab_general .dirtyIcon')).to be_present
      sleep 5
      expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) span:first-child').text).to eq("Directory sync is Active")
      expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) span:nth-child(2)').attribute_value("class")).to include("online_status UP")
      expect(@ui.css('#guestportal_config_general_google .active .centered span:nth-child(3)').text).to eq("Google Directory Administrator: #{user_name}")
      expect(@ui.css('#guestportal_config_general_google .active .togglebox_heading').text).to eq("Would you like to restrict access to specific Organizations?")
      if @ui.get(:checkbox , {css: '#guestportal_config_general_google .active .switch .switch_checkbox'}).set? != true
        @ui.click('#guestportal_config_general_google .active .switch .switch_label')
        sleep 0.5
        expect(@ui.css("#google_orgsync .selected").text).to eq("0 Selections")
      else
        organization_boolean = true
      end
      sleep 1
      expect(@ui.css('#google_orgsync .select-all')).to be_present
      expect(@ui.css('#google_orgsync .clear')).to be_present
      sleep 1
      @ui.click('#guestportal_config_general_google .active .switch .switch_label')
      sleep 1
      expect(@ui.get(:checkbox , {css: '#guestportal_config_general_google .active .switch .switch_checkbox'}).set?).to eq(false)
      sleep 0.5
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 2
      expect(@ui.get(:checkbox , {css: '#guestportal_config_general_google .switch .switch_checkbox'}).set?).to eq(true)
      if organization_boolean == true
        expect(@ui.get(:checkbox , {css: '#guestportal_config_general_google .active .switch .switch_checkbox'}).set?).to eq(true)
      else
        expect(@ui.get(:checkbox , {css: '#guestportal_config_general_google .active .switch .switch_checkbox'}).set?).to eq(false)
      end
    end
  end
end

def find_organizational_unit(text_value, action)
  @ui.css('#google_orgsync label').hover
  if action == "Check"
    value = true
  elsif action == "Uncheck"
    value = false
  end
  script = "$('#google_orgsync label:contains(\"#{text_value}\")').prev(\"input.mac_chk\").click()"
  #script = "$('#google_orgsync label:contains(\"#{text_value}\")').prev(\"input.mac_chk\").prop(\"checked\", #{value})"
  @browser.execute_script(script)
  sleep 2
  script = "return $('#google_orgsync label:contains(\"#{text_value}\")').prev(\"input.mac_chk\").prop(\"checked\")"
  expect(@browser.execute_script(script)).to eq(value)
end

shared_examples "update directory synchronization change organization unit" do |portal_name, organization_unit, action, selected, root|
  describe "Change the Directory Synchronization for a Google Portal" do
    it "Change the Directory Synchronization to '#{organization_unit}' for the portal named '#{portal_name}'" do
      expect(@ui.css('#guestportal_config_general_google span').text).to eq("Would you like to enable synchronization with Google Directory?")
      expect(@ui.get(:checkbox , {css: "#guestportal_config_general_google .switch .switch_checkbox"}).set?).to eq(true)
      if @ui.get(:checkbox , {css: '#guestportal_config_general_google .active .switch .switch_checkbox'}).set? != true
        @ui.click('#guestportal_config_general_google .active .switch .switch_label')
      end
      sleep 2
      if organization_unit.class != String
        if organization_unit.class == Array
          organization_unit.each do |org_name|
            find_organizational_unit(org_name, action)
          end
        end
      else
        find_organizational_unit(organization_unit, action)
      end
      if selected != nil
        expect(@ui.css('#google_orgsync .selected').text).to eq(selected + " Selections")
      end
      if root == true
        @ui.click('#guestportal_config_general_google .active .switch .switch_label')
      end
      sleep 1
      expect(@ui.css('#guestportal_config_tab_general .dirtyIcon')).to be_present
      sleep 1
      save_portal_ensure_no_error_is_displayed("google")
      sleep 2
      if root != true
        expect(@ui.get(:checkbox , {css: '#guestportal_config_general_google .active .switch .switch_checkbox'}).set?).to eq(true)
      else
        expect(@ui.get(:checkbox , {css: '#guestportal_config_general_google .active .switch .switch_checkbox'}).set?).to eq(false)
      end
    end
  end
end

shared_examples "update directory synchronization off" do |portal_name, login_domain|
  describe "Set the Organization Unit in the directory for a Google Portal to OFF" do
    it "Change the Organization Unit to 'OFF' for the portal named '#{portal_name}'" do
      expect(@ui.css('#guestportal_config_general_google span').text).to eq("Would you like to enable synchronization with Google Directory?")
      expect(@ui.get(:checkbox , {css: "#guestportal_config_general_google .switch .switch_checkbox"}).set?).to eq(true)
      @ui.click('#guestportal_config_general_google .switch .switch_label')
      sleep 1
      expect(@ui.css('#guestportal_config_general_domain ul')).to be_visible
      sleep 1
      expect(@ui.css('#guestportal_config_tab_general .dirtyIcon')).to be_present
      sleep 1
      login_domains_add_procedure("azure", login_domain)
      sleep 2
      save_portal_ensure_no_error_is_displayed("google")
      sleep 0.4
    end
  end
end



shared_examples "update directory synchronization verify already logged in user" do |user_name|
  describe "Try to reauthenticate the user name of the Directory Synchronization for a Google Portal and verify that the user is only instructed to allow the use of the account" do
    it "Try to reauthenticate the user name and veirfy the new browser window's content" do
      sleep 2
      expect(@ui.css('#guestportal_config_general_google span').text).to eq("Would you like to enable synchronization with Google Directory?")
      expect(@ui.get(:checkbox , {css: "#guestportal_config_general_google .switch .switch_checkbox"}).set?).to eq(true)
      expect(@ui.css('#guestportal_config_general_google .active .centered span:nth-child(3)').text).to eq("Google Directory Administrator: #{user_name}")
      sleep 0.5
      @ui.click('#guestportal_config_general_google .active .centered .orange')
      sleep 3
      if @browser.window(:url => /accounts.google.com/).exists?
        @browser.window(:url => /accounts.google.com/) do
           expect(@browser.element(:css => 'ul')).to exist
           @browser.element(:css => 'ul li:first-child div').click
           sleep 2
        end
      end
      sleep 2
      expect(@ui.css('#guestportal_config_tab_general .dirtyIcon')).not_to be_present
      expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) span:first-child').text).to eq("Directory sync is Active")
      expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) span:nth-child(2)').attribute_value("class")).to include("online_status UP")
      expect(@ui.css('#guestportal_config_general_google .active .centered span:nth-child(3)').text).to eq("Google Directory Administrator: #{user_name}")
    end
  end
end

shared_examples "update directory synchronization verify invalid account error" do |user_name, user_password|
  describe "Use an invalid user name for the Directory Synchronization of a Google Portal and verify the error message received" do
    it "Try to use an invalid user name and verify the error message received" do
      expect(@ui.css('#guestportal_config_general_google span').text).to eq("Would you like to enable synchronization with Google Directory?")
      @ui.click('#guestportal_config_general_google .switch .switch_label')
      sleep 1
      expect(@ui.css('#guestportal_config_general_google .togglebox_contents').attribute_value("class")).to include("active")
      expect(@ui.css('#guestportal_config_general_google .active div:nth-child(1) a').text).to eq("Follow these steps...")
      expect(@ui.css('#guestportal_config_general_google .active .note').text).to eq("Enabling synchronization will allow you to provide access for a sub-set of users (Organization) in your Google Directory. EasyPass will automatically remove users which have been removed in your Google Directory.")
      expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) span:first-child').text).to eq("Directory sync is Inactive")
      expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) span:nth-child(2)').attribute_value("class")).to include("online_status DOWN")
      #expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) div:last-child').text).to eq("Authorization is required for Google Directory Synchronization.")
      expect(@ui.css('#guestportal_config_general_domain ul')).not_to exist
      sleep 0.5
      @ui.click('#guestportal_config_general_google .active .centered .orange')
      sleep 1
      @browser.window(:url => /accounts.google.com/) do
        if @browser.element(:id => 'submit_approve_access').exists?
          sleep 1
          @browser.element(:id => 'submit_approve_access').click
          sleep 1
        else
          @browser.input(:id => 'identifierId').send_keys user_name
          sleep 1
          @browser.element(:id => 'identifierNext').click
          sleep 3
          @browser.input(:type => 'password').send_keys user_password #whs0nd
          sleep 1
          @browser.element(:id => 'passwordNext').click
          sleep 0.3
          if @browser.window.exists?
            if @browser.element(:id => 'submit_approve_access').exists?
              sleep 1
              @browser.element(:id => 'submit_approve_access').click
              sleep 1
            end
          end
        end
      end
      @ui.css('.temperror').wait_until_present
      expect(@ui.css('.temperror .msgbody div').text).to eq("Please ensure the selected user has permissions to access the system.")
    end
    it "Try to save the portal and verify that it's not saved" do
      @ui.click('#guestportal_config_save_btn')
      sleep 1
      expect(@ui.css('#guestportal_config_tab_general .dirtyIcon')).to be_present
    end
    it "Verify the temp error is properly received" do
      expect(@ui.css('.temperror')).to be_visible
      expect(@ui.css('.temperror .msgbody div').text).to eq("Please see pages that have a \"\" to see where the errors occurred and how to fix them before saving.")
    end
    it "Verify the Directory Synchronization container is not activated" do
      expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) span:first-child').text).to eq("Directory sync is Inactive")
      expect(@ui.css('#guestportal_config_general_google .active .centered div:nth-child(2) span:nth-child(2)').attribute_value("class")).to include("online_status DOWN")
    end
  end
end

shared_examples "verify directory synchronization logged in user" do |user_name, organization_unit|
  describe "Verify that the user named '#{user_name}' is displayed as logged in as a Google Directory Administrator" do
    it "Verify that the Directory Synchronization is ON, ACTIVE and that the proper user is logged in" do
      sleep 1
      expect(@ui.css('#guestportal_config_general_google span').text).to eq("Would you like to enable synchronization with Google Directory?")
      expect(@ui.get(:checkbox , {css: "#guestportal_config_general_google .switch .switch_checkbox"}).set?).to eq(true)
      expect(@ui.css('#guestportal_config_general_google .active .centered span:nth-child(3)').text).to eq("Google Directory Administrator: #{user_name}")
      if organization_unit != ""
        expect(@ui.get(:checkbox , {css: '#guestportal_config_general_google .active .switch .switch_checkbox'}).set?).to eq(true)
        expect(@ui.css("#guestportal_config_general_google .active .ko_dropdownlist .ko_dropdownlist_button .text").text).to eq(organization_unit)
      end
    end
  end
end

shared_examples "update facebook wi-fi" do |login_cred, password, facebook_page_name|
  describe "Verify that the user can enable the Facebook Wi-Fi mode and pair it with '#{facebook_page_name}'" do
    it "Press the 'Configure Facebook Wi-Fi' button, select the proper page, bypass mode, session length and terms of service, save and close the pop-up browser window, verify that the proper facebook page is displayed as paired" do
      expect(@ui.css('#profile_tabs a:nth-child(2)')).not_to exist
      expect(@ui.css('.innertab .subtitle').text).to eq('Users can login after checking-in on Facebook.')
      expect(@ui.css('.orange.push-down').parent.parent.parent.element(css: ".field_heading").text).to eq('Configure Facebook Wi-Fi')
      expect(@ui.css('.orange.push-down').parent.parent.element(css: ".togglebox_heading.full").text).to eq('Configure your Facebook Wi-Fi settings:')
      expect(@ui.css('.orange.push-down')).to be_visible
      expect(@ui.css('.orange.push-down').text).to eq("CONFIGURE FACEBOOK WI-FI")
      sleep 1
      @ui.click('.orange.push-down')
      sleep 1
#      @browser_new = Watir::Browser.new :chrome
#        @browser_new.driver.manage.window.maximize
#        @ui_new = XMS::NG::UI.new(args = {browser: @browser_new})
#      @browser_new = @browser.window(:url => /www.facebook.com/)
#      puts @browser_new.methods.sort
#      #@browser_new.driver.manage.window.maximize
#      @ui_new = XMS::NG::UI.new(args = {browser: @browser_new})
#        #puts @ui_new.methods.sort
#        #if @ui_new.css('#email').exists?
#          @ui_new.set_input_val('#email', login_cred)
#          sleep 1
#          @ui_new.set_input_val('#pass', password)
#          sleep 1
#          @ui_new.click('#loginbutton')
#          sleep 3
#        #end
#        if @ui_new.css('#u_0_f ._55pe').text != facebook_page_name
#           @ui_new.click('#u_0_f ._3-99')
#          sleep 1
#          fb_page_names = @ui_new.get(:elements ,{css: '#u_0_e ._54nf ._54ni'})
#          fb_page_names.each do |fb_page_name|
#            fb_page_element_text = fb_page_name.element(css: "._54nh")
#            if fb_page_element_text.text == facebook_page_name
#              fb_page_element_text.click
#            end
#          end
#          sleep 1
#        end
#        if @ui_new.css('.uiHeaderTitle').exists?
#          @ui_new.click('#wifiConfigBottomBar ._42ft')
#          sleep 2
#          expect(@ui_new.css('output-text').text).to eq('Your settings have been saved. You can close this window.')
#          sleep 1
#        end

      @browser.window(:url => /www.facebook.com/) do
        if @browser.element(:id => 'email').exists?
          @browser.element(:id => 'email').send_keys login_cred
          sleep 1
          @browser.element(:id => 'pass').send_keys password
          sleep 1
          @browser.element(:id => 'loginbutton').click
          sleep 3
        end
        if @browser.element(:css => '#u_0_f ._55pe').text != facebook_page_name
          @browser.element(:css => '#u_0_f ._3-99').click
          sleep 1
          fb_page_names = @browser.elements(:css => '#u_0_e ._54nf ._54ni')
          fb_page_names.each do |fb_page_name|
            fb_page_element_text = fb_page_name.element(:css => "._54nh")
            if fb_page_element_text.text == facebook_page_name
              fb_page_element_text.click
            end
          end
          sleep 1
        end
        if @browser.element(:css => '.uiHeaderTitle').exists?
          @browser.element(:css => '#wifiConfigBottomBar ._42ft').click
          sleep 2
          expect(@browser.element(:id => 'output-text').text).to eq('Your settings have been saved. You can close this window.')
          sleep 1
        end
      end
      @browser.window(:url => /www.facebook.com/).close
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      expect(@ui.css('.orange.push-down').parent.element(css: "div").text).to eq("Paired with #{facebook_page_name}")
    end
  end
end

shared_examples "update azure authorization on" do |portal_name, portal_type, user_name, user_password|
  describe "Update the Microsoft Azure Authorization for an Azure Portal" do
    it "Enable the Microsoft Azure Authorization for the portal named '#{portal_name}'" do
      2.times do
        expect(@ui.css('.innertab_content .orange.push-down')).to be_present
        @ui.click('.innertab_content .orange.push-down')
        sleep 2
        break if !@browser.window(:url => /login.microsoftonline.com/).exists?
        @browser.window(:url => /login.microsoftonline.com/) do
            if @browser.input(:css => '.placeholderContainer .form-control').exists?
                  @browser.input(:css => '.placeholderContainer .form-control').send_keys user_name
                  sleep 1
                end
                if @browser.div(:css => '.form-group .tile-container .row .table').exists?
                  @browser.div(:css => '.form-group .tile-container .row .table').click
                  sleep 2
                end
                if @browser.button(:text => 'Next').exists?
                  @browser.button(:text => 'Next').click
                else
                  @browser.button(:text => 'Accept').click
                end
                sleep 1
                break if !@browser.window(:url => /login.microsoftonline.com/).exists?
                if @browser.input(:css => '.placeholderContainer .form-control').exists?
                  @browser.input(:css => '.placeholderContainer .form-control').send_keys user_password
                  sleep 2
                end
               if @browser.button(:text => 'Sign in').exists?
                  @browser.button(:text => 'Sign in').click
                  sleep 1
                end
                if @browser.element(:id => 'cred_accept_button').exists?
                  sleep 1
                  @browser.element(:id => 'cred_accept_button').click
                  sleep 1
                end
                sleep 3
                if @browser.input(:css => '.col-xs-12.primary .btn').exists?
                  sleep 1
                  @browser.input(:css => '.col-xs-12.primary .btn').click
                  sleep 1
                end
                sleep 3
                if @browser.window(:url => /login.microsoftonline.com/).exists?
                  if @browser.button(:text => 'Accept').exists?
                    @browser.button(:text => 'Accept').click
                  end
                  if @browser.button(:text => 'Yes').exists?
                    @browser.button(:text => 'Yes').click
                  end
                end
          end
        sleep 10
        if @ui.css('.loading').exists?
          @ui.css('.loading').wait_while_present
        end
      end
=begin
      expect(@ui.css('.authorize-container .azure-auth-container span').text).to eq("Successfully integrated with Azure by:\n" + user_name)
      expect(@ui.css('.authorize-container .azure-auth-container span:nth-child(2)').attribute_value("class")).to include("UP")
      expect(@ui.css('.authorize-container .togglebox .active div:nth-child(3) .centered span').text).to eq("Users visiting your network will connect from your selected groups in the following domain:")
      expect(@ui.css('.authorize-container .togglebox .active div:nth-child(3) .centered .azure-domain-input input')).to exist
      expect(@ui.css('.authorize-container .togglebox .active div:nth-child(3) .centered .azure-domain-input .xirrus-error')).to exist
      expect(@ui.get(:input , {css: '.authorize-container .togglebox .active div:nth-child(3) .centered .azure-domain-input input'}).value).to eq("alexxirrusoutlook.onmicrosoft.com")
      expect(@ui.css('.authorize-container .togglebox .active div:nth-child(3) .togglebox_heading').text).to eq("Would you like to restrict access to specific groups?")
      expect(@ui.css('.authorize-container .togglebox .active div:nth-child(3) .switch')).to exist
      sleep 1
=end
      @ui.css('xc-guestportals-azure .azure-domain-input').wait_until_present
      expect(@ui.css('xc-guestportals-azure .azure-domain-input')).to be_visible
      expect(@ui.css('xc-guestportals-azure .azure-auth-container span').text).to eq("Successfully integrated with Azure by:\n" + user_name)
      expect(@ui.css('xc-guestportals-azure .azure-auth-container span:nth-child(2)').attribute_value("class")).to include("UP")
      expect(@ui.css('xc-guestportals-azure .azure-domain-input').parent.span.text).to eq("Users visiting your network will connect from your selected groups in the following domain:")
      expect(@ui.css('xc-guestportals-azure .azure-domain-input input')).to exist
      expect(@ui.css('xc-guestportals-azure .azure-domain-input .xirrus-error')).to exist
      expect(@ui.get(:input , {css: 'xc-guestportals-azure .azure-domain-input input'}).value).to eq("alexxirrusoutlook.onmicrosoft.com")
      expect(@ui.css('xc-guestportals-azure .togglebox_heading').text).to eq("Would you like to restrict access to specific groups?")
      expect(@ui.css('xc-guestportals-azure .switch')).to exist
      expect(@ui.css('#guestportal_config_tab_general .dirtyIcon')).to be_present
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 5
    end
  end
end



shared_examples "update composite portals" do |portal_name, first_portal_name, second_portal_name| # Creted on 15.05.2017
  describe "Update the composite portals to '#{first_portal_name}' (first) and '#{second_portal_name}' (second) for the portal #{portal_name}" do
    it "(If needed) Change both portal fields to match the required portal names" do
      if @ui.css("#guestportal_config_portal1 a .text").text != first_portal_name
        @ui.set_dropdown_entry('guestportal_config_portal1', first_portal_name) and sleep 2
        expect(@ui.css('#guestportal_config_tab_general .dirtyIcon')).to be_present
      end
      if @ui.css("#guestportal_config_portal2 a .text").text != second_portal_name
        @ui.set_dropdown_entry('guestportal_config_portal2', second_portal_name) and sleep 2
        expect(@ui.css('#guestportal_config_tab_general .dirtyIcon')).to be_present
      end
      sleep 1
      @ui.click('#guestportal_config_tab_lookfeel')
      sleep 4
      @ui.click('#guestportal_config_tab_general')
      sleep 4
      save_portal_ensure_no_error_is_displayed("mega")
      sleep 5
    end
  end
end

def ads_prior_connection_list_actions(entries, searched_for_entry)
  table = @ui.css('#guestportal-config-general-ads tbody')
  expect(table.trs.length).to eq(entries)
  if entries != 0
    table_length = table.trs.length
    while table_length >= 1
      if table.element(:css => "#guestportal-config-general-ads tbody tr:nth-child(#{table_length}) .col-url span").title == searched_for_entry
        return table.element(:css => "#guestportal-config-general-ads tbody tr:nth-child(#{table_length})")
      end
      table_length-=1
    end
  end
  return nil
end

def verify_ads(url_size, url, weight)
  entry = ads_prior_connection_list_actions(url_size, url)
  if weight != nil
    expect(entry.element(:css => ".col-weight span").text).to eq(weight)
  end
  entry.hover and sleep 1
end

def delete_all_entries_from_the_ads_list
  table = @ui.css('#guestportal-config-general-ads tbody')
  table_length = table.trs.length
  if table_length != 0
    while table_length >= 1
      table.element(:css => "#guestportal-config-general-ads tbody tr:nth-child(#{table_length})").click
      sleep 0.5
      expect(table.element(:css => "#guestportal-config-general-ads tbody tr:nth-child(#{table_length}) .deleteIcon")).to be_present
      table.element(:css => "#guestportal-config-general-ads tbody tr:nth-child(#{table_length}) .deleteIcon").click
      @ui.css('.confirm .confirm').wait_until_present
      @ui.click('#_jq_dlg_btn_1')
      @ui.css('.confirm .confirm').wait_while_present
      table_length-=1
    end
  end
end

shared_examples "verify ads container not visible" do |portal_name, portal_type|
  describe "Verify that for the portal named '#{portal_name}' of type '@portal_type' the 'Ads Prior Connection' container isn't visible" do
    it "Expect the container not to be visible" do
      expect(@ui.css('.xc_ads_box')).not_to be_present
    end
  end
end

shared_examples "update ads" do |portal_name, portal_type, disable, url, frequency_enable, delay|
  describe "Update the 'Configure Ads Prior Connection' on the portal named '#{portal_name}'" do
    it "Update the 'Configure Ads Prior Connection' feature with '#{url}'" do
      @ui.css('.xc_ads_box').wait_until_present
      if @ui.get(:checkbox , {css: ".xc_ads_box input"}).set? == false
        @ui.click(".xc_ads_box .switch_label")
        css_builder = ".xc_ads_box .togglebox"
        elements_verify_hash = Hash[css_builder + " .togglebox_heading" => "Would you like to enable ads before connection", css_builder + " .togglebox_contents .url .label" => "Ad URL:", css_builder + " .togglebox_contents .togglebox_heading" => "Would you like to manually set the display frequency for each ad?", css_builder + " .togglebox_contents .field:nth-child(4) .short-label" => "", css_builder + " .togglebox_contents .field:nth-child(8) .short-label" => "Delay:", css_builder + " .togglebox_contents .field:nth-child(8) .label_after_input" => "seconds", css_builder + " .togglebox_contents .field:nth-child(9) div" => "Clients will see ads for this time until they can connect to the network"] #  css_builder + " .togglebox_contents .field:nth-child(5) .xirrus-error" => "The sum of the adverts' heights must add up to exactly 100%.",
        if @ui.get(:checkbox , { css: '.xc_ads_box .togglebox .togglebox_contents.active .switch input'}).set? == true
          elements_verify_hash[css_builder + " .togglebox_contents .field:nth-child(4) .short-label"] = "Weight:"
        end
        elements_verify_hash.keys.each { |key|
          expect(@ui.css(key).text).to eq(elements_verify_hash[key])
        }
      elsif @ui.get(:checkbox , {css: ".xc_ads_box input"}).set? == true and disable == true
        delete_all_entries_from_the_ads_list
        @ui.click(".xc_ads_box .switch_label") and sleep 1
        expect(@ui.get(:checkbox , {css: ".xc_ads_box input"}).set?).to eq(false)
      end
      if disable != true
        @ui.css('.xc_ads_box .togglebox .active div:nth-child(8) span').hover and sleep 1
        if frequency_enable == true
          if url.class == Array
            url.each { |url_each|
              @ui.set_input_val(".field.url input", url_each) and sleep 1
              @ui.click("#guestportal-config-general-addad") and sleep 1
            }
            @ui.set_input_val('.xc_ads_box .togglebox .active div:nth-child(8) input', delay)
            sleep 0.5
            save_portal_ensure_no_error_is_displayed(portal_type)
            ensure_voucher_portal_is_properly_handled(portal_type)
            sleep 0.3
            expect(@ui.css('.temperror')).not_to be_present
            sleep 5
            url_size = url.size
            url.each { |url_each|
              sleep 0.5
              verify_ads(url_size, url_each, nil)
              ads_prior_connection_list_actions(url_size, nil)
            }
            expect(@ui.get(:input ,  {css: '.xc_ads_box .togglebox .active div:nth-child(8) input'}).value).to eq(delay)
          elsif url.class == Hash
            expect(frequency_enable).to be_truthy
            if @ui.get(:checkbox , { css: '.xc_ads_box .togglebox .togglebox_contents.active .switch input'}).set? == false and frequency_enable == true
              @ui.click('.xc_ads_box .togglebox .togglebox_contents.active .switch .switch_label') and sleep 0.5
              expect( @ui.get(:checkbox , { css: '.xc_ads_box .togglebox .togglebox_contents.active .switch input'}).set?).to eq(true)
            end
            @ui.set_input_val('.xc_ads_box .togglebox .active div:nth-child(8) input', delay)
            url.keys.each { |key|
              @ui.set_input_val(".field.url input", key) and sleep 0.5
              if url[key] == "1"
                url_of_key = "1 (Lowest)"
              elsif url[key] == "10"
                url_of_key = "10 (Highest)"
              else
                url_of_key = url[key]
              end
              @ui.set_dropdown_entry('guestportal-config-general-adweights', url_of_key) and sleep 0.5
              @ui.click("#guestportal-config-general-addad") and sleep 1
            }
            sleep 0.5
            save_portal_ensure_no_error_is_displayed(portal_type)
            ensure_voucher_portal_is_properly_handled(portal_type)
            sleep 0.3
            expect(@ui.css('.temperror')).not_to be_present
            sleep 5
            expect(@ui.get(:input ,  {css: '.xc_ads_box .togglebox .active div:nth-child(8) input'}).value).to eq(delay)
            url_size = url.size
            url.keys.each { |key|
              sleep 0.5
              verify_ads(url_size, key, url[key])
              ads_prior_connection_list_actions(url_size, nil)
            }
          else
            @ui.set_input_val(".field.url input", url) and sleep 0.5
            @ui.click("#guestportal-config-general-addad") and sleep 1
            @ui.set_input_val('.xc_ads_box .togglebox .active div:nth-child(8) input', delay)
            sleep 0.5
            save_portal_ensure_no_error_is_displayed(portal_type)
            ensure_voucher_portal_is_properly_handled(portal_type)
            sleep 0.3
            expect(@ui.css('.temperror')).not_to be_present
            sleep 5
            expect(@ui.get(:input ,  {css: '.xc_ads_box .togglebox .active div:nth-child(8) input'}).value).to eq(delay)
            verify_ads(1, url, nil)
          end
        elsif frequency_enable == false
          if @ui.get(:checkbox , { css: '.xc_ads_box .togglebox div:nth-child(3) .switch input'}).set? == true and frequency_enable == false
            @ui.click('.xc_ads_box .togglebox div:nth-child(3) .switch switch_label') and sleep 1
            expect( @ui.get(:checkbox , { css: '.xc_ads_box .togglebox div:nth-child(3) .switch input'}).set?).to eq(false)
          end
        end
      end
      if disable == true and @ui.get(:checkbox , {css: ".xc_ads_box input"}).set? == true
         @ui.click(".xc_ads_box .switch_label")
         sleep 1
         save_portal_ensure_no_error_is_displayed(portal_type)
      end
    end
  end
end

def delete_certain_url_urls(url)
  found_entry = []
  url_entries = @ui.get(:elements , {css: "#guestportal-config-general-ads tbody tr"})
  url_entries.each { |url_entry|
    if url.class == Array
      url.each { |single_url|
        if url_entry.element(:css => ".col-url span").text == single_url
          found_entry = found_entry.push(url_entry)
          break
        end
      }
    else
      if url_entry.element(:css => ".col-url span").text == url
        found_entry = found_entry.push(url_entry)
        break
      end
    end
  }
  found_entry.each { |entry|
    entry.click
    sleep 1
    entry.element(:css => ".deleteIcon").click
    @ui.css('.confirm .confirm').wait_until_present
    expect(@ui.css('.confirm .title span').text).to eq("Remove Ad?")
    expect(@ui.css('.confirm .msgbody div').text).to eq("Are you sure you want to remove this ad?")
    @ui.click('#_jq_dlg_btn_1')
  }
end

shared_examples "update ads delete" do |portal_name, portal_type, disable, url|
  describe "Delete the Ad(s) with the name '#{url}' and then set the control to the value disabled '#{disable}'" do
    it "FInd the entry(ies) named '#{url}' and delete them" do
      if url == "All"
        delete_all_entries_from_the_ads_list
        sleep 0.5
      elsif url.class == Array
        delete_certain_url_urls(url)
      else
        delete_certain_url_urls(url)
      end
      if disable == true
        sleep 1
        puts @ui.get(:checkbox , {css: ".xc_ads_box input"}).set?
        if @ui.get(:checkbox , {css: ".xc_ads_box input"}).set? == true
          @ui.click(".xc_ads_box .switch_label")
        end
      end
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 0.3
      ensure_voucher_portal_is_properly_handled(portal_type)
      expect(@ui.css('.temperror')).not_to be_present
      sleep 3
      if disable == true
        expect(@ui.get(:checkbox , {css: ".xc_ads_box input"}).set?).to eq(false)
      else
        expect(@ui.get(:checkbox , {css: ".xc_ads_box input"}).set?).to eq(true)
      end
    end
  end
end

def calculate_display_chance_for_listed_entries(url, number_value)
  weight = []
  url.keys.each do |key|
    weight.push(url[key].to_i)
  end
  total_weight = weight.reduce(:+).to_f
  single_weight_value = (100/total_weight)#.round(2)
  aaa = (single_weight_value*number_value.to_f).round(2)
  array_for_single_weight_value = aaa.divmod 1
  array_for_single_weight_value[1] = array_for_single_weight_value[1]*10
  array_for_single_weight_value[1] = array_for_single_weight_value[1].ceil
  new_number = array_for_single_weight_value[0].to_f + array_for_single_weight_value[1]/10.0
  array = []
  array.push(new_number - 0.1)
  array.push(new_number)
  array.push(new_number + 0.1)
  array.map! {|number| number.round(1)}
  array.map! {|number| number.to_s + "%"}
  return array
end

shared_examples "update ads verify display chances" do |portal_name, portal_type, number_of_entries, url|
  describe "Verify that the Ads have the proper 'Display Chance' values" do
    url.keys.each do |key|
      it "Find the entry '#{key}' and edit it accordingly" do
        entry = ads_prior_connection_list_actions(number_of_entries, key)
        entry_percentage = entry.element(:css => '.col-chance span').text
        puts "entry_percentage #{entry_percentage}"
        calculated_percentage = calculate_display_chance_for_listed_entries(url, url[key])
        expect(calculated_percentage).to include(entry_percentage)
      end
    end
  end
end

shared_examples "update ads edit" do |portal_name, portal_type, number_of_entries, url, edit_criteria|
  describe "Edit the Ad with the name '#{url}' to contain the values: '#{edit_criteria}'" do
    it "Find the entry '#{url}' and edit it accordingly" do
      entry = ads_prior_connection_list_actions(number_of_entries, url)
      entry.click
      sleep 2
      expect(@ui.css('#guestportal-config-general-addad')).to be_present
      expect(@ui.css('#guestportal-config-general-canceladedit')).to be_present
      if edit_criteria["Name"] != nil
        @ui.set_input_val(".field.url input", edit_criteria["Name"]) and sleep 1
      end
      if edit_criteria["Weight"] != nil
        if edit_criteria["Weight"] == "1"
          url_of_key = "1 (Lowest)"
        elsif edit_criteria["Weight"] == "10"
          url_of_key = "10 (Highest)"
        else
          url_of_key = edit_criteria["Weight"]
        end
        @ui.set_dropdown_entry('guestportal-config-general-adweights', url_of_key) and sleep 0.5
      end
      sleep 1
      @ui.click('#guestportal-config-general-addad')
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 0.3
      ensure_voucher_portal_is_properly_handled(portal_type)
      expect(@ui.css('.temperror')).not_to be_present
    end
  end
end

# US 5128 - EPO | Self-Onboarding
shared_examples "verify self onboarding" do |portal_name, portal_type, verify_control, ssids, domains, profile_name|
  describe "Edit the Self-Onboarding feature on an Onboarding portal" do
    it "Go to portal" do
      @ui.goto_guestportal(portal_name)
    end

    if verify_control == true
      it "Verify that the 'Self-Onboarding' container exists and that it has the proper controls" do
        if !@ui.css('#header_arrays_link').exists?
          expect(@ui.css("#guestportal_config_general_selfonboarding .field_heading").text).to eq("Self-Onboarding")
          expect(@ui.get(:checkbox , {css: "#has_selfonboarding input"}).set?).to eq(false)
          @ui.click("#has_selfonboarding .switch_label")
          sleep 1.5
          expect(@ui.css("#guestportal_config_general_selfonboarding .togglebox .togglebox_heading").text).to eq("Do you want to enable Self-Onboarding?")
          #expect(@ui.css("#guestportal_config_general_selfonboarding .togglebox .togglebox_heading.subheading").text).to eq("PLACEHOLDER !!!!")
          expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(1) .field_label").text).to eq("Registration SSID:")
          expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(1) .orange")).to be_present
          expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(2) .field_label").text).to eq("Network SSID:")
          expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(2) .orange")).to be_present
          expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(2) .orange").attribute_value("class")).to eq("orange disabled")
          expect(@ui.css("#has_selfonboarding_domains + .togglebox_heading").text).to eq("Would you like to restrict domains?")
          @ui.click("#has_selfonboarding_domains .switch_label")
          sleep 1
          expect(@ui.css("#has_selfonboarding_domains ~ .togglebox_contents.active .field_label").text).to eq("Users visiting your network will connect to the following domain(s):")
          expect(@ui.css("#selfonboarding_add_domain_item")).to be_present
          expect(@ui.css("#selfonboarding_new_domain_item")).to be_present
          expect(@ui.css("#guestportal_config_general_selfonboarding_domain")).to be_present
        end
      end
    else
        it "Expect that the 'Self-Onboarding' switch is turned on" do
          if !@ui.css('#header_arrays_link').visible?
            expect(@ui.css("#guestportal_config_general_selfonboarding .field_heading").text).to eq("Self-Onboarding")
            expect(@ui.get(:checkbox , {css: "#has_selfonboarding input"}).set?).to eq(true)
           end
         end
      end
    if ssids == nil
      it "Close the 'Self-Onboarding' container" do
        if !@ui.css('#header_arrays_link').exists?
          expect(@ui.get(:checkbox , {css: "#has_selfonboarding input"}).set?).to eq(true)
          @ui.click("#has_selfonboarding .switch_label")
          sleep 1.5
          expect(@ui.get(:checkbox , {css: "#has_selfonboarding input"}).set?).to eq(false)
        end
      end
    else
      if ssids["Registration"] != nil
        if ssids["Verify"] != true
          it "Set the 'Registration SSID' to '#{ssids["Registration"]}'" do
            @ui.click("#guestportal_config_general_selfonboarding .active .field:nth-of-type(1) .orange")
            sleep 2
            expect(@ui.css('#ssid_add_modal')).to be_present
            expect(@ui.css('#ssid_add_modal .commonTitle').text).to eq("Select Registration SSID")
            expect(@ui.css('#ssid_add_modal .commonSubtitle').text).to eq("Select an SSID")
            if @ui.css('#ssid_filter .ko_dropdownlist_button .text').text != "All SSIDs"
            end
            @ui.get(:elements , {css: '#ssid_add_modal .lhs .select_list ul li'}).each do |li|
              if li.title == ssids["Registration"]
                li.click
              end
            end
            sleep 1
            @ui.click('#ssids_add_modal_move_btn')
            sleep 0.2
            @ui.click('#ssids_add_modal_addssids_btn')
            sleep 2
            expect(@ui.css('#ssid_add_modal')).not_to be_present
            expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(1) .orange")).not_to be_present
            expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(1) .registrationssid div div").text).to eq(ssids["Registration"])
            sleep 2
          end
        else
          if ssids["Registration"] == "Empty"
            it "Verify that the SSID registration control shows the orange button (empty)" do
              expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(1) .orange")).to be_present
            end
          else
            it "Verify the proper SSID(s) are set for SSID registration ('#{ssids["Registration"]}')" do
              sleep 2
              expect(@ui.css('#ssid_add_modal')).not_to be_present
              expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(1) .orange")).not_to be_present
              expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(1) .registrationssid div div").text).to eq(ssids["Registration"])
              sleep 2
            end
          end
        end
      end
      if ssids["Network"] != nil
        if ssids["Verify"] != true
          it "Set the 'Network SSID' to '#{ssids["Network"]}'" do
            if @ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(2) .orange").visible?
              @ui.click("#guestportal_config_general_selfonboarding .active .field:nth-of-type(2) .orange")
            else
              @ui.click("#guestportal_config_general_selfonboarding .active .field:nth-of-type(2) .networkssids")
            end
            sleep 2
            expect(@ui.css('#ssid_add_modal')).to be_present
            expect(@ui.css('#ssid_add_modal .commonTitle').text).to eq("Select network SSID(s)")
            expect(@ui.css('#ssid_add_modal .commonSubtitle').text).to eq("Select SSIDs from the left side and add them to the current guest portal to the right")
            # expect(@ui.css('#ssid_add_modal .lhs .current_profile div').text).to eq(profile_name)
            # expect(@ui.css('#ssid_add_modal .rhs .current_profile div').text).to eq(portal_name)
            selected = 0
            ssids["Network"].each do |li_title|
              @ui.get(:elements , {css: '#ssid_add_modal .lhs .select_list ul li'}).each do |li|
                if li.span.text == li_title
                  li.click
                  sleep 1
                  expect(@ui.css('#ssids_add_modal_move_btn')).to be_present
                  @ui.click('#ssids_add_modal_move_btn')
                  break
                end
              end
            end
            sleep 2
            @ui.click('#ssids_add_modal_addssids_btn')
            sleep 2
            expect(@ui.css('.confirm .confirm')).to be_present
            expect(@ui.css('.confirm .confirm .title span').text).to eq("Confirm Change?")
            expect(@ui.css('.confirm .confirm .msgbody div').text).to eq("Assigning this SSID to an EasyPass Onboarding portal will set encryption to WPA2/AES and authentication to User-PSK. Would you like to proceed with these changes?")
            @ui.click('#_jq_dlg_btn_1')
            sleep 2
            expect(@ui.css('#ssid_add_modal')).not_to be_present
            expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(2) .orange")).not_to be_present
            ssids["Network"].each do |ssid_name|
              found_string = false
              @ui.get(:elements, {css: "#guestportal_config_general_selfonboarding .active .field:nth-of-type(2) .networkssids div div"}).each do |div_string|
                if div_string.text == ssid_name
                  found_string = true
                end
              end
              expect(found_string).not_to eq(false)
            end
            sleep 2
          end
        else
          it "Verify the 'Self-Onboarding' control's values for the Network SSIDs ('#{ssids["Network"]}')" do
            expect(@ui.css("#guestportal_config_general_selfonboarding .active .field:nth-of-type(2) .orange")).not_to be_present
            ssids["Network"].each do |ssid_name|
              found_string = false
              @ui.get(:elements, {css: "#guestportal_config_general_selfonboarding .active .field:nth-of-type(2) .networkssids div div"}).each do |div_string|
                if div_string.text == ssid_name
                  found_string = true
                end
              end
              expect(found_string).not_to eq(false)
            end
          end
        end
      end
      if domains != nil
        if domains.class == String
          it "Verify that the domains control is '#{domains}'" do
            expect(@ui.css('#guestportal_config_general_selfonboarding_domain ul').lis.length).to eq(0)
          end
        elsif domains.class == Array
          it "Add the domain(s) '#{domains}'" do
            domains.each do |domain|
              @ui.set_input_val('#selfonboarding_new_domain_item', domain)
              sleep 1
              @ui.click('#selfonboarding_add_domain_item')
              sleep 1
            end
            domains.each do |domain_name|
              found_string = false
              @ui.get(:elements , {css: '#guestportal_config_general_selfonboarding_domain ul li .whitelist_record'}).each do |whitelist_record|
                if domain_name == whitelist_record.text
                  found_string = true
                end
              end
              expect(found_string).to eq(true)
            end
          end
        elsif domains.class == Hash
          it "Verify that the domains list control shows the elements: '#{domains["Verify"]}'" do
            domains["Verify"].each do |domain_name|
              found_string = false
              @ui.get(:elements , {css: '#guestportal_config_general_selfonboarding_domain ul li .whitelist_record'}).each do |whitelist_record|
                if domain_name == whitelist_record.text
                  found_string = true
                end
              end
              expect(found_string).to eq(true)
            end
          end
        end
      end
      it "Save the portal and ensure all values are kept" do
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ### TO ADD VALIDATIONS
      end
    end
  end
end

################################################ PORTALS SELECTION ################################################

shared_examples "portal general configurations" do |portal_name, portal_description, portal_type, landing_page, sponsor, sponsor_type, login_domain, max_devices, whitelist_element|
  it_behaves_like "go to portal", portal_name
  if portal_type == "google"
    it_behaves_like "update login domains dont delete", portal_name, portal_type, "new" + login_domain
    it_behaves_like "update login domains", portal_name, portal_type, login_domain
  elsif portal_type == "azure"
    it_behaves_like "update azure authorization on", portal_name, portal_type, $azure_user, $azure_password
  elsif portal_type == "mega"
    it_behaves_like "update composite portals", portal_name, landing_page, sponsor
  end
  it_behaves_like "update portal name", portal_name, portal_type
  it_behaves_like "update portal description", portal_name, portal_description, portal_type
  if ["self_reg","ambassador","onetouch","voucher","mega"].include? portal_type
    it_behaves_like "update portal language", portal_name, portal_type
  end
  unless ["google","personal","azure","facebook","mega"].include? portal_type
    it_behaves_like "update portal session expiration", portal_name, portal_type
  end
  unless ["personal","facebook","mega"].include? portal_type
    it_behaves_like "update portal landing page", portal_name, portal_type, landing_page
  end
  if ["self_reg", "onetouch", "voucher"].include? portal_type
    if login_domain.class == Array
      ads_hash = Hash[]
      login_domain[0].times { |i|
        url = "www.youtube.com/watch?v=QA4cj" + XMS.ickey_shuffle(9) + XMS.ickey_shuffle(4)
        if login_domain[2] == true
          ads_hash[url] = login_domain[1].sample
          if i >= login_domain[3]
            ads_hash[url] = "1"
          end
        else
          ads_hash[url] = login_domain[1]
        end
      }
      it_behaves_like "update ads" , portal_name, portal_type, false, ads_hash, true, "1"
      it_behaves_like "update ads" , portal_name, portal_type, true, nil, false, nil
    else
      it_behaves_like "update ads" , portal_name, portal_type, false, "www.google.com", true, "1"
      it_behaves_like "update ads edit", portal_name, portal_type, 1, "www.google.com", Hash["Name" => "www.google.co.uk", "Weight" => nil]
      it_behaves_like "update ads delete", portal_name, portal_type, true, "www.google.co.uk"
      it_behaves_like "update ads" , portal_name, portal_type, false, ["www.google.co.uk", "www.google.co.us", "www.google.ro", "www.google.ru"], true, "1"
      it_behaves_like "update ads delete", portal_name, portal_type, true, "All"
      it_behaves_like "update ads" , portal_name, portal_type, false, ["www.organization.org", "www.educational.edu", "www.net.net"], true, "1"
      it_behaves_like "update ads delete", portal_name, portal_type, false, ["www.educational.edu", "www.net.net"]
      it_behaves_like "update ads delete", portal_name, portal_type, true, "All"
      it_behaves_like "update ads" , portal_name, portal_type, false, Hash["www.google.com" => "7", "www.google.pt" => "6"], true, "1"
      it_behaves_like "update ads verify display chances", portal_name, portal_type, 2, Hash["www.google.com" => "7", "www.google.pt" => "6"]
      it_behaves_like "update ads delete", portal_name, portal_type, true, "All"
      it_behaves_like "update ads" , portal_name, portal_type, false, Hash["www.google.com" => "3", "www.google.pt" => "5", "www.google.co.uk" => "8", "www.google.us" => "10"], true, "1"
      it_behaves_like "update ads verify display chances", portal_name, portal_type, 4, Hash["www.google.com" => "3", "www.google.pt" => "5", "www.google.co.uk" => "8", "www.google.us" => "10"]
      it_behaves_like "update ads delete", portal_name, portal_type, true, "All"
      it_behaves_like "update ads" , portal_name, portal_type, true, nil, false, nil
      if portal_type == "self_reg"
        it_behaves_like "update ads" , portal_name, portal_type, false, Hash["http://test.edu" => "6", "www.msn.it" => "1", "https://www.org.org" => "1", "www.anything.net" => "1", "www.mail.gov" => "8", "www.advertisments.com/video?v=NBa125aDnQ" => "1", "www.youtube.com/watch=251fsda1ZA1sa1" => "1", "www.youtube.com/watch=251fsFsda1ZA1sa2" => "1", "www.youtube.com/watch=12QPd3Fsda1ZA1sa3" => "1", "www.youtube.com/watch=251fsA1sa4" => "1", "www.youtube.com/watch=23Fsda1ZA1sa5" => "1", "www.youtube.com/watch=QPd3Fsda1ZA1sa6" => "1", "www.youtube.com/watch=3Fsda1ZA1sa7" => "1", "www.youtube.com/watch=d3Fsda1ZA1sa8" => "1", "www.youtube.com/watch=A1sa9" => "1", "www.youtube.com/watch=251fsa412QP0" => "1", "www.youtube.com/watch=251fsa4111" => "1", "www.youtube.com/watch=2Fsda1ZA1sa12" => "1", "www.youtube.com/watch=25Pd3Fsda1ZA1sa13" => "1", "www.youtube.com/watch=d3Fsda1ZA1sa14" => "1", "www.youtube.com/watch=Pd3Fsda1ZA1sa15" => "1", "https://www.google.com" => "1"], true, "29"
        it_behaves_like "update ads verify display chances", portal_name, portal_type, 22, Hash["http://test.edu" => "6", "www.msn.it" => "1", "https://www.org.org" => "1", "www.anything.net" => "1", "www.mail.gov" => "8", "www.advertisments.com/video?v=NBa125aDnQ" => "1", "www.youtube.com/watch=251fsda1ZA1sa1" => "1", "www.youtube.com/watch=251fsFsda1ZA1sa2" => "1", "www.youtube.com/watch=12QPd3Fsda1ZA1sa3" => "1", "www.youtube.com/watch=251fsA1sa4" => "1", "www.youtube.com/watch=23Fsda1ZA1sa5" => "1", "www.youtube.com/watch=QPd3Fsda1ZA1sa6" => "1", "www.youtube.com/watch=3Fsda1ZA1sa7" => "1", "www.youtube.com/watch=d3Fsda1ZA1sa8" => "1", "www.youtube.com/watch=A1sa9" => "1", "www.youtube.com/watch=251fsa412QP0" => "1", "www.youtube.com/watch=251fsa4111" => "1", "www.youtube.com/watch=2Fsda1ZA1sa12" => "1", "www.youtube.com/watch=25Pd3Fsda1ZA1sa13" => "1", "www.youtube.com/watch=d3Fsda1ZA1sa14" => "1", "www.youtube.com/watch=Pd3Fsda1ZA1sa15" => "1", "https://www.google.com" => "1"]
        it_behaves_like "update ads delete", portal_name, portal_type, true, "All"
      end
      it_behaves_like "update ads" , portal_name, portal_type, true, nil, false, nil
    end
    if portal_type == "self_reg"
      it_behaves_like "update authentication to connect", portal_name, portal_type
      it_behaves_like "update portal sponsor", portal_name, portal_type, sponsor, sponsor_type
    end
  else
    it_behaves_like "verify ads container not visible", portal_name, portal_type
  end
  unless ["personal","onboarding","onetouch","facebook","mega"].include? portal_type
    it_behaves_like "update portal session timeout", portal_name, portal_type
  end
  if portal_type == "onetouch"
    it_behaves_like "update portal lockout time", portal_name, portal_type
  end
  if portal_type == "personal"
    it_behaves_like "update portal personal ssid expiration time", portal_name, portal_type
    it_behaves_like "update portal personal ssid broadcasting", portal_name, portal_type, true
    it_behaves_like "update portal personal ssid broadcasting", portal_name, portal_type, false
  end
  if ["onboarding", "voucher", "google", "azure"].include? portal_type
    if portal_type == "onboarding"
      it_behaves_like "verify self onboarding", portal_name, portal_type, true, nil, nil
      it_behaves_like "update optional user authentication", portal_name, portal_type
      it_behaves_like "update portal session timeout on onboarding"#, portal_name, portal_type
      it_behaves_like "update portal session timeout", portal_name, portal_type
    end
    it_behaves_like "update portal maximum device registration", portal_name, portal_type, max_devices
  end
  unless ["personal","facebook","mega"].include? portal_type
    it_behaves_like "show advanced"
    it_behaves_like "update portal whitelist", portal_name, portal_type, whitelist_element
    if portal_type != "onboarding"
      it_behaves_like "update quite tolerance", portal_name, portal_type
    end
  end
  if portal_type == "facebook"
    it_behaves_like "update facebook wi-fi", landing_page, sponsor, login_domain
  end
end

################################################ PORTAL GENERAL FEATURES ################################################

shared_examples "verify new easypass portal modal" do
  describe "Verify the 'New EasyPass Portal modal' features" do
    it "Open the 'New EasyPass Portal modal'" do
      @ui.click('#new_guestportal_tile')
      sleep 1
      expect(@ui.css('#guestportals_newportal')).to be_present
    end
    it "Verify the title ('New EasyPass Portal'), subtitle ('Choose an EasyPass portal type:') and break-up of portals ('Guest Access' and 'Employee/Student Access')" do
      expect(@ui.css('#guestportals_newportal .commonTitle').text).to eq("Choose an EasyPass™ Portal Type")
      expect(@ui.css('#guestportals_newportal .content .portal_selection .portal_group.guests .portal_group_title span').text).to eq("Guest Access")
      expect(@ui.css('#guestportals_newportal .content .portal_selection .portal_group.employee_student .portal_group_title span').text).to eq("Employee/Student Access")
    end
    it "Verify that the 'Guest Access' group has the proper entries (Self-Registration, Guest Ambassador, One-Click Access and Voucher)" do
      portal_names = Hash[1 => "Self-Registration", 2 => "Guest Ambassador", 3 => "One-Click Access", 4 => "Voucher"]
      portal_descriptions = Hash[1 => "Guests sign up to gain access using an online form.", 2 => "A guest ambassador must register the guest.", 3 => "Guests gain access after agreeing to terms of use.", 4 => "Users gain access using a pre-assigned access code."]
      portal_types = @ui.get(:elements , {css: '#guestportals_newportal .content .portal_selection .portal_group.guests .portal_group_list xc-big-icon-button-container'})
      expect(portal_types.length).to eq(4)
      portal_types.each_with_index { |portal_type, index|
        i = index + 1
        expect(portal_type.element(css: '.name').text).to eq(portal_names[i])
        expect(portal_type.element(css: '.description').text).to eq(portal_descriptions[i])
      }
    end
    it "Verify that the 'Employee/Student Access' has the proper entries ('Google Login', 'Onboarding', 'Microsoft Azure', 'Facebook Wi-Fi' and 'Personal Wi-Fi')" do
      portal_names = Hash[1 => "Google Login", 2 => "Onboarding", 3 => "Microsoft Azure", 4 => "Personal Wi-Fi"]#, 5 => "Facebook Wi-Fi", 6 => "Composite"]
      portal_descriptions = Hash[1 => "Users gain secure access using Google authentication.", 2 => "Users gain secure access using a unique PSK.", 3 => "Users gain secure access using Microsoft Azure authentication.", 4 => "Users create their own secure personal network."] #, 5 => "Users can login after checking-in on Facebook.", 6 => "TBD"]
      portal_types = @ui.get(:elements , {css: '#guestportals_newportal .content .portal_selection .portal_group.employee_student .portal_group_list xc-big-icon-button-container'})
      expect(portal_types.length).to eq(4)
      portal_types.each_with_index { |portal_type, index|
        i = index + 1
        expect(portal_type.element(css: '.name').text).to eq(portal_names[i])
        expect(portal_type.element(css: '.description').text).to eq(portal_descriptions[i])
      }
    end
  end
end
