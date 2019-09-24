require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_General/local_lib/feedback_lib.rb"
def find_grid_header_by_name_eircom(string)
  @ui.get_grid_header_count
  while ($header_count > 0) do
    if (@ui.css(".nssg-table thead tr th:nth-child(#{$header_count}) .mac_chk_label").exists?)
      puts "Column with the name '#{string}' has not been found!"
      break
    end
    expect(@ui.css(".nssg-table thead tr th:nth-child(#{$header_count}) div:nth-child(2)").text).not_to eq(string)
    $header_count-=1
  end
end

def ensure_ssid_policy_opened_and_show_advanced_visible
  ssid_policy = '#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy'
  if @ui.css(ssid_policy + " .policy-body .v-center.push-top.policy-footer .policy-show-advanced").text == "Show Advanced"
      @ui.css(ssid_policy + " .policy-body .v-center.push-top.policy-footer .policy-show-advanced").click
  end
  expect(@ui.css('.policies-container .policy-type-container:nth-of-type(2) .policiesAdvanced')).to be_visible
end

def ensure_global_policy_opened_and_show_advanced_visible
  global_policy = '#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy'
  if @ui.css(global_policy + " .policy-body .v-center.push-top.policy-footer .policy-show-advanced").text == "Show Advanced"
      @ui.css(global_policy + " .policy-body .v-center.push-top.policy-footer .policy-show-advanced").click
  end
  expect(@ui.css('.policiesAdvanced')).to be_visible
end

def add_global_policy_if_not_already_added
  if @ui.css('#no_policies_container').visible?
    @ui.click('#no_policies_new_global')
  else
    first_policy = @ui.css('#policies_content div:nth-child(3) .policyToggleDiv .policiesRowType').text
    until first_policy == "Global"
      @ui.css('#policies_content div:nth-child(3)').hover
      sleep 0.5
      @ui.css('#policies_content div:nth-child(3) .policyToggleDiv .policiesRowHover .policiesRowHoverDelete').click
      sleep 1
      @ui.click('#_jq_dlg_btn_1')
      sleep 1
      if @ui.css('#no_policies_container').visible?
        puts "No Policy lines to be deleted ..."
        break
      else
        first_policy = @ui.css('#policies_content div:nth-child(3) .policyToggleDiv .policiesRowType').text
      end
    end
    if @ui.css('#policies_new_global').exists?
      if @ui.css('#policies_new_global').visible?
        @ui.click('#policies_new_global')
      elsif @ui.css('#no_policies_container').visible?
        @ui.click('#no_policies_new_global')
      end
    elsif @ui.css('#no_policies_container').visible?
      @ui.click('#no_policies_new_global')
    else
      puts "'Global Policy' already added"
    end
  end
end

shared_examples "verify contact page eircom" do
  describe "Verify the 'Contact' page contains the proper information for an Eircom customer" do
    it "Go to the 'Contact' page" do
      @ui.click('#header_nav_user')
      sleep 0.5
      @ui.click('#header_contact')
      sleep 1
    end
    it "Verify that the proper information is displayed for the 'Advantage WiFi Support' section" do
      expect(@ui.css('#contactView .contents .topSection ul li:first-child .title').text).to eq("Advantage WiFi Support");
      expect(@ui.css('#contactView .contents .topSection ul li:first-child .address a').text).to eq("www.eir.ie/AdvantageWiFi");
      expect(@ui.css('#contactView .contents .topSection ul li:first-child .phone li').text).to eq("1890 564 002 | 24h Support");
    end
    it "Verify that the proper information is displayed for the 'General eircom queries' section" do
      expect(@ui.css('#contactView .contents .topSection ul li:nth-child(2) .title').text).to eq("General eir queries");
      expect(@ui.css('#contactView .contents .topSection ul li:nth-child(2) .address a').text).to eq("business.eir.ie/");
      expect(@ui.css('#contactView .contents .topSection ul li:nth-child(2) .phone li').text).to eq("1800 400 200 | Mon-Fri 8am - 6pm");
    end
  end
end

shared_examples "verify support link removal" do
  describe "On an Eircom tenant - Verify that the 'Support Link' has been removed" do
    it "Open the 'Contact Support or Give us Feedback' drawer" do
      if !@ui.css('#suggestion_box .suggestionContainer .suggestionTitle').visible?
      @ui.click('#header_nav_user')
      sleep 0.5
      @ui.click('#header_suggestion_box')
      sleep 1
      @ui.click('#suggestion_box .suggestionTitle')
      end
      @ui.click('#suggestion_box .suggestionTitle')
      sleep 0.5
      @ui.click('xc-big-icon-button-container .support')
    end
    it "Verify that the 'chat with Support ...' link is removed" do
      find_new_tab_and_verify_contact_support
    end
    it "Open the 'Contact Support or Give us Feedback' drawer and hide the Suggestion modal" do
      @ui.click('#suggestion_box .suggestionTitle')
      sleep 0.5
      @ui.click('#suggestion_hide')
    end
    it "Open the 'User account' dropdown list " do
      @ui.click('#header_logo')
      sleep 2
      @ui.click('#header_nav_user')
    end
    it "Verify that the 'Support or Feedback' option is displayed and that pressing it opens the 'Contact Support or Give us Feedback' drawer" do
      expect(@ui.css('#header_suggestion_box')).to be_visible
      sleep 0.5
      @ui.click('#header_suggestion_box')
      sleep 0.5
      expect(@ui.css('#suggestion_box .suggestionContainer')).to be_visible
      sleep 1
      @ui.click('#suggestion_box .suggestionTitle')
    end
    it "Navigate to the home page" do
      @ui.click('#header_logo')
    end
  end
end

shared_examples "verify mobile isn't present" do |portal_name|
  describe "Verify that there is no reference about 'mobile' ('phone number') on an Access Services's Look and Feel tab or the Guests / Users tables (secondary tab)" do
    it "Go to the Access Service named '#{portal_name}'" do
      @ui.click('#header_nav_guestportals')
      sleep 1
      @ui.click('.guestportals_nav #view_all_nav_item')
      @portal_tile = @ui.guestportal_tile_with_name portal_name

      @portal_tile.click
      sleep 1
    end
    it "Go to the 'Look & Feel' tab" do
      @ui.click('#guestportal_config_tab_lookfeel')
    end
    it "Verify that the 'Require Mobile' checkbox is not present" do
      expect(@ui.css('#requireMobile + .mac_chk_label').present?).to eql(false)
    end
    it "Select the 'Register Page'" do
      @ui.click('#guestportal_config_lookfeel_preview_tile_register')
      sleep 1
    end
    it "Verify that there is no element that references the user of 'Mobile' or 'Phone Number'" do
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      expect(frame.element(:css => "#mobile").present?).to eql(false)
    end
    it "Go to the Guests/Users tab (secondary tab) " do
      @ui.click('#profile_tabs a:nth-child(2)')
    end
    it "Add all columns to the grid if not already added" do
      @ui.click('#guestportal_guests_grid_cp')
      sleep 1.5
      if @ui.css('#column_selector_modal_moveall_btn').visible?
        @ui.click('#column_selector_modal_moveall_btn')
        sleep 1.5
      end
      @ui.click('#column_selector_modal_save_btn')
    end
    it "Ensure that the 'Mobile' column is not displayed in the grid" do
      #@ui.find_grid_header_by_name('Mobile')
      find_grid_header_by_name_eircom('Mobile')
#      ths = @ui.css('.nssg-table thead tr').ths
#
#      for i in 0..(ths.length-1)
#        expect(@ui.css('.nssg-table thead tr th:nth-child('+(i+1).to_s+')').text).to_not eq("Mobile")
#      end
    end
    it "Open the 'New user' slideout window and verify that the 'Send by Text' option is not displayed" do
      @ui.click('#manageguests_addnew_btn');
      sleep 1
      expect(@ui.css('.sendByText').present?).to eql(false)
    end
  end
end

shared_examples "verify settings my account eircom" do
  describe "Verify the 'Settings' page for an eircom tenant" do
    it "Go to the 'My Account' tab (Settings)" do
        @ui.click('#header_nav_user')
        sleep 0.5
        @ui.click('#header_settings_link')
        sleep 0.5
        expect(@browser.url).to include('/#settings/myaccount')
    end
    it "Change the 'First Name' value to a test value then back to the original value" do
      change_input_field_value_to_new_and_back(:text_field, 'myaccount_myaccountfirstname', 'TEST VALUE', '#settings_myaccount .commonTitle')
    end
    it "Change the 'Last Name' value to a test value then back to the original value" do
      change_input_field_value_to_new_and_back(:text_field, 'myaccount_myaccountlastname', 'TEST VALUE', '#settings_myaccount .commonTitle')
    end
    it "Change the 'Additional Details' value to a test value then back to the original value" do
      change_input_field_value_to_new_and_back(:textarea, 'myaccount_description', 'TEST VALUE', '#settings_myaccount .commonTitle')
    end
    #it "Change the 'Primary Email' value to a test value then back to the original value" do
    #  change_input_field_value_to_new_and_back(:text_field, 'myaccount_myaccountname', 'TEST_VALUE@qa.com', '#settings_myaccount .commonTitle')
    #end
    it "Expect that the 'Mobile Number' and 'Carrier' fields are not displayed" do
      expect(@ui.css('#settings_tab_mobileproviders').present?).to eql(false)
      expect(@ui.css('.mobile_field').present?).to eql(false)
    end
    it "Verify the Notifications header title has the quick help icon and the proper text" do
      @ui.css('#settings_myaccount div:nth-child(10) .infoBtn').hover
      sleep 0.5
      # expect(@ui.css('#settings_myaccount div:nth-child(10) .infoBtn.ko_tooltip_active')).to exist
      expect(@ui.css('#ko_tooltip')).to be_visible
      sleep 0.5
      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq('If Email is checked for a specific type of alert, a notification is sent when the alert is opened and when it is closed')
    end
    it "Verify the 'Alerts for Access Point Down' string has the quick help icon and the proper text" do
      @ui.css('#settings_myaccount .field.alertsTable div:nth-child(2) .cell.first .infoBtn').hover
      sleep 0.5
      # expect(@ui.css('#settings_myaccount .field.alertsTable div:nth-child(2) .cell.first .infoBtn.ko_tooltip_active')).to exist
      expect(@ui.css('#ko_tooltip')).to be_visible
      sleep 0.5
      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq('This alert is opened when an Access Point goes offline due to any reason (powered off, network connection lost etc) and closed when the Access Point comes back online')
    end
    it "Verify the 'Alerts for Profile Access Point Down' string has the quick help icon and the proper text" do
      @ui.css('#settings_myaccount .field.alertsTable div:nth-child(3) .cell.first .infoBtn').hover
      sleep 0.5
      # expect(@ui.css('#settings_myaccount .field.alertsTable div:nth-child(3) .cell.first .infoBtn.ko_tooltip_active')).to exist
      expect(@ui.css('#ko_tooltip')).to be_visible
      sleep 0.5
      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq('This alert is opened when all the Access Points in any profile go offline and is closed when at least one Access Point in that same profile is back online')
    end
    it "Verify the 'Alerts for Station Count' string has the quick help icon and the proper text" do
      @ui.css('#settings_myaccount .field.alertsTable div:nth-child(4) .cell.first .infoBtn').hover
      sleep 0.5
      # expect(@ui.css('#settings_myaccount .field.alertsTable div:nth-child(4) .cell.first .infoBtn.ko_tooltip_active')).to exist
      expect(@ui.css('#ko_tooltip')).to be_visible
      sleep 0.5
      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq('This is a proactive alert that is opened when the total number of clients on an Access Point exceed 30*(number of radios on the Access Point) and is closed when the total number of clients on the same Access Point fall below 20*(number of radios on the Access Point)')
    end
    it "Verify the 'Alerts for DHCP Failure' string has the quick help icon and the proper text" do
      @ui.css('#settings_myaccount .field.alertsTable div:nth-child(5) .cell.first .infoBtn').hover
      sleep 0.5
      # expect(@ui.css('#settings_myaccount .field.alertsTable div:nth-child(5) .cell.first .infoBtn.ko_tooltip_active')).to exist
      expect(@ui.css('#ko_tooltip')).to be_visible
      sleep 0.5
      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq('This alert is opened when a client is stuck with a 169.254.x.y IP address')
    end
    it "Place a tick for the notifications settings and verify it's properly set" do
        place_remove_tick_from_notifications_table
        expect($global_check_boxes.length).to eq($checked)
    end
    it "Remove the tick for the notifications settings and verify it's properly removed" do
        place_remove_tick_from_notifications_table
        expect($checked).to eq(0)
    end
    it "Click the 'Change Password' button and verify that the change passoword modal is properly displayed" do
      @ui.click('#myaccount_changepassword_btn')
      sleep 0.6
      @ui.css('.modal-change-password .ui-draggable').wait_until(&:present?)
      sleep 0.5
      @ui.click('.modal-change-password .ui-draggable .xc-modal-close')
    end
  end
end

shared_examples "change settings user accounts tab eircom create users" do |number_of_users, xms_priviledge, cloud_priviledge|
  describe "Perform changes on the 'User Accounts' page from Settings and add '#{number_of_users}' users" do
    it "Go to the 'Settings' area then to the 'User Accounts' tab" do
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_settings_link')
      sleep 1
      @ui.click('#settings_tab_useraccounts')
      sleep 2
    end
    it "Set the view per page to '1000' entries" do
      set_paging_view_per_grid("1000")
    end
    it "Get the grid length" do
      @ui.get_grid_length
      $grid_length_before = $grid_length
    end
    it "Create #{number_of_users} accounts" do
      @browser.execute_script('$("#suggestion_box").hide()')

      (1..number_of_users).each do
          usrFName = UTIL.ickey_shuffle(12)
          usrLName = UTIL.random_firstname.downcase
          usrDesc = UTIL.chars_255.upcase
          usrEmail = UTIL.random_email

          @ui.click('#useraccounts_newuser_btn')
          sleep 0.5
          @ui.set_input_val('#usermodal_firstname',usrFName)
          sleep 0.5
          @ui.set_input_val('#usermodal_lastname',usrLName)
          sleep 0.5
          @ui.set_input_val('#usermodal_details', usrDesc)
          sleep 0.5
          @ui.set_input_val('#usermodal_email',usrEmail)
          sleep 0.5
          @ui.set_dropdown_entry('ddl_XMS', xms_priviledge)
          sleep 0.5
          @ui.set_dropdown_entry('ddl_BACKOFFICE', cloud_priviledge)
          sleep 0.5
          @ui.click('#users_modal_save_btn')
          sleep 0.5
          dialog = @ui.css('.dialogOverlay')
          if dialog.exists? and dialog.visible?
            dialog.wait_while_present
          end
        end
    end
    it "Verify that the original grid length has been modified by #{number_of_users}" do
      @ui.get_grid_length
      $grid_length_after = $grid_length
      expect($grid_length_after).not_to eq($grid_length_before)
      grid_length_after_verify = $grid_length_before + number_of_users
      expect($grid_length_after).to eq(grid_length_after_verify)
    end
  end
end

shared_examples "verify general features eircom" do
  describe "Verify the general features of an EIRCOM client are properly displayed" do
    it "Go to the 'Home' page" do
      @ui.click('#header_logo')
    end
    it "Verify the main FOOTER has the proper elements " do
#      expect(@ui.login_form_header_image).to include('eircom-logo.png')
      expect(@ui.css('#copyright').text).to eq('Copyright © 2005-2019 Xirrus, Inc. All Rights Reserved.')
      expect(@ui.css('#footer_privacy_link').text).to eq('Privacy Policy')
      expect(@ui.css('#footer_privacy_link').attribute_value("href")).to eq('http://www.riverbed.com/legal/privacy-policy/')
      expect(@ui.css('#footer_terms_link').text).to eq('Terms of Use')
      expect(@ui.css('#footer_terms_link').attribute_value("href")).to eq('http://www.riverbed.com/license')
      #expect(@ui.css('#main_footer .appTitle')).not_to be_visible
    end
    it "Verify that the available tabs in 'Settings' are: 'My Account', 'User Accounts', 'Add-on Solutions'" do
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_settings_link')
      sleep 2
      expect(@ui.css('#settings_tab_myaccount')).to be_visible
      expect(@ui.css('#settings_tab_useraccounts')).to be_visible
      expect(@ui.css('#settings_tab_addonsolutions')).to be_visible
      expect(@ui.css('#settings_tab_mobileproviders')).not_to exist
    end
  end
end

shared_examples "addon solutions activation of web titan" do |ip_address|
  describe "Test the Add-On Solutions tab and activate the WebTitan Content Filtering" do
    it "Go to Settings -> Add-on Solutions tab" do
      @ui.css('#header_nav_user').wait_until(&:present?)
      @ui.click('#header_nav_user')
      sleep 1
      @ui.css('#header_settings_link').wait_until(&:present?)
      @ui.click('#header_settings_link')
      sleep 4
      @ui.click('#settings_tab_addonsolutions')
      expect(@browser.url).to include("/#settings/addonsolutions")
    end
    it "Focus on the available options and ensuer that the whiteboxes 'AirWatch MDM' and 'WebTitan Content Filtering' are visible and not expanded, then expand them" do
      whiteboxes_container = @ui.css('.saos-ul')
      whiteboxes_container.wait_until(&:present?)
      whiteboxes_count = whiteboxes_container.lis.length

      expect(whiteboxes_count).to eq(4)

      airwatch_whitebox = @ui.css('.saos-ul li:first-child .saos-li-top')
      airwatch_whitebox.wait_until(&:present?)
      if(airwatch_whitebox.attribute_value("class")!="saos-li-top expanded")
          airwatch_whitebox.click
      end
      sleep 1

      webtitan_whitebox = @ui.css('.saos-ul li:nth-child(2) .saos-li-top')
      webtitan_whitebox.wait_until(&:present?)
      if(webtitan_whitebox.attribute_value("class")!="saos-li-top expanded")
          webtitan_whitebox.click
      end
    end
    it "Press the 'Collapse All' button and expand only the 'WebTitan Content Filtering' whitebox" do
      @ui.click('.saos-body .saos-collapse')
      sleep 1
      webtitan_whitebox = @ui.css('.saos-ul li:nth-child(2) .saos-li-top')
      webtitan_whitebox.wait_until(&:present?)
      if(webtitan_whitebox.attribute_value("class")!="saos-li-top expanded")
          webtitan_whitebox.click
      end
    end
    it "Ensure that the 'WebTitan Content Filtering' whitebox has the following features: 'WebTitan Content Filtering' (title), 'Web Content Filtering' (category), 'DNS:' (label text for input box), an input box, 'DNS must be in the form of an IP address.' (description text for the input box)" do
      $webtitan_whitebox_title = @ui.css('.saos-ul li:nth-child(2) .saos-li-top .saos-li-top-name').text
      $webtitan_whitebox_category = @ui.css('.saos-ul li:nth-child(2) .saos-li-top .saos-li-top-category').text
      $webtitan_whitebox_label = @ui.css('.saos-ul li:nth-child(2) .saos-li-body form .xc-field label').text
      $webtitan_whitebox_input = @ui.css('.saos-ul li:nth-child(2) .saos-li-body form .xc-field input')
      $webtitan_whitebox_description = @ui.css('.saos-ul li:nth-child(2) .saos-li-body .saos-wcf-dns-label').text

      expect($webtitan_whitebox_title).to eq("WebTitan Content Filtering")
      expect($webtitan_whitebox_category).to eq("Web Content Filtering")
      expect($webtitan_whitebox_label).to eq("Primary DNS")
      expect($webtitan_whitebox_input.visible?).to eq(true)
      #expect($webtitan_whitebox_input.value).to eq('')
      expect($webtitan_whitebox_description).to eq("DNS must be in the form of an IP address.")
    end
    it "Set the value 'https://www.test.org' in the DNS input box" do
      @ui.set_val_for_input_field('.saos-ul li:nth-child(2) .saos-li-body form .xc-field input',"https://www.test.org")
    end
    it "Navigate away from the input field, verify that the field properly shows an error highlight, press the <SAVE ALL> button and verify the error message is 'Please review your changes to fix all invalid fields.'" do
      @ui.click('#settings-addonsolutions .top .commonTitle')
      sleep 0.5
      @ui.click('.saos-ul li:nth-child(2) .saos-li-body form .xc-field input')
      sleep 1
      #expect($webtitan_whitebox_input.attribute_value("class")).to eq('invalid')
      expect(@ui.css('.saos-ul li:nth-child(2) .saos-li-body form .xc-field .xirrus-error.saos-field-error')).to be_present
      sleep 1
      @ui.click('#settings-addonsolutions .top .saos-save-btn')
      sleep 1
      expect(@ui.css('.dialogOverlay.temperror .title span').text).to eq("Invalid Fields")
      expect(@ui.css('.dialogOverlay.temperror .msgbody div').text).to eq("Please review your changes to fix all invalid fields.")
    end
    it "Set the value '#{ip_address}' in the DNS input box" do
      @ui.set_val_for_input_field('.saos-ul li:nth-child(2) .saos-li-body form .xc-field input',ip_address)
    end
    it "Press the <SAVE ALL> button and verify the dialog overlay message is 'Success'" do
      @ui.click('#settings-addonsolutions .top .saos-save-btn')
      sleep 1
      expect(@ui.css('.dialogOverlay.success .msgbody div').text).to eq("Success")
    end
    it "Refresh the browser, expand the 'WebTitan Content Filtering' whitebox and verify that the DNS value is '#{ip_address}'" do
      @browser.refresh
      sleep 2
      webtitan_whitebox = @ui.css('.saos-ul li:nth-child(2) .saos-li-top')
      webtitan_whitebox.wait_until(&:present?)
      if(webtitan_whitebox.attribute_value("class")!="saos-li-top expanded")
          webtitan_whitebox.click
      end
      sleep 1
      $webtitan_whitebox_input = @ui.css('.saos-ul li:nth-child(2) .saos-li-body form .xc-field input')
      expect(@ui.get(:input, {css: '.saos-ul li:nth-child(2) .saos-li-body form .xc-field input'}).value).to eq(ip_address)
    end
  end
end

shared_examples "addon solutions deactivation of web titan" do
  describe "Test the Add-On Solutions tab and activate the WebTitan Content Filtering" do
    it "Go to Settings -> Add-on Solutions tab" do
      @ui.css('#header_nav_user').wait_until(&:present?)
      @ui.click('#header_nav_user')
      sleep 1
      @ui.css('#header_settings_link').wait_until(&:present?)
      @ui.click('#header_settings_link')
      sleep 4
      @ui.click('#settings_tab_addonsolutions')
      expect(@browser.url).to include("/#settings/addonsolutions")
    end
    it "Expand the 'WebTitan Content Filtering' whitebox and remove the input field's value" do
      webtitan_whitebox = @ui.css('.saos-ul li:nth-child(2) .saos-li-top')
      webtitan_whitebox.wait_until(&:present?)
      if(webtitan_whitebox.attribute_value("class")!="saos-li-top expanded")
          webtitan_whitebox.click
      end
      sleep 1
      @ui.set_val_for_input_field('.saos-ul li:nth-child(2) .saos-li-body form .xc-field input',"")
    end
    it "Press the <SAVE ALL> button and verify that the dialog overlay message is 'Success' (Also if it appears - verify the confirmation message is 'Saving with incomplete settings will cause WebTitan to be disabled in all Profiles. Do you wish to continue?'" do
      @ui.click('#settings-addonsolutions .top .saos-save-btn')
      if @ui.css('.dialogOverlay.confirm').exists?
        expect(@ui.css('.dialogOverlay.confirm .title span').text).to eq("Configuration Incomplete")
        expect(@ui.css('.dialogOverlay.confirm .msgbody div').text).to eq("Saving with incomplete settings will cause WebTitan to be disabled in all Profiles. Do you wish to continue?")
        @ui.click('#_jq_dlg_btn_1')
      end
      sleep 0.5
      expect(@ui.css('.dialogOverlay.success .msgbody div').text).to eq("Success")
    end
    it "Refresh the browser, expand the 'WebTitan Content Filtering' whitebox and verify that the DNS value is ''" do
      @browser.refresh
      sleep 2
      webtitan_whitebox = @ui.css('.saos-ul li:nth-child(2) .saos-li-top')
      webtitan_whitebox.wait_until(&:present?)
      if(webtitan_whitebox.attribute_value("class")!="saos-li-top expanded")
          webtitan_whitebox.click
      end
      sleep 1
      $webtitan_whitebox_input = @ui.css('.saos-ul li:nth-child(2) .saos-li-body form .xc-field input')
      expect(@ui.get(:input, {css: '.saos-ul li:nth-child(2) .saos-li-body form .xc-field input'}).value).to eq('')
    end
  end
end

shared_examples "addon solutions profile cannot set web titan on if it is not configured" do |profile_name|
  describe "Verify that on the profile named '#{profile_name}', the 'WebTitan' content filtering cannot be enabled because it is not configured properly" do
    it "Go to the profile '#{profile_name}' and then to the policies tab" do
      @ui.goto_profile profile_name
      sleep 2
      @ui.click('#profile_config_tab_policies')
      sleep 1
      expect(@browser.url).to match(/#profiles\/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}\/config\/policies/)
    end
    it "Maximize the 'SSID Policy' and open the 'Show Advanced' controls" do
      ensure_ssid_policy_opened_and_show_advanced_visible
    end
    it "Verify that the 'WebTitan Content Filtering' switch control is grayed out and has a tooltip upon hovering ('WebTitan must be configured in the Add-On Solutions page to be enabled.'')" do
      web_titan_switch = @ui.get(:checkbox, {css: ".webTitanSwitch input"})
      @ui.css(".webTitanSwitch").hover
      expect(web_titan_switch.set?).to eq(false)

      webtitan_switch = @ui.css('.webTitanSwitch input')
      expect(webtitan_switch.attribute_value("disabled")).to eq("true")

      webtitan_switch = @ui.css('.webTitanSwitch')

      webtitan_switch.hover
      sleep 0.5

      expect(webtitan_switch.attribute_value("class")).to eq("fl_left webTitanSwitch switch ko_tooltip_active")

      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq("WebTitan must be configured in the Add-on Solutions page to be enabled.")
    end
    it "Try to click on the switch control and verify that it is not changed to true" do
      webtitan_switch = @ui.css('.webTitanSwitch')

      webtitan_switch.click
      sleep 1

      expect(@ui.get(:checkbox, {css: ".webTitanSwitch input"}).set?).to eq(false)
    end
    it "Close the profile and don't save the changes" do
      @ui.click('#header_logo')
      sleep 1
      if @ui.css('.dialogOverlay').exists?
        if @ui.css('.dialogOverlay').visible?
          @ui.click('#_jq_dlg_btn_0')
        end
      end
    end
  end
end

shared_examples "go to profile and policies tab" do |profile_name|
  describe "Go to the profile named '#{profile_name}' and then to the Policies tab" do
    it "Go to the profile '#{profile_name}' and then to the policies tab" do
      @ui.goto_profile profile_name
      sleep 2
      @ui.click('#profile_config_tab_policies')
      sleep 1
      expect(@browser.url).to match(/#profiles\/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}\/config\/policies/)
    end
  end
end

shared_examples "addon solutions profile can be set to web titan on if it is configured" do |profile_name|
  describe "Verify that on the profile named '#{profile_name}', the 'WebTitan' content filtering can be properly enabled" do
    it "Go to the profile '#{profile_name}' and then to the policies tab" do
      @ui.goto_profile profile_name
      sleep 2
      @ui.click('#profile_config_tab_policies')
      sleep 1
      expect(@browser.url).to match(/#profiles\/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}\/config\/policies/)
    end
    it "Add the 'SSID Policy' if it's not already available and open the 'Show Advanced' controls" do
      ensure_ssid_policy_opened_and_show_advanced_visible
    end
    it "Verify that the 'WebTitan Content Filtering' switch control is NOT grayed out but that it ise set to 'Off'" do
      expect(@ui.css('.policies-container .policy-type-container:nth-of-type(2) .policiesAdvanced')).to be_visible

      web_titan_switch = @ui.get(:checkbox, {css: ".webTitanSwitch input"})
      @ui.css(".webTitanSwitch").hover
      expect(web_titan_switch.set?).to eq(false)

      webtitan_switch = @ui.css('.webTitanSwitch input')
      expect(webtitan_switch.attribute_value("disabled")).to eq(nil)
    end
    it "Set the 'WebTitan Content Filtering' switch control to 'ON'" do
      ensure_ssid_policy_opened_and_show_advanced_visible

      @ui.css('.webTitanSwitch').click
      sleep 1

      expect(@ui.get(:checkbox, {css: ".webTitanSwitch input"}).set?).to eq(true)
    end
#    it "Expect that 4 policyRules were created in the 'Global Policy' box and that none of them are 'draggable' or 'ui-sortable'" do
#      (1..3).each do |i|
#        expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleNumber").text).to eq("#{i}")
#      end
#      expect(@ui.css(".policiesRulesContainer .policyRule:nth-child(5)")).not_to exist
#      expect(@ui.css(".policiesRulesContainer .policiesRulesDraggableRules.ui-sortable div")).not_to exist
#    end
#    it "Verify that the policy names are 'WebTitan.*' (where * is from 1 to 4) and that the rules are 'READ-ONLY'" do
#      (1..4).each do |i|
#        expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) span:nth-child(3)").attribute_value("class")).to eq("policiesRuleName readonly")
#        expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleName").text).to eq("WebTitan.#{i}")
#      end
#    end
#    it "Expect that the 'policy layer' value is '3' and that the 'Enable / Disable' switch control is grayed out but set to 'Enable'" do
#        (1..4).each do |i|
#          expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleLayer").text).to eq("Layer: 3")
#          expect(@ui.get(:checkbox, {css: ".policiesRulesContainer div:nth-child(#{i}) .policiesRuleEnable.switch .switch_checkbox"}).set?).to eq(true)
#
#          expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleEnable.switch .switch_checkbox").attribute_value("disabled")).to eq("true")
#        end
#    end
#    it "Expect that the 'protocol' is 'TCP' for the 1st and 3rd rules and 'UDP' for the 2nd and 4th rules" do
#        (1..4).each do |i|
#          if i == 1 or i == 3
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleProtocol").text).to eq("Protocol: TCP")
#          else
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleProtocol").text).to eq("Protocol: UDP")
#          end
#        end
#    end
#    it "Expect that the 'source' is 'IP Address' for the 1st and 2nd rules and 'Any' for the 3nd and 4th rules" do
#        (1..4).each do |i|
#          if i == 1 or i == 2
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleSource").text).to eq("Source: IP Address")
#          else
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleSource").text).to eq("Source: Any")
#          end
#        end
#    end
#    it "Expect that the 'destination' is 'IP Address' for the 1st and 2nd rules and 'Any' for the 3nd and 4th rules" do
#        (1..4).each do |i|
#          if i == 1 or i == 2
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleDestination").text).to eq("Dest: IP Address")
#          else
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleDestination").text).to eq("Dest: Any")
#          end
#        end
#    end
#    it "Expect that the 'action' is 'ALLOW' for the 1st and 2nd rules and 'BLOCK' for the 3nd and 4th rules" do
#        (1..4).each do |i|
#          if i == 1 or i == 2
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleAction").text).to eq("Allow/Block: ALLOW")
#          else
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleAction").text).to eq("Allow/Block: BLOCK")
#          end
#        end
#    end
    it "Press the <SAVE ALL> button and refresh the browser" do
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 1
      @browser.refresh
      sleep 2
    end
#    it "Expand the 'Global Policy' and open the 'Show Advanced' controls" do
#      ensure_global_policy_opened_and_show_advanced_visible
#    end
#    it "Verify that none of the above settings were lost" do
#      (1..4).each do |i|
#        expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleNumber").text).to eq("#{i}")
#        expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) span:nth-child(3)").attribute_value("class")).to eq("policiesRuleName readonly")
#        expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleName").text).to eq("WebTitan.#{i}")
#        expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleLayer").text).to eq("Layer: 3")
#        expect(@ui.get(:checkbox, {css: ".policiesRulesContainer div:nth-child(#{i}) .policiesRuleEnable.switch .switch_checkbox"}).set?).to eq(true)
#        expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleEnable.switch .switch_checkbox").attribute_value("disabled")).to eq("true")
#        case i
#          when 1
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleProtocol").text).to eq("Protocol: TCP")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleSource").text).to eq("Source: IP Address")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleDestination").text).to eq("Dest: IP Address")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleAction").text).to eq("Allow/Block: ALLOW")
#          when 2
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleProtocol").text).to eq("Protocol: UDP")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleSource").text).to eq("Source: IP Address")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleDestination").text).to eq("Dest: IP Address")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleAction").text).to eq("Allow/Block: ALLOW")
#          when 3
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleProtocol").text).to eq("Protocol: TCP")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleSource").text).to eq("Source: Any")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleDestination").text).to eq("Dest: Any")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleAction").text).to eq("Allow/Block: BLOCK")
#          when 4
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleProtocol").text).to eq("Protocol: UDP")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleSource").text).to eq("Source: Any")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleDestination").text).to eq("Dest: Any")
#            expect(@ui.css(".policiesRulesContainer div:nth-child(#{i}) .policiesRuleAction").text).to eq("Allow/Block: BLOCK")
#        end
#      end
#        expect(@ui.css(".policiesRulesContainer .policyRule:nth-child(5)")).not_to exist
#        expect(@ui.css(".policiesRulesContainer .policiesRulesDraggableRules.ui-sortable div")).not_to exist
#    end
#    it "Set the 'WebTitan Content Filtering' switch control to 'OFF'" do
#      @ui.css('#policies-global-webTitanChk').click
#      sleep 1
#
#      expect(@ui.get(:checkbox, {id: "policies-global-webTitanChk_switch"}).set?).to eq(false)
#    end
#    it "Verify that there are no policies in the grid" do
#      expect(@ui.css('.policiesRulesContainer .policiesNewRule')).to be_visible
#    end
#    it "Press the <SAVE ALL> button and refresh the browser" do
#      @ui.click('#profile_config_save_btn')
#      sleep 1
#      @browser.refresh
#      sleep 2
#    end
#    it "Expand the 'Global Policy' and open the 'Show Advanced' controls" do
#      ensure_global_policy_opened_and_show_advanced_visible
#    end
#    it "Verify that there are no policies in the grid and that the 'WebTitan Content Filtering' switch control is 'OFF'" do
#      expect(@ui.css('.policiesRulesContainer .policiesNewRule')).to be_visible
#      expect(@ui.get(:checkbox, {id: "policies-global-webTitanChk_switch"}).set?).to eq(false)
#    end
  end
end


shared_examples "addon solutions web titan on profile after maxed out rules per policy" do |profile_name|
  describe "Verify that the 'WebTitan' content filtering responds properly when not having enough rule space to be activated" do
    it "Go to the profile '#{profile_name}' and then to the policies tab" do
      @ui.goto_profile profile_name
      sleep 2
      @ui.click('#profile_config_tab_policies')
      sleep 1
      expect(@browser.url).to match(/#profiles\/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}\/config\/policies/)
    end
    it "Expand the 'Global Policy' and open the 'Show Advanced' controls" do
      ensure_ssid_policy_opened_and_show_advanced_visible
    end
    it "Verify that the 'WebTitan Content Filtering' switch control is grayed out and has a tooltip upon hovering ('WebTitan requires 4 available rule slots in the 25-rule limit.')" do
      web_titan_switch = @ui.get(:checkbox, {css: ".webTitanSwitch input"})
      @ui.css(".webTitanSwitch").hover
      expect(web_titan_switch.set?).to eq(false)

      webtitan_switch = @ui.css('.webTitanSwitch input')
      expect(webtitan_switch.attribute_value("disabled")).to eq("true")

      webtitan_switch = @ui.css('.webTitanSwitch')

      webtitan_switch.hover
      sleep 0.5

      expect(webtitan_switch.attribute_value("class")).to eq("fl_left webTitanSwitch switch ko_tooltip_active")

      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq("WebTitan requires 1 available rule slots in the 25-rule limit.")
    end
    it "Press the <SAVE ALL> button and refresh the browser" do
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 1
      @browser.refresh
      sleep 5
    end
  end
end


###### OLD METHOD TO CREATE PORTALS - NOT TO BE USED ANYMORE
#shared_examples "create portal" do |portal_name, portal_description, portal_type|
#  describe "Create portal" do
#    it "click new portal" do
#      @ui.click('#header_nav_guestportals')
#      sleep 1
#      @ui.click('#header_new_guestportals_btn')
#      sleep 1
#    end
#
#    it "submits new portal modal" do
#        # wait for the modal to show up
#        @ui.id("guestportals_newportal").wait_until_present
#
#        # set portal name
#        @ui.set_input_val("#guestportal_new_name_input", portal_name)
#
#        # set description
#        @ui.set_textarea_val('#guestportal_new_description_input', portal_description)
#
#        @ui.css('.portal_type.guest').hover
#        sleep 1
#        @ui.click('.self_reg')
#    end
#
#    it "goes to new portal config and has portal name and description" do
#        # wait for the portal name to appear
#        pn = @ui.id("profile_name")
#        pn.wait_until_present
#
#        pt = @ui.css('#guestportal_config_general_view .innertab .title')
#        pt.wait_until_present
#
#        expect(@browser.url).to include("/config")
#
#        portal_type_str = ""
#        case portal_type
#          when "self_reg"
#             portal_type_str = "Self-Registration"
#          when "ambassador"
#             portal_type_str = "Guest Ambassador"
#          when "onboarding"
#             portal_type_str = "EasyPass Onboarding"
#          when "voucher"
#             portal_type_str = "EasyPass Voucher"
#        end
#
#        # check portal name, type and description
#        expect(pn.text).to eq(portal_name)
#        expect(@ui.id("profile_description").text).to eq(portal_description)
#        expect(pt.text).to eq("Self-Registration")
#    end
#  end
#end
