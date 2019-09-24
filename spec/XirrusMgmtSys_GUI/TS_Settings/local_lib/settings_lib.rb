require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
def user_accounts_grid_actions(action, email, first_name, last_name, details, priviledges)
  abc = @ui.css('.nssg-paging-count').text

  i = abc.index('of')
  length = abc.length
  number = abc[i + 3, abc.length]
  number2 = number.to_i
  enter_verifications = false
  while (number2 != 0) do
    if action == "verify strings support tools" or action == "invoke support tools" or action == "check support tools"
      if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3) div").text == email)
        enter_verifications = true
      end
    else
      if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3) div span:nth-child(2)").text.strip == email)
        enter_verifications = true
      end
    end
    if enter_verifications == true
        sleep 1
        @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3)").hover
        sleep 1
        if action == "invoke support tools"
          action = "invoke"
        elsif action == "check support tools"
          action = "check"
        end
        case action
          when "invoke"
            @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(1) .nssg-actions-container .nssg-action-invoke").hover
            @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(1) .nssg-actions-container .nssg-action-invoke").click
        #  when "invoke support tools"
        #    @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(1) .nssg-actions-container .nssg-action-invoke").hover
        #    @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(1) .nssg-actions-container .nssg-action-invoke").click
        #    #@ui.css('.nssg-table tbody tr:nth-child(#{number2}) .nssg-actions-container .nssg-action-invoke').click
          when "delete"
            #@ui.css('.nssg-table tbody tr:nth-child(#{number2}) td:nth-child(1) .nssg-actions-container .nssg-action-delete').click
            @ui.css(".nssg-table tbody tr:nth-child(#{number2}) .nssg-actions-container .nssg-action-delete").hover
            @ui.css(".nssg-table tbody tr:nth-child(#{number2}) .nssg-actions-container .nssg-action-delete").click
          when "verify strings"
            expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3) div span:nth-child(2)").text.strip).to eq(email)
            expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(4) div").text).to eq(first_name)
            expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(5) div").text).to eq(last_name)
            expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(6) div").text).to eq(details)
            expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(7) div").text).to eq(priviledges)
          when "verify strings support tools"
            expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3) div").text).to eq(email)
            expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(4) div").text).to eq(first_name)
            expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(5) div").text).to eq(last_name)
            #a = text
            #b = text
            #return [a, b]
          when "check"
            @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(2) .mac_chk_label").click
        end
        sleep 1
        break
    else
      #expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3) div span:nth-child(2)").text.strip).to eq(email)
    end
    number2-=1
    if number2 == 0 and enter_verifications == false
      return false
    end
  end
end

def schedule_firmwareupgrade_days_checker(days_string)
  days_array = days_string.split(", ")
  for i in 0..6
    a = i + 1
    checkbox_checked = @ui.get(:checkbox , {id: "firmwareupgrades-days_day_#{i}"})
    if checkbox_checked.set?
      @ui.click("#firmwareupgrades-days label:nth-of-type(#{a})")
    end
  end
  label_elements = @ui.css('#firmwareupgrades-days').spans
  expect(label_elements.length).to eq(7)
  days_array.each do |day|
    label_elements.each do |span|
      if day.include?span.text
        span.click
        sleep 0.5
      end
    end
  end
end

def go_to_settings_my_account_steps
  if !@browser.url.include?("/#settings/myaccount/")
    @ui.click('#header_nav_user')
    sleep 2
    @ui.css('#header_settings_link').wait_until_present
    @ui.click('#header_settings_link')
    sleep 1
    @ui.click('#settings_tab_myaccount')
    sleep 1
  end
end

def go_to_settings_my_account
  it "Go to the MyAccount area of Settings" do
    go_to_settings_my_account_steps
  end
end

def go_to_settings_my_account_method
  go_to_settings_my_account_steps
end

shared_examples "go to settings then to tab" do |tab|
  describe "Open the user dropdown list and go to the Settings area then navigate to the proper tab" do
    it "Go to the Settings area then to the '#{tab.upcase}' tab" do
      sleep 1
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_settings_link')
      sleep 1
      case tab
        when "My Account"
          tab_id_path = "#settings_tab_myaccount"
          verify_url = "/#settings/myaccount"
        when "User Accounts"
          tab_id_path = "#settings_tab_useraccounts"
          verify_url = "/#settings/useraccounts"
        when "Provider Management"
          tab_id_path = "#settings_tab_mobileproviders"
          verify_url = "/#settings/mobileproviders"
        when "Add-On Solutions"
          tab_id_path = "#settings_tab_addonsolutions"
          verify_url = "/#settings/addonsolutions"
        when "Firmware Upgrades"
          tab_id_path = "#settings_tab_firmwareupgrades"
          verify_url = "/#settings/firmwareupgrades"
        when "Command Center"
          tab_id_path = "#settings_tab_commandcenter"
          verify_url = "/#settings/commandcenter"
        when "System"
          tab_id_path = "#settings_tab_system"
          verify_url = "/#settings/system"
      end
      @ui.click(tab_id_path)
      sleep 2
      if tab == "User Accounts" or tab == "Provider Management"
        if tab == "User Accounts" and @ui.css('.nssg-paging-selector-container').exists? != false
          @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "50")
        end
      end
      @browser.execute_script('$("#suggestion_box").hide()')
      expect(@browser.url).to include(verify_url)
    end
  end
end

shared_examples "verify upgrade types" do
  describe "verify upgrade types" do
    it "verify upgrade drop-down options Auto and Manual" do
      expect(@ui.css(".firmwareupgrades-upgrade-types").text).to eq("Upgrade Type:")
      @ui.css(".firmwareupgradesmanual .top-box .infoBtn").hover
      expect(@ui.css('.ko_tooltip .ko_tooltip_content').text).to eq("Choose how you would like to get updates for your network devices:
Automatic Updates – latest Mainline or Technology releases will be automatically installed on your devices.
Manual Updates – select newly released software and schedule its installation on your devices")
      @ui.css("#settings_view .ko_dropdownlist_button").click
      expect(@ui.css(".ko_dropdownlist_list.active ul li:nth-child(1)").text).to eq("Automatic Upgrades")
      expect(@ui.css(".ko_dropdownlist_list.active ul li:nth-child(2)").text).to eq("Manual Upgrades")
      @ui.css("#ko_dropdownlist_overlay").click
    end
  end
end

shared_examples "verify manual upgrade preference" do
  describe "verify manual upgrade preference" do
    it "select manual upgrade type" do
      @ui.set_dropdown_entry_by_path("#settings_view .ko_dropdownlist", "Manual Upgrades")
      sleep 1
    end 
    it "verify mannual upgrade prefernces" do
      expect(@ui.css(".firmwareupgrades-fields .field_heading").text).to eq("Manual Upgrade Preferences")
      expect(@ui.css(".firmwareupgrades-fields .field_subheading").text).to eq("Please select how and when you would like your upgrades to occur.")
      expect(@ui.get(:checkbox, {css: "#firmwareupgrades-optimizationtype_switch"}).set?).to eq(true)
      expect(@ui.css("#firmwareupgrades-usedefault")).to be_present
      @ui.css(".firmwareupgrades-upgradeoptimizationtype .infoBtn").hover
      expect(@ui.css('.ko_tooltip .ko_tooltip_content').text).to eq("Choose between completing firmware upgrades in the shortest amount of time or with minimal network disruption:
Speed — All APs will reboot upon completing upgrade.
Uptime — Only 1 AP reboots at a time (per profile) to complete its upgrade.")
      sleep 1
    end   
    it "verify manual-region for firmwares" do
      devices = @browser.elements(css: "#manual-region .mtogglebox")
      devices.each do |device|
        expect(device.element(css: ".device-type-label:nth-child(1)").text).to eq("Current Version:")
        expect(device.element(css: ".device-type-label:nth-child(2)").text).to eq("Versions Available:")
      end
    end
  end
end
shared_examples "edit description field" do |description_text|
  describe "Edit the description field to the value '#{description_text}'" do
    it "Set the value '#{description_text}'" do
      @ui.set_textarea_val("#myaccount_description", description_text)
      sleep 2
      @ui.click('#settings_myaccount .commonTitle')
      sleep 1
      expect(@ui.get(:textarea , {id: "myaccount_description"}).value).to eq(description_text)
    end
  end
end

shared_examples "verify system data retention" do
  describe "verify system data retention" do
    it "verify system general tab features" do
      expect(@ui.css("#settings_general_container .system-tab .commonTitle").text).to eq("System")
      expect(@ui.css("#settings_general_container .system-tab .commonSubtitle").text).to eq("Adjust your system settings")
    end
    it "verify system- resention general features" do
      expect(@ui.css(".retention-section .commonTitle").text).to eq("Data Retention")
      expect(@ui.css(".retention-section .commonSubtitle").text).to eq("Would you like to add a setting for data retention?")
      expect(@ui.get(:checkbox, {css: ".retention-section .switch_checkbox"}).set?).to eq(false)
    end
    it "verify system- resention general Policy period" do
      if !@ui.get(:checkbox, {css: ".retention-section .switch_checkbox"}).set?
        @ui.css(".retention-section .switch_label").click
        sleep 1
      end
      @ui.css(".retention-section .ko_dropdownlist_button").click
      sleep 1
      expect(@ui.css(".ko_dropdownlist_list.active ul li:nth-child(2) span").attribute_value("title")).to eq("Delete data older than 7 days")
      expect(@ui.css(".ko_dropdownlist_list.active ul li:nth-child(3) span").attribute_value("title")).to eq("Delete data older than 30 days")
      expect(@ui.css(".ko_dropdownlist_list.active ul li:nth-child(4) span").attribute_value("title")).to eq("Delete data older than 6 months") 
      expect(@ui.css(".ko_dropdownlist_list.active ul li:nth-child(5) span").attribute_value("title")).to eq("Delete data older than one year")
    end
  end
end

def notifications_use_default_settings(yes_no)
  expect(@ui.css('#has_global')).to be_present
  default_switch_switch = @ui.get(:checkbox , {id: "has_global_switch"})
  if default_switch_switch.set? != true and yes_no == "Yes"
    @ui.click('#has_global .switch_label') and sleep 1
    expect(@ui.get(:checkbox , {id: "has_global_switch"}).set?).to eq(true)
  elsif default_switch_switch.set? != false and yes_no == "No"
    @ui.click('#has_global .switch_label') and sleep 1
    expect(@ui.get(:checkbox , {id: "has_global_switch"}).set?).to eq(false)
  end
end

def checkboxes_actions(alert_name, alert_type, checkbox_action)
  checkboxes = Hash[
    "Email" => Hash[
      "Access Point lost connectivity" => ".alertsTable .row:nth-child(2) .cell:nth-child(2) input", 
      "Profile Access Point lost connectivity" => ".alertsTable .row:nth-child(3) .cell:nth-child(2) input", 
      "Station Count" => ".alertsTable .row:nth-child(4) .cell:nth-child(2) input", 
      "DHCP Failure" => ".alertsTable .row:nth-child(5) .cell:nth-child(2) input", 
      "Channel Interference" => ".alertsTable .row:nth-child(6) .cell:nth-child(2) input", 
      "System Maintenance" => ".subscriptionsTable .row:nth-child(2) .cell:nth-child(2) input", 
      "Expiring XMS License on Access Point" => ".subscriptionsTable .row:nth-child(3) .cell:nth-child(2) input", 
      "Expiring EasyPass" => ".subscriptionsTable .row:nth-child(4) .cell:nth-child(2) input"], 
    "SMS" => Hash[
      "Access Point lost connectivity" => ".alertsTable .row:nth-child(2) .cell:nth-child(3) input", 
      "Profile Access Point lost connectivity" => ".alertsTable .row:nth-child(3) .cell:nth-child(3) input", 
      "Station Count" => ".alertsTable .row:nth-child(4) .cell:nth-child(3) input", 
      "DHCP Failure" => ".alertsTable .row:nth-child(5) .cell:nth-child(3) input", 
      "Channel Interference" => ".alertsTable .row:nth-child(6) .cell:nth-child(3) input"]
    ]
  alert_type_hash = checkboxes[alert_type] and alert_css = alert_type_hash[alert_name]
  checkbox = @ui.get(:checkbox , {css: alert_css})
  if checkbox_action == "Check"
    bool = true
  elsif checkbox_action == "Uncheck"
    bool = false
  end
  if checkbox.set? != bool
    @ui.click(alert_css + " + .mac_chk_label") and sleep 1
  end
  expect(@ui.get(:checkbox , {css: alert_css}).set?).to eq(bool)
end

shared_examples "use notifications default settings" do |yes_no|
  it_behaves_like "go to settings then to tab", "My Account"
  describe "Set the My Account, Notifications settings switch to '#{yes_no}'" do
    it "Set the Notifications settings default to '#{yes_no}'" do
      notifications_use_default_settings(yes_no)
    end
  end
end

shared_examples "verify notifications default settings domains" do |yes_no, domain_name|
  it_behaves_like "go to settings then to tab", "My Account"
  describe "Verify that the Notifications toggle box shows (#{yes_no}) the domain '#{domain_name}'" do
    it "Ensure that the tag controller shows the domain '#{domain_name}'" do
      notifications_togglebox = @ui.css('#has_global').parent
      expect(notifications_togglebox.element(:css => ".alerts_global .note").text).to eq("The following accounts are using overrides and may have different notification settings:")
      notifications_togglebox_tags = notifications_togglebox.elements(:css => ".tagControlContainer .tag")
      expect(notifications_togglebox_tags.length).to be >= 1
      notifications_togglebox_tags.each do |notifications_togglebox_tag|
        if yes_no == "Yes"
          if notifications_togglebox_tag.element(:css => ".text").text == domain_name
            expect(notifications_togglebox_tag.element(:css => ".text").text).to eq(domain_name)
          end
        elsif yes_no == "No"
          expect(notifications_togglebox_tag.element(:css => ".text").text).not_to eq(domain_name)
        end
      end
    end
  end
end

shared_examples "tick certain checkbox on my account" do |alert_name, alert_type, value|
  it_behaves_like "go to settings then to tab", "My Account"
  describe "Tick the checkbox for '#{alert_name}' of type '#{alert_type}' and verify it " do
    it "Find the checkbox and place a tick for it" do
      checkboxes_actions(alert_name, alert_type, value)
    end
    it "Verify the checkbox has the value '#{value}'" do
      checkboxes_actions(alert_name, alert_type, value)
    end
  end
end

shared_examples "edit and confirm field" do |field, field_type, field_id, edit_value|
  describe "edit and confirm field" do
    it "edit and confirm field" do
        puts 'edit and confirm ' + field

        i = @ui.get(field_type, { id: field_id })
        i.wait_until_present
        val = i.value

        i.set edit_value
        sleep 1
        @ui.click('#settings_myaccount .commonTitle')
        sleep 4
        expect(i.value).to eq(edit_value)

        #reset
        i.set val
        @ui.click('#settings_myaccount .commonTitle')
        sleep 4
        expect(i.value).to eq(val)
    end
  end
end

shared_examples "test my account basic settings" do
  describe "test my account basic settings" do
    go_to_settings_my_account
    it_behaves_like "edit and confirm field", 'first name', :text_field, 'myaccount_myaccountfirstname', 'first name edited'
    it_behaves_like "edit and confirm field", 'last name', :text_field,'myaccount_myaccountlastname', 'last name edited'
    it_behaves_like "edit and confirm field", 'description', :textarea, 'myaccount_description', 'description edited'
    #it_behaves_like "edit and confirm field", 'email', :text_field, 'myaccount_myaccountname', 'editemail@xirrus.com'
    it_behaves_like "edit and confirm field", 'mobile', :text_field, 'myaccount_mobile_number', '1234567890'
  end
end

shared_examples "test my account specific notification" do |notifications_global, alert_name, alert_type, checkbox_action|
  describe "Set the 'Global Notifications' and a certain alert type" do
    go_to_settings_my_account
    it "Set 'Global Notifications' to '#{notifications_global}', the alert named '#{alert_name}' should be '#{checkbox_action}' for the type '#{alert_type}'" do
      notifications_use_default_settings(notifications_global)
      checkboxes_actions(alert_name, alert_type, checkbox_action)
    end
  end
end

shared_examples "test my account specific subscription" do |subscription_name, subscription_type, checkbox_action|
  describe "Set the 'Subscriptions' and a certain subscription type" do
    go_to_settings_my_account
    it "Set 'Subscription' named '#{subscription_name}' should be '#{checkbox_action}' for the type '#{subscription_type}'" do
      checkboxes_actions(subscription_name, subscription_type, checkbox_action)
    end
  end
end

shared_examples "ensure no checkboxes are ticked" do
  describe "Ensure that none of the checkboxes for alerts are ticked on the Settings -> My account area" do
    it "Go trough all the checkboxes and verify non are ticked" do
        for alert_name in ["Access Point lost connectivity", "Profile Access Point lost connectivity", "Station Count", "DHCP Failure", "Channel Interference"] do
          for alert_type in ["Email","SMS"] do
            checkboxes_actions(alert_name, alert_type, "Uncheck")
          end
        end
        alerts = @ui.css('.alertsTable')
        cbs = alerts.checkboxes
        checked = 0
        cbs.each { |cb|
          if(cb.set?)
            checked = checked + 1
          end
        }
        expect(checked).to eq(0)
        @browser.refresh
        sleep 8
    end
  end
end

shared_examples "test my account notification settings" do
  describe "test my account notification settings" do
    go_to_settings_my_account
    it "Check all notification checkboxes (from Settings)" do
        alerts = @ui.css('.alertsTable')
        chks = alerts.labels(:css => '.mac_chk_label')
        cbs = alerts.checkboxes
        chks.each_with_index { |chk, index|
          if !cbs[index].set?
            chk.click
            sleep 3
          end         
        }
        cbs = alerts.checkboxes
        checked = 0
        cbs.each { |cb|
          if(cb.set?)
              checked = checked + 1
          end
        }
        expect(chks.length).to eq(checked)
    end
    it "Uncheck all notification checkboxes (from Settings)" do
        alerts = @ui.css('.alertsTable')
        chks = alerts.labels(:css => '.mac_chk_label')
        chks.each { |chk|
            chk.click
            sleep 3
        }
        cbs = alerts.checkboxes
        checked = 0
        cbs.each { |cb|
          if(cb.set?)
              checked = checked + 1
          end
        }
        expect(checked).to eq(0)
    end
    it "Hover over each '.infoBtn' and verify the proper description is displayed" do
      alerts = @ui.css('.alertsTable')
      info_btns = alerts.divs(:css => '.infoBtn')
      verify_hash = Hash[0 => "This alert is opened when an Access Point goes offline due to any reason (powered off, network connection lost etc) and closed when the Access Point comes back online", 1 => "This alert is opened when all the Access Points in any profile go offline and is closed when at least one Access Point in that same profile is back online", 2 => "This is a proactive alert that is opened when the total number of clients on an Access Point exceed 30*(number of radios on the Access Point) and is closed when the total number of clients on the same Access Point fall below 20*(number of radios on the Access Point)", 3 => "This alert is opened when a client is stuck with a 169.254.x.y IP address", 4 => "This alert will be sent when an access point can hear another device that might be using the same channels"]
      info_btns.each_with_index { |info_btn, i|
        info_btn.hover
        sleep 1
        expect(@ui.css('.ko_tooltip .ko_tooltip_content').text).to eq(verify_hash[i])
      }
    end
  end
end

shared_examples "test user account general settings - add user" do |first_name, last_name, email, details, xms_role, backoffice_role|
  it_behaves_like "go to settings then to tab", "User Accounts"
  describe "Test the area: USER ACCOUNTS from SETTINGS - Add a new user" do
    it "Add the user with the following values: first_name = #{first_name} /// last_name = #{last_name} /// email = #{email}" do
        @browser.execute_script('$("#suggestion_box").hide()')
        @ui.click('#useraccounts_newuser_btn')
        sleep 0.5
        @ui.set_input_val('#usermodal_firstname',first_name)
        sleep 0.5
        @ui.set_input_val('#usermodal_lastname',last_name)
        sleep 0.5
        @ui.set_input_val('#usermodal_email',email)
        sleep 0.5
        @ui.set_input_val('#usermodal_details', details)
        sleep 0.5
        @ui.set_dropdown_entry('ddl_XMS', xms_role)
        sleep 0.5
        @ui.set_dropdown_entry('ddl_BACKOFFICE', backoffice_role)
    end
    it "Save the user" do
        @ui.click('#users_modal_save_btn')
        sleep 3
        expect(@ui.css('.tabpanel_slideout.left.opened')).not_to exist
    end
    it "Verify that the user is properly created and has the values: " do
        sleep 0.5
        user_accounts_grid_actions("verify strings",email, first_name, last_name,details,"XMS #{xms_role}, Backoffice #{backoffice_role}")
    end
  end
end

shared_examples "test user account general settings - edit user" do |original_first_name, first_name, original_last_name, last_name, original_email, email, original_details, details, original_xms_role, xms_role, original_backoffice_role, backoffice_role|
  it_behaves_like "go to settings then to tab", "User Accounts"
  describe "Test the area: USER ACCOUNTS from SETTINGS - Edit an existing user" do
    it "Open the user's slideout window (#{original_email}) and edit the user name to '#{first_name}'" do
        @browser.execute_script('$("#suggestion_box").hide()')
        user_accounts_grid_actions("invoke",original_email,"","","","")
        sleep 1
        @ui.set_input_val('#usermodal_firstname',first_name)
        sleep 1
        @ui.click('#users_modal_save_btn')
        sleep 2
        @browser.refresh
        sleep 4
        @ui.css('.nssg-table tbody tr:nth-child(1)').wait_until_present
        @ui.css('.nssg-table tbody tr:nth-child(1)').hover
        user_accounts_grid_actions("verify strings", original_email, first_name, original_last_name, original_details, "XMS #{original_xms_role}, Backoffice #{original_backoffice_role}")
    end
    it "Edit the user and set email to '#{email}', details to '#{details}' and permissions to 'XMS #{xms_role}'" do
        @browser.execute_script('$("#suggestion_box").hide()')
        @ui.click('#settings_tab_myaccount')
        sleep 1
        @ui.click('#settings_tab_useraccounts')
        sleep 1
        user_accounts_grid_actions("invoke",original_email,"","","","")
        sleep 1
        @ui.set_input_val('#usermodal_email',email)
        sleep 1
        @ui.click("#usermodal_details")
        @ui.set_input_val("#usermodal_details", details)
        sleep 1
        @ui.set_dropdown_entry('ddl_XMS', xms_role)
        sleep 2
        @ui.click('#users_modal_save_btn')
        sleep 2
        @browser.refresh
        sleep 4
        @ui.css('.nssg-table tbody').wait_until_present
        user_accounts_grid_actions("verify strings", email, first_name, original_last_name, details, "Backoffice #{original_backoffice_role}, XMS #{xms_role}")
    end
  end
end

shared_examples "create several user accounts" do |number_of_users, xms_priviledge, cloud_priviledge, is_read_only|
  it_behaves_like "go to settings then to tab", "User Accounts"
  describe "create #{number_of_users} user accounts with random values, priviledges: XMS #{xms_priviledge} and Cloud #{cloud_priviledge} + Read Only  is #{is_read_only}" do
    it "Set the view per page to '1000' entries" do
      @ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
      @ui.ul_list_select_by_string('.ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul', "1000")
    end
    it "Get the grid length" do
      @ui.get_grid_length
      $grid_length_before = $grid_length
    end
    it "Create #{number_of_users} accounts" do
      @browser.execute_script('$("#suggestion_box").hide()')
      a = 1
      while (a<=number_of_users) do
        $usrFName = UTIL.random_title.downcase
        $usrLName = UTIL.random_title.downcase
        $usrDesc = UTIL.random_title.upcase
        $usrEmail = UTIL.random_title.downcase + "@test.com"
        @ui.click('#useraccounts_newuser_btn')
        sleep 2
        @ui.set_input_val('#usermodal_firstname',$usrFName)
        sleep 1
        @ui.set_input_val('#usermodal_lastname',$usrLName)
        sleep 1
        @ui.set_input_val('#usermodal_details', $usrDesc)
        sleep 1
        @ui.set_input_val('#usermodal_email',$usrEmail)
        sleep 2
        @ui.click('.ko_slideout_container.opened .slideout_icon')
        sleep 1
        if @ui.css('#ddl_XMS .text').text != xms_priviledge
          @ui.set_dropdown_entry('ddl_XMS', xms_priviledge)
          sleep 1
        end
        @ui.click('.ko_slideout_container.opened .slideout_icon')
        sleep 1
        if @ui.css('#ddl_BACKOFFICE .text').text != cloud_priviledge
          @ui.set_dropdown_entry('ddl_BACKOFFICE', cloud_priviledge)
          sleep 1
        end
        #removed guest ambassador radio button added into drop-down list
        # if (is_read_only == true)
          #  @ui.click('#settings_useraccounts_ambassador_Switch .switch_label') 
        # end
        sleep 1
        @ui.click('#users_modal_save_btn')
        sleep 1
        a+=1
      end
      @browser.refresh
      sleep 4
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

shared_examples "delete all user accounts" do |lastname_not_to_del|
  it_behaves_like "go to settings then to tab", "User Accounts"
  describe "delete all user accounts except the one with the last name: #{lastname_not_to_del}" do
    it "Set the view per page to '1000' entries" do
      @ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
      @ui.ul_list_select_by_string('.ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul', "1000")
    end
    it "Delete all User Accounts except from #{lastname_not_to_del} (last name)" do
      abc = @ui.css('.nssg-paging-count').text

      i = abc.index('of')
      length = abc.length
      number = abc[i + 3, abc.length]
      number2 = number.to_i

      while (number2 != 0) do
        if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(5)").text.strip == lastname_not_to_del)
        else
            sleep 1
            @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3)").hover
            sleep 1
            @ui.css(".nssg-table tbody tr:nth-child(#{number2}) .nssg-actions-container .nssg-action-delete").click
            sleep 1
            @ui.click('#_jq_dlg_btn_1')
            sleep 4
            @ui.click('#settings_tab_useraccounts')
            sleep 1
        end
        number2-=1
      end
    end
    it "Set the view per page to '10' entries" do
      @ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
      @ui.ul_list_select_by_string('.ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul', "10")
    end
  end
end

def refresh_mobile_providers_grid
  @ui.click('.nssg-refresh')
  sleep 0.2
  if @ui.css('#mobileproviders_grid grid .nssg-wrap.isLoading').exists?
    while @ui.css('#mobileproviders_grid grid .nssg-wrap').attribute_value("class").include? "isLoading"
      sleep 1
    end
  end
end

shared_examples "add mobile provider" do |provider_name, provider_domain, provider_country, provider_prefix, provider_suffix|
  describe "Test the 'Provider Management' area - Add a new mobile provider" do
    it "Add the provider named '#{provider_name}'" do
      @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000")
      sleep 1
      @ui.click('#mobileproviders_custom_btn')
      sleep 1
      @ui.set_input_val('#mobileproviders_provider', provider_name)
      sleep 1
      @ui.set_input_val('#mobileproviders_domain', provider_domain)
      sleep 1
      @ui.set_dropdown_entry('mobileproviders_modal_country', provider_country)
      sleep 1
      @ui.set_input_val('#mobileproviders_prefix', provider_prefix)
      sleep 1
      @ui.set_input_val('#mobileproviders_suffix', provider_suffix)
      sleep 1
      @ui.click('.ko_slideout_content .save')
      sleep 4
      if(@ui.css('#guestdetails_close_btn').visible?)
        @ui.css('#guestdetails_close_btn').click
      end
      #puts Time.now
      #expect(@ui.grid_verify_strig_value_on_specific_line(3, provider_name, "div", 5, "div", provider_country)).to eq(provider_country)
      #expect(@ui.grid_verify_strig_value_on_specific_line(3, provider_name, "div", 4, "div", provider_prefix + "xxxxxxxxxx" + provider_suffix + "@" + provider_domain)).to eq(provider_prefix + "xxxxxxxxxx" + provider_suffix + "@" + provider_domain)
      puts Time.now
      provider_names = @ui.get(:elements , {css: ".nssg-table tbody tr .provider div"})
      countries = @ui.get(:elements , {css: ".nssg-table tbody tr .country div"})
      provider_sms_addresses = @ui.get(:elements , {css: ".nssg-table tbody tr .gateway div"})
      provider_names.each {|provider_name_element| if provider_name_element.text == provider_name then @provider_name_element = provider_name_element and break end}
      provider_index = provider_names.find_index(@provider_name_element)
      expect(countries[provider_index].text).to eq(provider_country)
      expect(provider_sms_addresses[provider_index].text).to eq(provider_prefix + "xxxxxxxxxx" + provider_suffix + "@" + provider_domain)
      puts Time.now
    end
  end
end

shared_examples "deactivate all mobile providers" do
  describe "Use the 'Deactivate All' link in the Provider Management tab" do
    it "Click on the 'Deactivate All' link" do
      @ui.click('#mobileproviders_grid .push-down a') and sleep 1
    end
    it "Verify the modal features and press the 'DEACTIVATE' button" do
      expect(@ui.css('.confirm .title span').text).to eq("Deactivate All Providers?")
      expect(@ui.css('.confirm .msgbody div').text).to eq("Are you sure you want to deactivate all providers?")
      expect(@ui.css('#_jq_dlg_btn_0').text).to eq("Cancel")
      expect(@ui.css('#_jq_dlg_btn_1').text).to eq("DEACTIVATE")
    end
    it "Verify the modal is closed" do
      @ui.click('#_jq_dlg_btn_1')
      @ui.css('.confirm').wait_while_present
    end
    it "Verify the grid shows all providers deactivated" do
      @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000") and sleep 2
      expect(@ui.css('.xc-icon-nssg-providers-activated')).not_to exist
      expect(@ui.css('.nssg-table tbody').trs.length).to eq(@ui.get(:elements , {css: ".xc-icon-nssg-providers-not_activated"}).length)
    end
  end
end

shared_examples "enable mobile provider" do |provider_name|
  describe "Enable the mobile provider named '#{provider_name}'" do
    it "Search for the provider in the grid, hover over it and click the activation context button" do
      @ui.grid_action_on_specific_line(3, "div", provider_name, "activate_provider")
      sleep 2
      @ui.grid_verify_icon_on_provider(3, "div", provider_name, 2, "div", "xc-icon-nssg-providers-activated")
      expect($expected_icon_class).to eq("xc-icon xc-icon-nssg-providers-activated")
    end
  end
end

shared_examples "disable mobile provider" do |provider_name|
  describe "Disable the mobile provider named '#{provider_name}'" do
    it "Search for the provider in the grid, hover over it and click the deactivation context button" do
      @ui.grid_action_on_specific_line(3, "div", provider_name, "deactivate_provider")
      sleep 2
      @ui.grid_verify_icon_on_provider(3, "div", provider_name, 2, "div", "xc-icon-nssg-providers-not_activated")
      expect($expected_icon_class).to eq("xc-icon xc-icon-nssg-providers-not_activated")
    end
  end
end

shared_examples "edit certain mobile provider" do |provider_name, provider_name_new, provider_domain, provider_country, provider_prefix, provider_suffix|
  describe "Edit the provider named '#{provider_name}' with the new values as: '#{provider_name_new}', '#{provider_domain}', '#{provider_country}', '#{provider_prefix}', '#{provider_suffix}'" do
    it "Edit all provider settings named above" do
      @browser.execute_script('$("#suggestion_box").hide()')
      @ui.grid_action_on_specific_line(3, "div", provider_name, "invoke")
      sleep 1
      if provider_name_new != ""
        provider_name = provider_name_new
        @ui.set_input_val('#mobileproviders_provider', provider_name)
        sleep 1
      end
      if provider_domain != ""
        @ui.set_input_val('#mobileproviders_domain', provider_domain)
        sleep 1
      else
        provider_domain = @ui.get(:input , {id: 'mobileproviders_domain'}).value
      end
      if provider_country != ""
        @ui.click('.slideout_title .commonTitle')
        sleep 0.5
        @ui.set_dropdown_entry('mobileproviders_modal_country', provider_country)
        sleep 1
      else
        provider_country = @ui.get(:span ,{css: '#mobileproviders_modal_country a .text'}).text
      end
      if provider_prefix != ""
        @ui.set_input_val('#mobileproviders_prefix', provider_prefix)
        sleep 1
      else
        provider_prefix = @ui.get(:input, {id: 'mobileproviders_prefix'}).value
      end
      if provider_suffix != ""
        @ui.set_input_val('#mobileproviders_suffix', provider_suffix)
        sleep 1
      else
        provider_suffix = @ui.get(:input, {id: 'mobileproviders_suffix'}).value
      end
      @ui.click('.ko_slideout_content .save')
      sleep 4
      if(@ui.css('#guestdetails_close_btn').visible?)
        @ui.css('#guestdetails_close_btn').click
      end
      $grid_length = nil
      @browser.execute_script('$("#suggestion_box").show()')
      expect(@ui.grid_verify_strig_value_on_specific_line(3, provider_name, "div", 5, "div", provider_country)).to eq(provider_country)
      expect(@ui.grid_verify_strig_value_on_specific_line(3, provider_name, "div", 4, "div", provider_prefix + "xxxxxxxxxx" + provider_suffix + "@" + provider_domain)).to eq(provider_prefix + "xxxxxxxxxx" + provider_suffix + "@" + provider_domain)
    end
  end
end

shared_examples "delete mobile provider" do |provider_name|
  describe "Delete the mobile provider named '#{provider_name}'" do
    it "Delete the provider" do
      refresh_mobile_providers_grid
      puts Time.now
      provider_names = @ui.get(:elements , {css: ".nssg-table tbody tr .provider div"})
      provider_names.each {|provider_name_element| if provider_name_element.text == provider_name then @provider_name_element = provider_name_element and break end}
      provider_index = provider_names.find_index(@provider_name_element) + 1
      @ui.css(".nssg-table tbody tr:nth-child(#{provider_index}) .provider div").hover
      @ui.click(".nssg-table tbody tr:nth-child(#{provider_index}) .nssg-td-actions .nssg-action-delete")
      puts Time.now
      #puts Time.now
      #@ui.grid_action_on_specific_line(3, "div", provider_name, "delete")
      #puts Time.now
      sleep 2
      expect(@ui.css('.dialogOverlay.confirm')).to be_present
      sleep 0.5
      @ui.click('#_jq_dlg_btn_1')
      sleep 2
      @ui.click('#mobileproviders_view .top .commonTitle')
     # @ui.grid_verify_strig_value_on_specific_line(3, provider_name, "div", 3, "div", provider_name)
     # expect($search_failed_booleand).to eq(false)
      puts "---"
      puts Time.now
      provider_names = @ui.get(:elements , {css: ".nssg-table tbody tr .provider div"})
      provider_names.each {|provider_name_element| if provider_name_element.text == provider_name then expect("NOT FOUND").to include(provider_name_element) and break end}
      puts Time.now
    end
  end
end

shared_examples "configure ssid for airwatch" do |profile_name|
  describe "configure ssid for airwatch" do
    it "configure ssid for airwatch" do
      @ui.goto_profile profile_name
      sleep 3
      @ui.click('#profile_config_tab_ssids')
      sleep 1

      tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
      tr.wait_until_present
      tr.click

      @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(8) span')

      #dd = @ui.css('.nssg-table_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
      #dd.wait_until_present
      #@ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'AirWatch')
      #sleep 1

      @ui.ul_list_select_by_string('.ko_dropdownlist_list.active', "AirWatch")

      @ui.click("#profile_config_ssids_view .commonTitle")
      sleep 2

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      cp = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(8) div')
      cp.wait_until_present
      expect(cp.title).to eq('AirWatch')
    end
  end
end

shared_examples "confirm ssid is not airwatch" do |profile_name|
  describe "confirm ssid is not airwatch" do
    it "Go to the profile named #{profile_name}" do
      @ui.goto_profile profile_name
      sleep 1
    end
    it "Open the SSIDs tab" do
      @ui.click('#profile_config_tab_ssids')
      sleep 1
    end
    it "confirm ssid is not airwatch" do
      cp = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(8) div')
      cp.wait_until_present
      expect(cp.title).to eq('None')
    end
  end
end

shared_examples "go to airwatch directy from the ssid grid" do |profile_name|
  describe "Go to the Add-on Solutions area directly from the SSIDs grid" do
    it "Go to the profile named #{profile_name}" do
      @ui.goto_profile profile_name
      sleep 1
    end
    it "Open the SSIDs tab" do
      @ui.click('#profile_config_tab_ssids')
      sleep 1
    end
    it "Open the Access Control dropdown" do
      @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(8)').click
      sleep 1
      cp = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(8) span a .arrow')
      cp.wait_until_present
      cp.click
    end
    it "Hover over the option 'AirWatch" do
      sleep 0.5
      list_path = @ui.css(".ko_dropdownlist_list.active ul")
      list_path.wait_until_present
      li = list_path.lis.select{|li| li.visible?}[1]
      li.wait_until_present
      li.hover
      li = list_path.lis.select{|li| li.visible?}[2]
      li.wait_until_present
      li.hover
      li = list_path.lis.select{|li| li.visible?}[0]
      li.wait_until_present
      li.hover
      sleep 0.5
      @ui.css('#copyright').hover
      sleep 0.5
      li = list_path.lis.select{|li| li.visible?}[2]
      li.wait_until_present
      li.hover
      sleep 3
    end
    it "Expect that the tooltip is displayed" do
      expect(@ui.css('#ko_tooltip')).to be_visible
      sleep 0.5
      @ui.css('#ko_tooltip .ko_tooltip_content a').hover
      sleep 0.5
      @ui.css('#ko_tooltip .ko_tooltip_content a').click
      sleep 2
    end
    it "Verify that the location is Add-On Solutions" do
      expect(@browser.url).to include("/#settings/addonsolutions")
      expect(@ui.css('#settings-addonsolutions')).to exist
      expect(@ui.css('#settings-addonsolutions')).to be_visible
    end
  end
end

shared_examples "test add-on solutions settings" do |url , key , username , password|
  it_behaves_like "go to settings then to tab", "Add-On Solutions"
  describe "test add-on solutions settings" do
    it "Verify that the 'AirWatch MDM' list is expanded" do
      airwatch_whitebox = @ui.css('.saos-ul li:first-child .saos-li-top')
      airwatch_whitebox.wait_until_present
      if(airwatch_whitebox.attribute_value("class")!="saos-li-top expanded")
          airwatch_whitebox.click
      end
      sleep 1
    end
    it "Set the following values to the input fields: (API URL) '#{url}' ; (API Key) '#{key}' ; (UserName) '#{username}' ; (Pass + Confirm Pass) '#{password}' ; (Redirect URL) '#{url}' " do
      @ui.set_input_val('#saos-api-url', url)
      sleep 1
      @ui.set_input_val('#saos-api-key', key)
      sleep 1
      @ui.set_input_val('#saos-api-username', username)
      sleep 1
      @ui.set_input_val('#saos-api-password', password)
      sleep 1
      @ui.set_input_val('#saos-api-password-verify', password)
      sleep 1
      @ui.set_input_val('#saos-redirect-url', url)
      sleep 2

      @ui.click('.saos-save-btn')
      sleep 0.5
      #if(url == "")
      #  sleep 1
      #  @ui.confirm_dialog
      #end
      if @ui.css(".dialogOverlay.confirm").exists?
        if @ui.css(".dialogOverlay.confirm").visible?
          @ui.click("#_jq_dlg_btn_1")
        end
      end

    end
    it "Refresh the browser and if the 'AirWatch MDM' list is not expanded, expand it" do
      sleep 6
      @browser.refresh
      sleep 4
      airwatch_whitebox = @ui.css('.saos-ul li:first-child .saos-li-top')
      airwatch_whitebox.wait_until_present
      if(airwatch_whitebox.attribute_value("class")!="saos-li-top expanded")
          airwatch_whitebox.click
      end
      sleep 1
    end
    it "Verify the (API URL) '#{url}' ; (API Key) '#{key}' ; (UserName) '#{username}' ; (Pass + Confirm Pass) '#{password}' ; (Redirect URL) '#{url}' " do
      expect(@ui.get(:text_field, {id: 'saos-api-url' }).value).to eq(url)
      expect(@ui.get(:text_field, {id: 'saos-api-key' }).value).to eq(key)
      expect(@ui.get(:text_field, {id: 'saos-api-username' }).value).to eq(username)
      if(password=="")
        expect(@ui.get(:text_field, {id: 'saos-api-password' }).value).to eq("")
        expect(@ui.get(:text_field, {id: 'saos-api-password-verify' }).value).to eq("")
      else
        expect(@ui.get(:text_field, {id: 'saos-api-password' }).value).to eq("fakepassword")
        expect(@ui.get(:text_field, {id: 'saos-api-password-verify' }).value).to eq("fakepassword")
      end
      expect(@ui.get(:text_field, {id: 'saos-redirect-url' }).value).to eq(url)
    end
  end
end

def verify_content_filtering_list_expanded_and_has_proper_elements  #Changed on 31/05/2017 - due to the US 4958
  content_filtering_whitebox = @ui.css('.saos-ul li:nth-child(2) .saos-li-top')
  content_filtering_whitebox.wait_until_present
  if(content_filtering_whitebox.attribute_value("class")!="saos-li-top expanded")
      content_filtering_whitebox.click
  end
  expect(content_filtering_whitebox.attribute_value("class")).to eq('saos-li-top expanded')
  expect(content_filtering_whitebox.div(css: '.saos-li-top-name').text).to eq("Content Filtering")
  expect(content_filtering_whitebox.div(css: '.saos-li-top-category').text).to eq("Web Content Filtering")
  expect(content_filtering_whitebox.parent.div(css: '.saos-li-body-desc').text).to eq("Integrate with a DNS based Content Filtering solution.\nAfter specifying the DNS address, you have to enable this setting in a Profile in order to forward all DNS requests to this address.")
  expect(content_filtering_whitebox.parent.label(css: '.xc-field:first-child label').text).to eq("Primary DNS")
  expect(content_filtering_whitebox.parent.label(css: '.xc-field:nth-child(2) label').text).to eq("Secondary DNS")
  expect(content_filtering_whitebox.parent.span(css: '.xc-field:first-child .saos-wcf-dns-sublabel').text).to eq("Required")
  expect(content_filtering_whitebox.parent.span(css: '.xc-field:nth-child(2) .saos-wcf-dns-sublabel').text).to eq("Optional")
  expect(content_filtering_whitebox.parent.div(css: '.saos-wcf-dns-label').text).to eq("DNS must be in the form of an IP address.")
end

shared_examples "test content filtering settings" do |dns1, dns2, type_of_testing|
  it_behaves_like "go to settings then to tab", "Add-On Solutions"
  describe "Test the Content Filtering settings" do
    it "Verify that the 'Content Filtering' list is expanded" do
      verify_content_filtering_list_expanded_and_has_proper_elements
      sleep 1
    end
    it "Set the following values to the input fields: '#{dns1}' and '#{dns2}'" do
      @ui.set_input_val('#saos-wcf-dns1', dns1)
      sleep 1
      @ui.set_input_val('#saos-wcf-dns2', dns2)
      sleep 1
      @ui.click('.saos-save-btn')
      sleep 0.5
      if @ui.css(".dialogOverlay.confirm").exists?
        if @ui.css(".dialogOverlay.confirm").visible?
          @ui.click("#_jq_dlg_btn_1")
        end
      end
    end
    if type_of_testing == "POSITIVE"
      it "Refresh the browser and if the 'Content Filtering' list is not expanded, expand it" do
        sleep 3
        @browser.refresh
        sleep 3
        @ui.css('.saos-ul li:nth-child(2) .saos-li-top').wait_until_present
        verify_content_filtering_list_expanded_and_has_proper_elements
        sleep 1
      end
      it "Verify the (DNS) inputs contain the strings '#{dns1}' and '#{dns2}'" do
        expect(@ui.get(:text_field, {id: 'saos-wcf-dns1' }).value).to eq(dns1)
        expect(@ui.get(:text_field, {id: 'saos-wcf-dns2' }).value).to eq(dns2)
      end
    elsif type_of_testing == "NEGATIVE"
      it "Refresh the browser and if the 'Content Filtering' list is not expanded, expand it" do
        expect(@ui.css('.temperror')).to be_present and expect(@ui.css('.temperror .title span').text).to eq("Invalid Fields") and expect(@ui.css('.temperror .msgbody div').text).to eq("Please review your changes to fix all invalid fields.")
        sleep 3
        @browser.refresh
        sleep 3
        @ui.css('.saos-ul li:nth-child(2) .saos-li-top').wait_until_present
        verify_content_filtering_list_expanded_and_has_proper_elements
        sleep 1
      end
      it "Verify the (DNS) input is 'EMPTY'" do
        expect(@ui.get(:text_field, {id: 'saos-wcf-dns1' }).value).to eq("")
        expect(@ui.get(:text_field, {id: 'saos-wcf-dns2' }).value).to eq("")
      end
    end
  end
end

shared_examples "set twillio account" do |account_sid, auth_token, phone_number|
  it_behaves_like "go to settings then to tab", "Add-On Solutions"
  describe "Set the Twillio Account settings as: '#{account_sid}', '#{auth_token}' and '#{phone_number}'" do
    it "Verify that the Twillio container exists and is visible" do
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-top .saos-li-top-name').text).to eq("Twilio SMS")
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-top .saos-li-top-category').text).to eq("Cloud Text Messaging")
      sleep 1
      if !@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-body').visible?
        @ui.click('.saos-body .saos-ul li:nth-child(3) .saos-li-top .saos-li-top-name')
      end
      sleep 1
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-body .saos-li-body-half:nth-of-type(1) .xc-field:nth-of-type(1) label').text).to eq("Account SID:")
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-body .saos-li-body-half:nth-of-type(1) .xc-field:nth-of-type(1) input').attribute_value("maxlength")).to eq("255")
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-body .saos-li-body-half:nth-of-type(1) .xc-field:nth-of-type(1) input').attribute_value("type")).to eq("text")
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-body .saos-li-body-half:nth-of-type(1) .xc-field:nth-of-type(2) label').text).to eq("Auth Token:")
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-body .saos-li-body-half:nth-of-type(1) .xc-field:nth-of-type(2) input').attribute_value("maxlength")).to eq("255")
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-body .saos-li-body-half:nth-of-type(1) .xc-field:nth-of-type(2) input').attribute_value("type")).to eq("text")
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-body .saos-li-body-half:nth-of-type(1) .xc-field:nth-of-type(3) label').text).to eq("Twilio Phone Number:")
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-body .saos-li-body-half:nth-of-type(1) .xc-field:nth-of-type(3) input').attribute_value("maxlength")).to eq("255")
      expect(@ui.css('.saos-body .saos-ul li:nth-child(3) .saos-li-body .saos-li-body-half:nth-of-type(1) .xc-field:nth-of-type(3) input').attribute_value("type")).to eq("text")
      @ui.click('.saos-body .saos-ul li:nth-child(3) .saos-li-body .saos-ctm-phone-hint.koHelpIcon')
      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq("This is a phone number you get from Twilio.\nExample: \"+\"|country code|phone number (+11234567890)")
    end
    it "Set the required settings" do
      $account_sid_input = @ui.get(:input , {id: "saos-ctm-sid"}).value
      if account_sid != "" or (account_sid == "" and $account_sid_input != "")
        @ui.set_input_val('#saos-ctm-sid', account_sid)
        sleep 1
      end
      $auth_token_input = @ui.get(:input , {id: "saos-ctm-token"}).value
      if auth_token != "" or (auth_token == "" and $auth_token_input != "")
        @ui.set_input_val('#saos-ctm-token', auth_token)
        sleep 1
      end
      $phone_number_input = @ui.get(:input , {id: "saos-ctm-phone"}).value
      if phone_number != "" or (phone_number == "" and $phone_number_input != "")
        @ui.set_input_val('#saos-ctm-phone', phone_number)
      end
    end
    it "Press the <SAVE ALL> button" do
      @ui.click('.saos-save-btn')
      sleep 1
      if account_sid == "" or auth_token == "" or $phone_number_input != ""
        if $account_sid_input != "" or $auth_token_input != "" or phone_number != ""
          if @ui.css('.dialogBox.confirm').present?
            expect(@ui.css('.dialogBox.confirm .msgbody div').text).to eq("Saving with incomplete settings will cause SMS to revert to using country-specific Mobile Providers. Do you wish to continue?")
            @ui.click('#_jq_dlg_btn_1')
        end
        end
      end
    end
    it "Verify the values in the input boxes" do
      account_sid_input = @ui.get(:input , {id: "saos-ctm-sid"})
      expect(account_sid_input.value).to eq(account_sid)
      auth_token_input = @ui.get(:input , {id: "saos-ctm-token"})
      expect(auth_token_input.value).to eq(auth_token)
      phone_number_input = @ui.get(:input , {id: "saos-ctm-phone"})
      expect(phone_number_input.value).to eq(phone_number)
    end
  end
end

shared_examples "set firmware upgrades to default time" do |child_domain|
  describe "Set the Firmware Upgrades time to 'default'" do
    it "Go to the Firmware Upgrades area and verify the tab contents" do
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_settings_link')
      sleep 3
      @ui.click('#settings_tab_firmwareupgrades')
      sleep 3
      expect(@ui.css('#settings_general_container .commonTitle').text).to eq('Firmware Upgrades')
      expect(@ui.css('#settings_general_container .commonSubtitle').text).to eq('Set your preferences for AP and Switch Firmware Upgrades')
      expect(@ui.css('#settings_general_container .firmwareupgrades-note').text).to eq("Please note: XMS-Cloud requires the latest firmware versions for optimal performance and latest features")
      if child_domain == false
        expect(@ui.css('.firmwareupgrades-ismainline label').text).to eq('Firmware Type for new domains:')
      else
        expect(@ui.css('.firmwareupgrades-ismainline label').text).to eq('Firmware Type:')
      end
      expect(@ui.css('.firmwareupgrades-usedefault label').text).to eq('Maintenance Window:')
    end
    it "Set the switch for default time to 'Yes'" do
      firmware_upgrades_switch = @ui.get(:checkbox , {id: "firmwareupgrades-usedefault_switch"})
      if firmware_upgrades_switch.set? != true
        @ui.click('#firmwareupgrades-usedefault .switch_label')
      end
    end
    it "Verify the schedule timeframe text shows the text 'Upgrade when new version is available'" do
      expect(@ui.css('.firmwareupgrades-yourschedule span:nth-child(2)').text).to eq('Upgrade when new version is available')
    end
    it "Press the <SAVE ALL> button" do
     if @ui.css("#settings_general_container .top-box .top-box-last-item .orange").present?
        @ui.click('#settings_general_container .top-box .top-box-last-item .orange')
        sleep 0.5
        expect(@ui.css('.dialogOverlay .dialogBox .msgbody div').text).to eq("Successfully updated Firmware Upgrades schedule")
      end 
    end
    it "Verify the schedule timeframe text shows the text 'Upgrade when new version is available'" do
      expect(@ui.css('.firmwareupgrades-yourschedule span:nth-child(2)').text).to eq('Upgrade when new version is available')
    end
  end
end

shared_examples "set firmware upgrades to custom time" do |daily_weekly, week_day, start_time, end_time, timezone, child_domain|
  describe "Set the Firmware Upgrades time to '#{daily_weekly}' + '#{week_day}' + '#{start_time}' + '#{end_time}' + '#{timezone}'" do
    it "Go to the Firmware Upgrades area and verify the tab contents" do
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_settings_link')
      sleep 3
      @ui.click('#settings_tab_firmwareupgrades')
      sleep 3
      expect(@ui.css('#settings_general_container .commonTitle').text).to eq('Firmware Upgrades')
      expect(@ui.css('#settings_general_container .commonSubtitle').text).to eq('Set your preferences for AP and Switch Firmware Upgrades')
      expect(@ui.css('#settings_general_container .firmwareupgrades-note').text).to eq("Please note: XMS-Cloud requires the latest firmware versions for optimal performance and latest features")
      if child_domain == false
        expect(@ui.css('.firmwareupgrades-ismainline label').text).to eq('Firmware Type for new domains:')
      else
        expect(@ui.css('.firmwareupgrades-ismainline label').text).to eq('Firmware Type:')
      end
      expect(@ui.css('.firmwareupgrades-usedefault label').text).to eq('Maintenance Window:')
    end
    it "Set the swith for default time to 'No'" do
      firmware_upgrades_switch = @ui.get(:checkbox , {id: "firmwareupgrades-usedefault_switch"})
      if firmware_upgrades_switch.set? == true
        @ui.click('#firmwareupgrades-usedefault .switch_label')
      end
    end
    it "Set the schedule for upgrades to '#{daily_weekly}' + '#{week_day}' + '#{start_time}' + '#{end_time}' + '#{timezone}'" do
      @ui.set_dropdown_entry('firmwareupgrades-frequency', daily_weekly)
      sleep 1
      if daily_weekly == "Week"
        schedule_firmwareupgrade_days_checker(week_day)
        sleep 1
      end
      @ui.set_input_val('.xc-time-range-starttime', start_time)
      sleep 1
      @ui.set_input_val('.xc-time-range-endtime', end_time)
      sleep 1
      @ui.set_dropdown_entry('firmwareupgrades-timezone', timezone)
    end
    it "Press the <SAVE ALL> button" do
     if @ui.css("#settings_general_container .top-box .top-box-last-item .orange").present?
        @ui.click('#settings_general_container .top-box .top-box-last-item .orange')
        sleep 0.5
        expect(@ui.css('.dialogOverlay .dialogBox .msgbody div').text).to eq("Successfully updated Firmware Upgrades schedule")
      end 
    end
    it "Verify the schedule timeframe text shows the options: '#{daily_weekly}' + '#{week_day}' + '#{start_time}' + '#{end_time}' + '#{timezone}'" do
      expect(@ui.css('.firmwareupgrades-yourschedule span:nth-child(1)').text).to eq('Your schedule is:')
      if daily_weekly == "Day" and start_time == "12:00 am" and end_time == "12:00 am" or daily_weekly == "Week" and week_day == "Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday" and start_time == "12:00 am" and end_time == "12:00 am"
        expect(@ui.css('.firmwareupgrades-yourschedule span:nth-child(2)').text).to eq('Every day - All Day')
      elsif daily_weekly == "Day" and start_time != "12:00 am" or daily_weekly == "Day" and start_time == "12:00 am" and end_time != "12:00 am" or daily_weekly == "Week" and week_day == "Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday"
        expect(@ui.css('.firmwareupgrades-yourschedule span:nth-child(2)').text).to eq("Every day between #{start_time} and #{end_time} - #{timezone}")
      elsif daily_weekly == "Week" and week_day != "Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday" and start_time != "12:00 am" or daily_weekly == "Week" and week_day != "Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday" and start_time == "12:00 am" and end_time != "12:00 am"
        expect(@ui.css('.firmwareupgrades-yourschedule span:nth-child(2)').text).to eq("Every week on #{week_day} between #{start_time} and #{end_time} - #{timezone}")
      elsif daily_weekly == "Week" and week_day != "Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday" and start_time == "12:00 am" and end_time == "12:00 am"
        expect(@ui.css('.firmwareupgrades-yourschedule span:nth-child(2)').text).to eq("Every week on #{week_day} - All Day")
      end
      expect(@ui.css('#firmwareupgrades-timezone .ko_dropdownlist_button .text').text).to eq(timezone)
    end
  end
end

shared_examples "verify firmware upgrades time" do |verify_string, timezone|
  describe "Go to the Firmware Upgrades area and verify that the appropriate value is displayed ('#{verify_string}')" do
    it "Go to the Firmware Upgrades area and verify the tab contents" do
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_settings_link')
      sleep 3
      @ui.click('#settings_tab_firmwareupgrades')
      sleep 3
      expect(@ui.css('#settings_general_container .commonTitle').text).to eq('Firmware Upgrades')
      expect(@ui.css('#settings_general_container .commonSubtitle').text).to eq('Set your preferences for AP and Switch Firmware Upgrades')
      expect(@ui.css('#settings_general_container .firmwareupgrades-note').text).to eq("Please note: XMS-Cloud requires the latest firmware versions for optimal performance and latest features")
      expect(@ui.css('.firmwareupgrades-usedefault label').text).to eq('Maintenance Window:')
      expect(@ui.css('.firmwareupgrades-yourschedule span:nth-child(2)').text).to eq(verify_string)
      if timezone != ""
        expect(@ui.css('#firmwareupgrades-timezone .ko_dropdownlist_button .text').text).to eq(timezone)
      end
    end
  end
end

shared_examples "verify audit trail for firmware upgrade" do |verify_string|
  describe "Verify that the 'Audit Trail' table contains the proper reference to alterations done on the Firmware Upgrade settings" do
    it "Go to the 'Audit Trail' table and verify the most recent record" do
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_troubleshooting')
      sleep 4
      expect(@ui.css('.nssg-table')).to be_present
      expect(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(4) .nssg-td-text').text).to eq(verify_string)
    end
  end
end

shared_examples "change default firmware for new domains" do |value|
  describe "Change the 'Default firmware for new domains' switch to the value '#{value}'" do
    it "Change the 'Default firmware' to '#{value}'" do
      is_main_line = @ui.get(:checkbox, {id: "firmwareupgrades-ismainline_switch"}).set?
      if (is_main_line == false and value != "Technology") or (is_main_line == true and value != "Mainline")
        @ui.click('#firmwareupgrades-ismainline')
        sleep 1
        expect(@ui.css('.firmwareupgrades-defaultfornewdomain-hint')).to be_visible
        expect(@ui.css('.firmwareupgrades-defaultfornewdomain-hint').text).to eq("This change will take effect on your next maintenance window")
      end
      if @ui.css('.buttons .button.orange').present?
        @ui.css('.buttons .button.orange').click
      end
      sleep 2
      is_main_line = @ui.get(:checkbox, {id: "firmwareupgrades-ismainline_switch"}).set?
      if value == "Mainline"
        expect(is_main_line).to eq(true)
      elsif value == "Technology"
        expect(is_main_line).to eq(false)
      end
    end
  end
end

shared_examples "verify domain and managed by strings" do |domain_name, parent_domain|
  describe "Verify that the domain's name and the managed by strings are properly displayed" do
    it "Verify that the 'This domain' string is '#{domain_name}'" do
      expect(@ui.css('.currentDomainLabel').text).to eq(domain_name)
    end
    it "Verify that the 'Managed by' string contains '#{parent_domain}'" do
      expect(@ui.css('.parentDomainLabel').text).to include(parent_domain)
    end
  end
end

shared_examples "verify default firmware changes not saved" do
  describe "Verify that the user is prompted for unsaved changes on the Default Firmware switch control" do
    it "Change the 'Default Firmware' value and navigate to another tab" do
      @ui.click('#firmwareupgrades-ismainline')
      sleep 1
      expect(@ui.css('.firmwareupgrades-defaultfornewdomain-hint')).to be_visible
      expect(@ui.css('.firmwareupgrades-defaultfornewdomain-hint').text).to eq("This change will take effect on your next maintenance window")
      @ui.click('#settings_tab_addonsolutions')
    end
    it "Verify that the application shows a confirmation dialog overlay and press the 'Cancel' button" do
      expect(@ui.css(".dialogOverlay.confim")).to be_visible
      @ui.click('#_jq_dlg_btn_1')
      sleep 1
      expect(@ui.css('.firmwareupgrades-defaultfornewdomain-hint')).to be_visible
      expect(@ui.css('.firmwareupgrades-defaultfornewdomain-hint').text).to eq("This change will take effect on your next maintenance window")
    end
  end
end

shared_examples "verify the settings area for readonly accounts" do
  it_behaves_like "go to settings then to tab", "Add-On Solutions"
  describe "Verify that a READ-ONLY user cannot modify anything on the Settings area tab -> Add-On Solutions" do
    it "Verify that the 'Save All' button isn't displayed" do
      expect(@ui.css('.saos-save-btn')).not_to be_present
    end
  end
  it_behaves_like "go to settings then to tab", "Firmware Upgrades"
  describe "Verify that a READ-ONLY user cannot modify anything on the Settings area tab -> Firmware Upgrades" do
    it "Verify that the 'Save All' button isn't displayed" do
      expect(@ui.css('#settings_general_container .top-box .top-box-last-item .orange')).not_to be_present
    end
  end
end

shared_examples "Verify user name display on top screen with info provided under My Account" do |first_name|
  include_examples "go to settings then to tab", "My Account"
  describe "Verify user name displayed on top screen with 'First Name' value then back to the original value" do
    it "Change the 'First Name' value to '#{first_name}' then back to the original value" do
    input_field = @ui.get('text_field', { id: 'myaccount_myaccountfirstname' })
    input_field.wait_until_present
    original_value = input_field.value
    puts "original_value:" + original_value
    input_field.set first_name
    @ui.click('#header_nav_user')
    sleep 0.5
    @browser.refresh
    sleep 2
    if first_name==''
      expect(@ui.css('#header_nav_user_firstname').text).to eq(@username)
    else
      expect(@ui.css('#header_nav_user_firstname').text).to eq(first_name) 
    end   
    # Change back to original value
    input_field.set original_value
    @ui.click('#header_nav_user')
    sleep 0.5
    @browser.refresh
    sleep 2
    expect(@ui.css('#header_nav_user_firstname').text).to eq(original_value)
    end    
  end
end
shared_examples "Verify switching 'Default Firmware' from 'Technology' to 'Mainline' Admin feedback panel should show up" do
  describe "Verify switching 'Default Firmware' from 'Technology' to 'Mainline' Admin feedback panel should show up" do
     it "Go to the Settings area then to the 'Firmware Upgrades' tab" do
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_settings_link')
      sleep 1
      @ui.click('#settings_tab_firmwareupgrades')
      sleep 1
    end      
    it "Change the 'Default firmware' from 'Mainline' to 'Technology'" do
      if (@ui.get(:checkbox, {id: "firmwareupgrades-ismainline_switch"}).set?)
        @ui.click('#firmwareupgrades-ismainline')
        sleep 1
      end
      @ui.click('#settings_general_container .top-box .top-box-last-item .orange')
      sleep 2
      expect(@ui.get(:checkbox, {id: "firmwareupgrades-ismainline_switch"}).set?).to eq(false)
    end
    it "Change the 'Default firmware' from 'Technlogy' to 'Mainline'" do
      if (!@ui.get(:checkbox, {id: "firmwareupgrades-ismainline_switch"}).set?)
        @ui.click('#firmwareupgrades-ismainline')
        sleep 1
      end
      @ui.click('#settings_general_container .top-box .top-box-last-item .orange')
      sleep 2
      expect(@ui.get(:checkbox, {id: "firmwareupgrades-ismainline_switch"}).set?).to eq(true)
      expect(@ui.css('.suggestionContainer').visible?).to eq(true)
      expect(@ui.css('.suggestionContainer .suggestionTitle').text).to eq("Switching to Mainline?")
      expect(@ui.css('.suggestionContainer .suggestionContent .openslideoutcontent .description span').text).to eq("Switching back to Mainline from Technology? Please let us know if you had problems with the Technology version so we may improve in the future.")
      expect(@ui.css('.suggestionContainer .suggestionContent .openslideoutcontent .button.orange').text).to eq("SUBMIT")
    end
  end
end

shared_examples "verify user privileges panel" do |email_address|
  describe "verify user privileges panel" do
    it "verify that user privileges switch in Set user details" do
      go_to_settings_my_account_steps
      @browser.execute_script('$("#suggestion_box").hide()')
      @ui.click('#settings_tab_myaccount')
      sleep 1
      @ui.click('#settings_tab_useraccounts')
      sleep 1
      user_accounts_grid_actions("invoke",email_address,"","","","")
      sleep 1
      expect(@ui.css('#settings_useraccounts_restricted span').text).to eq("Would you like to restrict this account to specific sections of your network?\nThis will force the account to a User or Read Only role.")
      # Moved Guest Ambassador to XMS User type drop down list in 9.5.0 release
      # expect(@ui.get(:checkbox, {css: "#settings_useraccounts_ambassador_Switch_switch"}).set?).to eq(false)         
    end
    it "Verify User privileges panel" do
      # Moved Guest Ambassador to XMS User type drop down list in 9.5.0 release
      # if(!@ui.get(:checkbox, {css: "#settings_useraccounts_ambassador_Switch_switch"}).set?)
        # @ui.css('#settings_useraccounts_restricted_Switch').click
      # end
        @ui.css('#settings_useraccounts_restricted_Switch').click
        sleep 1
        @ui.css('#settings_useraccounts_restricted .edit-icon').click
        @ui.css('xc-modal-title').wait_until_present
        expect(@ui.css("xc-modal-title").text).to eq("Assign User Privileges")
        expect(@ui.css('.restrictions-navigation ul li:nth-child(1)').text).to eq('Profiles')
        expect(@ui.css('.restrictions-navigation ul li:nth-child(2)').text).to eq('Groups')
        expect(@ui.css('.restrictions-navigation ul li:nth-child(3)').text).to eq('EasyPass')
        @ui.css('.restrictions-navigation ul li:nth-child(1)').click
        expect(@ui.css('.restrictions-selection .restriction-list label:nth-child(1)').text).to eq("Select the Profiles this user has access to:")
        expect(@ui.css('.restrictions-selection .restriction-list label:nth-child(2)').text).to include("Profiles available")
        expect(@browser.elements(css: ".list-section span:nth-child(1) .list-row").length).to eq(4)
        expect(@browser.elements(css: ".selected-restrictions .selection-tags label span").length).to eq(0)
        @ui.css(".list-section span:nth-child(1) .list-row:nth-child(1) .mac_chk_label").click
        expect(@browser.elements(css: ".selected-restrictions .selection-tags span").length).to be > 1
        @ui.css(".list-section span:nth-child(1) .list-row:nth-child(1) .mac_chk_label").click
        @ui.css('.restrictions-navigation ul li:nth-child(2)').click
        expect(@ui.css('.restrictions-selection .restriction-list label:nth-child(1)').text).to eq("Select the Groups this user has access to:")
        expect(@ui.css('.restrictions-selection .restriction-list label:nth-child(2)').text).to include("Groups available")
        expect(@browser.elements(css: ".list-section span:nth-child(2) .list-row").length).to eq(4)
        expect(@browser.elements(css: ".selected-restrictions .selection-tags label:nth-child(2) span").length).to eq(0)
        @ui.css(".list-section span:nth-child(2) .list-row:nth-child(1) .mac_chk_label").click
        expect(@browser.elements(css: ".selected-restrictions .selection-tags label:nth-child(2) span").length).to be > 1
        @ui.css(".list-section span:nth-child(2) .list-row:nth-child(1) .mac_chk_label").click
        
        @ui.css('.restrictions-navigation ul li:nth-child(3)').click
        expect(@ui.css('.restrictions-selection .restriction-list label:nth-child(1)').text).to eq("Select the EasyPass this user has access to:")
        expect(@ui.css('.restrictions-selection .restriction-list label:nth-child(2)').text).to include("EasyPass available")
        expect(@browser.elements(css: ".list-section span:nth-child(4) .list-row").length).to eq(4)      
        expect(@browser.elements(css: ".selected-restrictions .selection-tags label:nth-child(4) span").length).to eq(0)
        @ui.css(".list-section span:nth-child(4) .list-row:nth-child(1) .mac_chk_label").click
        expect(@browser.elements(css: ".selected-restrictions .selection-tags label:nth-child(4) span").length).to be > 1
        @ui.css(".list-section span:nth-child(4) .list-row:nth-child(1) .mac_chk_label").click  
        @browser.refresh
    end    
  end
end
shared_examples "assign user privileges for profiles-groups-easypass" do |email_address, profiles, groups, easypasses|
  describe "assign user privileges for profiles-groups-easypass" do
    it "open user privileges panel for #{email_address}" do
      go_to_settings_my_account_steps
      @browser.execute_script('$("#suggestion_box").hide()')
      @ui.click('#settings_tab_myaccount')
      sleep 1
      @ui.click('#settings_tab_useraccounts')
      sleep 1
      user_accounts_grid_actions("invoke",email_address,"","","","")
      sleep 1
      #moved Guest ambassador option under xms user type
      # if(!@ui.get(:checkbox, {css: "#settings_useraccounts_ambassador_Switch_switch"}).set?)
        # @ui.css('#settings_useraccounts_restricted_Switch').click
      # end
      @ui.css('#settings_useraccounts_restricted_Switch').click
      sleep 1
      @ui.css('#settings_useraccounts_restricted .edit-icon').click
      @ui.css('xc-modal-title').wait_until_present
    end
    it "assign profile privileges to user" do
      if profiles
        @ui.css('.restrictions-navigation ul li:nth-child(1)').click
        profiles.each do |profile|
          @browser.elements(css: ".list-section span:nth-child(1) .list-row").each do |item|
            if profile==item.element(css: "label").text
              item.element(css: ".mac_chk_label").click
            end
          end
        end        
      end
    end
    it "assign group privileges to user" do
      if groups
        @ui.css('.restrictions-navigation ul li:nth-child(2)').click
        groups.each do |group|
          @browser.elements(css: ".list-section span:nth-child(2) .list-row").each do |item|
            if group==item.element(css: "label").text
              item.element(css: ".mac_chk_label").click
            end
          end
        end        
      end
    end
    it "assign easypass privilges to user" do
      if easypasses
        @ui.css('.restrictions-navigation ul li:nth-child(3)').click
        easypasses.each do |easypass|
          @browser.elements(css: ".list-section span:nth-child(4) .list-row").each do |item|
            if easypass==item.element(css: "label").text
              item.element(css: ".mac_chk_label").click
            end
          end
        end        
      end
    end
    it "Save the user" do
      @ui.css("xc-modal-buttons .button.orange").click
      sleep 1
      @ui.click('#users_modal_save_btn')
      sleep 3
      expect(@ui.css('.tabpanel_slideout.left.opened')).not_to exist
    end
  end  
end
shared_examples "logout and login with user and password" do |user_email, password|
  describe "logout and login with user and password" do
    it "logout and login with new user and password" do
     @ui.logout()
     sleep 1
     if user_email == nil
       user_email= @username
       password = @password
     end
     @ui.login_without_url(user_email, password)
     sleep 5
    end
  end
end
shared_examples "verify restricted profile-group-easypass only available" do |profiles, groups, easypasses|
  describe "verify restricted profile-group-easypass only available" do
    it "Verify overview dashboard" do
      @ui.click('#header_mynetwork_link')
      sleep 1
      @ui.css("#mynetwork_overview_scopetoprofile .ko_dropdownlist_button").click
      expect(@browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_scroller ul li").length).to eq(4)
      @browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_scroller ul li").each do|item|
        expect(profiles+groups).to include(item.element(css: "span").text)
      end  
      @ui.css("#ko_dropdownlist_overlay").click 
    end
    it "verify mynetwork access points tab" do
      go_to_my_network_arrays_tab
      sleep 1
      @ui.css("#mynetwork_general_container .ko_dropdownlist_button").click
      expect(@browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_scroller ul li").length).to eq(5)
      @browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_scroller ul li").each do|item|
        if "All Devices" != item.text
          expect(profiles+groups).to include(item.element(css: "span").text)
        end        
      end
      @ui.css("#ko_dropdownlist_overlay").click
    end
    it "verify mynetwork clients tab" do
      @ui.click("#header_nav_mynetwork")
      sleep 1
      @ui.click('#mynetwork_tab_clients')
      sleep 1
      @ui.css("#mynetwork_general_container .ko_dropdownlist_button").click
      expect(@browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_scroller ul li").length).to eq(5)
      @browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_scroller ul li").each do|item|
        if "All Devices" != item.text
          expect(profiles+groups).to include(item.element(css: "span").text)
        end        
      end
      @ui.css("#ko_dropdownlist_overlay").click
    end
    it "verify mynetwork Rogues tab" do
      @ui.click("#header_nav_mynetwork")
      sleep 1
      @ui.click('#mynetwork_tab_rogues')
      sleep 1
      @ui.css("#mynetwork_general_container .ko_dropdownlist_button").click
      expect(@browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_scroller ul li").length).to eq(5)
      @browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_scroller ul li").each do|item|
        if "All Devices" != item.text
          expect(profiles+groups).to include(item.element(css: "span").text)
        end        
      end
      @ui.css("#ko_dropdownlist_overlay").click
    end
    
    it "verify mynetwork Alert" do
      @ui.click("#header_nav_mynetwork")
      sleep 1
      @ui.click('#mynetwork_tab_alerts')
      sleep 1
      @ui.css("#mynetwork_general_container .ko_dropdownlist_button").click
      expect(@browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_scroller ul li").length).to eq(5)
      @browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_scroller ul li").each do|item|
        if "All Devices" != item.text
          expect(profiles+groups).to include(item.element(css: "span").text)
        end        
      end
      @ui.css("#ko_dropdownlist_overlay").click
    end
    it "verify Easypass portals" do
      @ui.goto_all_guestportals_view
      sleep 1
      expect(@browser.elements(css: "#guestportals_list ul:nth-child(2) li a").length).to eq(2)
      @browser.elements(css: "#guestportals_list ul:nth-child(2) li a").each do |portal|
        expect(easypasses).to include(portal.element(css: "span").text)
      end
    end
    it "verify reports edit view groups and profile" do
      @ui.view_all_reports
      expect(@browser.url).to include('/#reports')
      @ui.goto_report "AP and Client Throughput Report"
      sleep 1
      @ui.css("#report-edit-view-btn").click
      sleep 0.5
      @ui.css("#report-edit-view-profile .ko_dropdownlist_button").click
      expect(@browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul li").length).to eq(4)
      @browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul li").each do|item|
         expect(profiles+groups).to include(item.element(css: "span").text)
      end
      @ui.css("#ko_dropdownlist_overlay").click   
      sleep 0.2
      @ui.css("#report-edit-view-cancel").click    
    end
    it "verify analytic report groups" do
      @ui.click('#header_nav_reports') and sleep 1
      expect(@ui.css('#header_nav_reports .drop_menu_nav')).to be_visible and expect(@ui.css('#header_nav_reports .drop_menu_nav #analytics_menu_item')).to be_visible
      @ui.click('#analytics_menu_item a')
      sleep 2
      @ui.css('.analytics-header span').wait_until(&:present?) and expect(@ui.css('.analytics-header span').text).to eq('Analytics') and expect(@browser.url).to include('/#analytics')
      sleep 1
      @ui.css(".new-item-icon").click
      sleep 0.5
      @ui.set_input_val('xc-modal-container .widget-editor-container div:nth-child(1) .row input', "User-privilesges")
      @ui.css("xc-modal-container xc-modal-body .ko_dropdownlist_button").click
      expect(@browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul li").length).to eq(3)
      @browser.elements(css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul li").each do|item|
        if "Select a filter" != item.text
          expect(groups).to include(item.element(css: "span").text)
        end        
      end
      @ui.css("#ko_dropdownlist_overlay").click 
      sleep 0.5
      @ui.css(".xc-modal-close").click
    end
  end
end
