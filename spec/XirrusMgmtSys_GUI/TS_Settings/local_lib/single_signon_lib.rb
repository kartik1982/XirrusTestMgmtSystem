shared_examples "go to sso tab" do
  describe "Go to the 'Single Sign-On tab" do
    it "Press the 'SSO' tile and wait for the user to be navigated properly" do
      expect(@ui.css('#profile_config_tab_sso')).to be_present
      @ui.click('#profile_config_tab_sso') and sleep 1
      @ui.css('#sso-saveall').wait_until_present
      expect(@browser.url).to include('#settings/useraccounts/sso')
    end
  end
end

shared_examples "verify general features of sso tab" do
  describe "Verify the SSO tab's general features" do
    it "Verify the available controls" do
      expect(@browser.url).to include('#settings/useraccounts/sso')
      expect(@ui.css('#settings_sso .commonTitle').text).to eq("Single Sign-On")
      expect(@ui.css('#sso-saveall')).to be_present
      expect(@ui.css('#settings_sso .togglebox .togglebox_heading').text).to eq("Would you like to enable SSO?")
      expect(@ui.css('#settings_sso .togglebox .switch .switch_label')).to be_present
      expect(@ui.css('#settings_sso .togglebox .togglebox_contents .togglebox_heading')).not_to be_visible
    end
  end
end

shared_examples "enable disable sso" do |what_action, what_platform|
  describe "'#{what_action}' the Single Sign-On switch" do
    it "Perform the action to '#{what_action}'" do
      if @ui.get(:checkbox ,  {css: "#settings_sso .togglebox .switch input"}).set? == false and what_action == "Enable"
        @ui.click('#settings_sso .togglebox .switch .switch_label')
        sleep 1
        expect(@ui.css('#settings_sso .togglebox .togglebox_contents .togglebox_heading')).to be_present
      elsif @ui.get(:checkbox ,  {css: "#settings_sso .togglebox .switch input"}).set? == true and what_action == "Disable"
        @ui.click('#settings_sso .togglebox .switch .switch_label')
        sleep 1
        expect(@ui.css('#settings_sso .togglebox .togglebox_contents .togglebox_heading')).not_to be_present
        if @ui.css('.temperror').exists?
          @ui.css('.temperror').wait_while_present
        end
        @ui.click('#sso-saveall')
        sleep 0.5
        if @ui.css('.temperror').exists?
          expect(@ui.css('.temperror .msgbody div').text).to eq("")
        elsif @ui.css('.error').exists?
          expect(@ui.css('.error .msgbody div').text).to eq("")
        end
        @ui.css('.success').wait_until_present
      end
    end
    if what_action != "Disable"
      it "Set the platform switch to '#{what_platform}'" do
        # if @ui.get(:checkbox ,  {css: "#settings_sso .togglebox .active .switch input"}).set? == true and what_platform == "Azure"
          # @ui.click('#settings_sso .togglebox .active .switch .switch_label')
          # sleep 1
          # expect(@ui.css('#settings_sso .togglebox .togglebox_contents.active div:last-child .note').text).to include("Azure")
        # elsif @ui.get(:checkbox ,  {css: "#settings_sso .togglebox .active .switch input"}).set? == false and what_platform == "G-Suite"
          # @ui.click('#settings_sso .togglebox .active .switch .switch_label')
          # sleep 1
          # expect(@ui.css('#settings_sso .togglebox .togglebox_contents.active .togglebox_contents.active .note').text).to include("Google")
        # end
      # end
      #Turn on Google platform
      if @ui.get(:radio, { id: 'g-suite-choice' }).set? == false and what_platform == "G-Suite"
         @ui.click('#g-suite-choice')
         sleep 1
         expect(@ui.css('#settings_sso .togglebox .togglebox_contents.active div:nth-child(3) .note').text).to include("Google")
       end
      #Turn on Azure platform
      if @ui.get(:radio, { id: 'azure-choice' }).set? == false and what_platform == "Azure"
         @ui.click('#azure-choice')
         sleep 1
         expect(@ui.css('#settings_sso .togglebox .togglebox_contents.active div:nth-child(4) .note').text).to include("Azure")
       end
      #Turn on Saml platform
      if @ui.get(:radio, { id: 'saml-choice' }).set? == false and what_platform == "Saml"
         @ui.click('#saml-choice')
         sleep 1
         expect(@ui.css('#settings_sso .togglebox div:nth-child(3) div:nth-child(5) .note').text).to include("SAML")
       end
    end
    end
  end
end

shared_examples "enable saml sso" do |idp_metadata|
  describe "verify SAML Single sign on panel features" do
    it "verify SAML Single sign on panel available features" do
      css_builder = '#settings_sso .togglebox div:nth-child(3) div:nth-child(5)'
      expect(@ui.css(css_builder + ' .note').text).to eq("Configure single sign on using SAML 2.0.")
      css_builder = css_builder + ' xc-guestportals-saml'
      expect(@ui.css(css_builder+ ' .saml-container span:nth-child(1)').text).to eq("SP SSO Url:")
      expect(@ui.css(css_builder+ ' .saml-container div').text).to eq("https://login-#{$the_environment_used}.cloud.xirrus.com/saml/SSO")
      expect(@ui.css(css_builder+ ' .saml-container span:nth-child(3)').text).to eq("SP Entity ID (SP Metadata link):") 
      expect(@ui.css(css_builder+ ' .saml-container a').text).to eq("https://login-#{$the_environment_used}.cloud.xirrus.com/saml/metadata")
      expect(@ui.get(:textarea , {id: "idp_metadata"}).value).to eq("")
      expect(@ui.css(css_builder+ ' .fl_right.long_text.last_value').exists?).to eq(false)
    end
    it "Save the SSO option and verify the values" do
      css_builder = '#settings_sso .togglebox div:nth-child(3) div:nth-child(5)'
      @ui.set_textarea_val('#idp_metadata', idp_metadata)
      @ui.click('#sso-saveall')
      sleep 0.5
      if @ui.css('.temperror').exists?
        expect(@ui.css('.temperror .msgbody div').text).to eq("")
      elsif @ui.css('.error').exists?
        expect(@ui.css('.error .msgbody div').text).to eq("")
      end
      @ui.css('.success').wait_until_present
      sleep 1
      expect(@ui.css(css_builder+ ' .fl_right.long_text.last_value').text).to eq("https://login-#{$the_environment_used}.cloud.xirrus.com/saml/login?idp=https://idp.ssocircle.com")
    end
    
  end
end
shared_examples "enable microsoft azure" do |user_name, user_password|
  describe "Update the Microsoft Azure Authorization for Single Sign-On" do
    it "Verify the available features" do
      css_builder = '#settings_sso .togglebox .togglebox_contents.active div:nth-child(4)'
      expect(@ui.css(css_builder + ' .note').text).to eq("Enabling SSO will allow you to provide access for a sub-set of users (Organization) in your Azure Directory.")
      css_builder = css_builder + ' xc-guestportals-azure'
      expect(@ui.css(css_builder + ' .centered .orange')).to be_present
      expect(@ui.css(css_builder + ' .centered .orange').text).to eq("AUTHORIZE")
      expect(@ui.css(css_builder + ' .push-down span:first-child').text).to eq("Not integrated with Azure")
      expect(@ui.css(css_builder + ' .push-down span:nth-child(2)').attribute_value("class")).to include("DOWN")
    end
    it "Enable the Microsoft Azure Authorization using '#{user_name}' with '#{user_password}' (as Pasword)" do
      css_builder = '#settings_sso .togglebox .togglebox_contents.active div:nth-child(4) xc-guestportals-azure'
      sleep 1
      2.times do
        expect(@ui.css(css_builder + ' .centered .orange')).to be_present
        @ui.click(css_builder + ' .centered .orange')
        sleep 1
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
                # if @browser.input(:css => '.col-xs-24 .col-xs-24 .btn').exists?
                  # @browser.input(:css => '.col-xs-24 .col-xs-24 .btn').click
                else
                  # @browser.input(:css => '.col-xs-12.primary .btn').click
                  @browser.button(:text => 'Accept').click
                end
                sleep 2
                break if !@browser.window(:url => /login.microsoftonline.com/).exists?
                if @browser.input(:css => '.placeholderContainer .form-control').exists?
                  @browser.input(:css => '.placeholderContainer .form-control').send_keys user_password
                  sleep 2
                end
               if @browser.button(:text => 'Sign in').exists?
                  @browser.button(:text => 'Sign in').click
                # if @browser.input(:css => '.col-xs-12.primary .btn').exists?
                  # @browser.input(:css => '.col-xs-12.primary .btn').click
                  sleep 2
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
               if @browser.button(:text => 'Yes').exists?
                  @browser.button(:text => 'Yes').click
                  # if @browser.element(:id => 'cred_accept_button').exists?
                    # sleep 1
                    # @browser.element(:id => 'cred_accept_button').click
                    # sleep 1
                  end
                end
          end
        sleep 15
        if @ui.css('.loading').exists?
          @ui.css('.loading').wait_while_present
        end
      end
    end
    it "Verify that the tab shows the dirty icon" do
      expect(@ui.css('#profile_config_tab_sso .dirtyIcon')).to be_present
    end
=begin
    it "Verify the available features and values" do
      css_builder = '#settings_sso .togglebox .togglebox_contents.active div:last-child xc-guestportals-azure'
      expect(@ui.css(css_builder + ' .centered .push-down span:first-child').text).to eq("Successfully integrated with Azure by:\nadinte@alexxirrusoutlook.onmicrosoft.com")
      expect(@ui.css(css_builder + ' .centered .push-down span:nth-child(2)').attribute_value("class")).to include("online_status UP")
      expect(@ui.css(css_builder + ' .field .field_label').text).to eq("Default XMS role for new users:")
      expect(@ui.css(css_builder + ' .field #guestportal_config_general_google_role')).to be_present
      #css_builder = css_builder + ' .togglebox_contents.active div:nth-child(4)'
      expect(@ui.css(css_builder + ' .centered span').text).to eq("Users visiting your network will connect from your selected groups in the following domain:")
      expect(@ui.get(:input , {css: css_builder + ' .centered .azure-domain-input input'}).value).to eq("alexxirrusoutlook.onmicrosoft.com")
      expect(@ui.css(css_builder + ' .togglebox_heading').text).to eq("Would you like to restrict access to specific groups?")
      expect(@ui.get(:checkbox , {css: css_builder + ' .switch input'}).set?).to eq(false)
    end
    it "Save the SSO option and verify the values" do
      @ui.click('#sso-saveall')
      sleep 0.5
      if @ui.css('.temperror').exists?
        expect(@ui.css('.temperror .msgbody div').text).to eq("")
      elsif @ui.css('.error').exists?
        expect(@ui.css('.error .msgbody div').text).to eq("")
      end
      @ui.css('.success').wait_until_present
    end
    it "Enable the 'Restrict to specific groups' and add one group" do
      css_builder = '#settings_sso .togglebox .togglebox_contents.active div:last-child xc-guestportals-azure .togglebox_contents.active div:nth-child(4)'
      @ui.click(css_builder + ' .switch .switch_label')
      sleep 2
      expect(@ui.get(:checkbox , {css: css_builder + ' .switch input'}).set?).to eq(true)
      @ui.set_dropdown_entry_by_path(css_builder + " .azure-groups .azure-groups-col-2 .ko_dropdownlist", "Macadamian")
      sleep 1
      @ui.click(css_builder + " .azure-groups .azure-groups-col-3 .orange")
      sleep 1
    end
=end
    it "Save the SSO option and verify the values" do
      @ui.click('#sso-saveall')
      sleep 0.5
      if @ui.css('.temperror').exists?
        expect(@ui.css('.temperror .msgbody div').text).to eq("")
      elsif @ui.css('.error').exists?
        expect(@ui.css('.error .msgbody div').text).to eq("")
      end
      @ui.css('.success').wait_until_present
    end
  end
end

shared_examples "enable google directory synchronization" do |user_name, user_password|
  describe "Enable the GOOGLE Directory Synchronization for Single Sign-On" do
    it "Verify the available features" do
      css_builder = '#settings_sso .togglebox .togglebox_contents.active .togglebox_contents.active'
      expect(@ui.css(css_builder + ' .push-down a').text).to eq("Follow these steps...")
      expect(@ui.css(css_builder + ' .note').text).to eq("Enabling SSO will allow you to provide access for a sub-set of users (Organization) in your Google Directory.")
      css_builder = css_builder + ' xc-guestportals-google'
      expect(@ui.css(css_builder + ' .centered .orange')).to be_present
      expect(@ui.css(css_builder + ' .centered .orange').text).to eq("AUTHORIZE")
      expect(@ui.css(css_builder + ' .push-down span:first-child').text).to eq("Directory sync is Inactive")
      expect(@ui.css(css_builder + ' .push-down span:nth-child(2)').attribute_value("class")).to include("DOWN")
    end
    it "Enable the Directory Synchronization using the account '#{user_name}'" do
      css_builder = '#settings_sso .togglebox .togglebox_contents.active .togglebox_contents.active xc-guestportals-google'
      @ui.click(css_builder + ' .centered .orange')
      sleep 1
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
    end
    it "Verify that the tab shows the dirty icon" do
      expect(@ui.css('#profile_config_tab_sso .dirtyIcon')).to be_present
    end
    it "Verify the available features and values" do
      css_builder = '#settings_sso .togglebox .togglebox_contents.active .togglebox_contents.active xc-guestportals-google'
      expect(@ui.css(css_builder + ' .centered .push-down span:first-child').text).to eq("Directory sync is Active")
      expect(@ui.css(css_builder + ' .centered .push-down span:nth-child(2)').attribute_value("class")).to include("online_status UP")
      expect(@ui.css(css_builder + ' .centered span:nth-child(3)').text).to eq("Google Directory Administrator: #{user_name}")
      expect(@ui.css(css_builder + ' .field .field_label').text).to eq("Default XMS role for new users:")
      expect(@ui.css(css_builder + ' .field #guestportal_config_general_google_role')).to be_present
      expect(@ui.css(css_builder + ' span:nth-child(4)').text).to eq("Would you like to restrict access to specific Organizations?")
      expect(@ui.get(:checkbox , {css: css_builder + ' .switch input'}).set?).to eq(false)
    end
    it "Save the SSO option and verify the values" do
      @ui.click('#sso-saveall')
      sleep 0.5
      if @ui.css('.temperror').exists?
        expect(@ui.css('.temperror .msgbody div').text).to eq("")
      elsif @ui.css('.error').exists?
        expect(@ui.css('.error .msgbody div').text).to eq("")
      end
      @ui.css('.success').wait_until_present
    end
    it "Verify the available features and values" do
      css_builder = '#settings_sso .togglebox .togglebox_contents.active .togglebox_contents.active xc-guestportals-google'
      expect(@ui.css(css_builder + ' .centered .push-down span:first-child').text).to eq("Directory sync is Active")
      expect(@ui.css(css_builder + ' .centered .push-down span:nth-child(2)').attribute_value("class")).to include("online_status UP")
      expect(@ui.css(css_builder + ' .centered span:nth-child(3)').text).to eq("Google Directory Administrator: #{user_name}")
      expect(@ui.css(css_builder + ' .field .field_label').text).to eq("Default XMS role for new users:")
      expect(@ui.css(css_builder + ' .field #guestportal_config_general_google_role')).to be_present
      expect(@ui.css(css_builder + ' span:nth-child(4)').text).to eq("Would you like to restrict access to specific Organizations?")
      expect(@ui.get(:checkbox , {css: css_builder + ' .switch input'}).set?).to eq(false)
    end
    it "Enable the Organizations switch and select 'ALL ORGANIZATIONS'" do
      css_builder = '#settings_sso .togglebox .togglebox_contents.active .togglebox_contents.active xc-guestportals-google'
      if @ui.get(:checkbox , {css: css_builder + ' .switch .switch_checkbox'}).set? != true
        @ui.click(css_builder + ' .switch .switch_label')
        sleep 0.5
        expect(@ui.css(css_builder + " #google_orgsync .selected").text).to eq("0 Selections")
      end
      sleep 1
      expect(@ui.css('#google_orgsync .select-all')).to be_present
      expect(@ui.css('#google_orgsync .clear')).to be_present
      sleep 1
      @ui.click('#google_orgsync .select-all')
      sleep 1
    end
    it "Save the SSO option and verify the values" do
      @ui.click('#sso-saveall')
      sleep 0.5
      if @ui.css('.temperror').exists?
        expect(@ui.css('.temperror .msgbody div').text).to eq("")
      elsif @ui.css('.error').exists?
        expect(@ui.css('.error .msgbody div').text).to eq("")
      end
      @ui.css('.success').wait_until_present
    end
    it "Set the Organizations switch to 'No'" do
      css_builder = '#settings_sso .togglebox .togglebox_contents.active .togglebox_contents.active xc-guestportals-google'
      @ui.click(css_builder + ' .switch .switch_label')
      sleep 1
      expect(@ui.get(:checkbox , {css: css_builder + ' .switch .switch_checkbox'}).set?).to eq(false)
      sleep 0.5
    end
    it "Save the SSO option and verify the values" do
      @ui.click('#sso-saveall')
      sleep 0.5
      if @ui.css('.temperror').exists?
        expect(@ui.css('.temperror .msgbody div').text).to eq("")
      elsif @ui.css('.error').exists?
        expect(@ui.css('.error .msgbody div').text).to eq("")
      end
      @ui.css('.success').wait_until_present
    end
  end
end