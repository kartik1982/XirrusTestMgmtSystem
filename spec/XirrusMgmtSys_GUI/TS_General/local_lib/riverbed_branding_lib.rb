shared_examples "header color" do
  describe "Verify the 'Header color'" do
    it "Verify that the Header color is #FFF" do
      expect(@browser.execute_script("return $('#main_header').css('background-color')")).to eq("rgb(255, 255, 255)")
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('#main_header')).getPropertyValue('background-color');")).to include("rgb(255, 255, 255)")
    end
  end
end

shared_examples "header logo" do
  describe "Verify the 'Header Logo'" do
    it "Verify the Header Logo uses the image 'img/Riverbed_Xirrus_logo.svg'" do
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('#header_logo .header-logo-img'), ':after').getPropertyValue('content');")).to include("img/Riverbed_Xirrus_logo.svg")
    end
  end
end

shared_examples "header help control" do |eircom_tenant, avaya_tenant|
  describe "Verify the 'Help control'" do
    if eircom_tenant == true
      it "Verify that the 'Help control' has a 'Help' icon and the 'HELP' text has the color 'rgb(255, 255, 255)'" do
        expect(@browser.execute_script("return $('#header_help_link').css('color')")).to include("rgb(255, 255, 255)")
        expect(@browser.execute_script("return $('#header_nav_help .koHelpIcon').css('background')")).to include("/img/help-white.svg")
      end
    elsif avaya_tenant == true
      it "Verify that the 'Help control' has a 'Help' icon and the 'HELP' text has the color 'rgb(86, 90, 92)'" do
        expect(@browser.execute_script("return $('#header_help_link').css('color')")).to include("rgb(86, 90, 92)")
        expect(@browser.execute_script("return $('#header_nav_help .koHelpIcon').css('background')")).to include("/img/help.svg")
      end
    else
      it "Verify that the 'Help control' has a 'Help' icon and the 'HELP' text has the color 'rgb(89, 88, 89)'" do
        expect(@browser.execute_script("return $('#header_help_link').css('color')")).to include("rgb(89, 88, 89)")
        expect(@browser.execute_script("return $('#header_nav_help .koHelpIcon').css('background')")).to include("/img/help.svg")
      end
    end
    it "Verify that the text is written as 'Help' and not 'HELP'" do
      expect(@ui.css('#header_help_link').text).to eq("Help")
    end
  end
end

shared_examples "whats new icon" do |eircom_tenant, avaya_tenant|
  describe "Verify the 'What's New' icon" do
    it "Verify that the 'What's New' icon is (NORMAL TENANT) '/img/whatsnew.svg' and has the color grey or (EIRCOM TENANT) '/img/whatsnew-white.svg' and has the color white" do
      @browser.execute_script("$('xc-news-banner').show()")
      expect(@ui.css('xc-news-banner .news-icon-white')).to be_present
      if eircom_tenant == true
        expect(@browser.execute_script("return $('xc-news-banner .news-icon-white').css('background-image')")).to include("/img/whatsnew-white.svg")
      else
        expect(@browser.execute_script("return $('xc-news-banner .news-icon-white').css('background-image')")).to include("/img/whatsnew-white.svg")
      end
      expect(@browser.execute_script("return $('xc-news-banner').css('background-image')")).to eq("none")
    end
    if avaya_tenant == true
      it "Verify the separator color is 'rgb(255,255,255)'" do
        expect(@browser.execute_script("return $('.news-banner .news-banner-row .slant').css('border-left-color')")).to eq("rgb(255, 255, 255)")
      end
    else
      it "Verify the separator color is 'rgb(255, 255, 255)'" do
        expect(@browser.execute_script("return $('.news-banner .news-banner-row .slant').css('border-left-color')")).to eq("rgb(255, 255, 255)")
      end
    end
    it "Verify that the 'What's New' bubble message is correctly placed" do
      @browser.execute_script("$('.news-icon-white').show()")
      expect(@ui.css('.news-icon-white')).to be_present
      puts @browser.execute_script("return $('xc-icon.news-icon-white').css('height')").to_i
      expect(@browser.execute_script("return $('xc-icon.news-icon-white').css('height')").to_i).to be_between(30,40)
      puts @browser.execute_script("return $('xc-icon.news-icon-white').css('width')").to_i
      expect(@browser.execute_script("return $('xc-icon.news-icon-white').css('width')").to_i).to be_between(30,40)
    end
    it "Close the 'What's new' bubble message" do
      @browser.execute_script("$('xc-news-banner').hide()")
    end
  end
end

shared_examples "footer elements" do
  describe "Verify the 'Footer'" do
    it "Verify the 'Footer' color is 'rgb(255, 255, 255)'" do
      expect(@browser.execute_script("return $('#main_footer').css('background-color')")).not_to eq("rgb(3, 72, 121)")
      expect(@browser.execute_script("return $('#main_footer').css('background-color')")).to eq("rgb(255, 255, 255)")
    end
    it "Verify the 'Footer' title is 'Riverbed - Xirrus'" do
      expect(@ui.css('#main_footer .appTitle').text).to eq("Riverbed - Xirrus")
    end
  end
end

shared_examples "header navigation" do |use_msp, is_xmse, eircom_tenant, avaya_tenant|
  describe "Verify the 'Header Navigation'" do
    it "Verify the 'Header Navigation' control" do
      expect(@ui.css("#header_nav_user .user-icon")).to be_present
      if eircom_tenant == true
        expect(@browser.execute_script("return $('#header_nav_user .user-icon').css('background-image')")).to include("/img/user-white.svg")
      else
        expect(@browser.execute_script("return $('#header_nav_user .user-icon').css('background-image')")).to include("/img/user.svg")
      end
    end
    it "Open the 'Header Navigation' dropdown menu" do
      @ui.css('#header_nav_user').wait_until_present
      @ui.click('#header_nav_user')
      sleep 1
      @ui.css('#profile_link').wait_until_present
    end
    it "Verify that the User Profile email/link is not clickable" do
      expect(@ui.css('#profile_link').attribute_value("href")).to include("/#settings/myaccount")
      @ui.click("#profile_link")
      sleep 3
      expect(@browser.url).to include("/#settings/myaccount")
    end
    if use_msp == true
      #it "Verify that the 'CommandCenter' option is renamed to 'Realm (CommandCenter)' " do
      #  expect(@ui.css('#header_msp_link').text).to eq('Realm (CommandCenter)')
      #end
      #it "Verify that the 'CommandCenter' option has the icon '/img/world.svg'" do
      #  expect(@ui.css("#header_nav_user .world-icon")).to be_present
      #  expect(@browser.execute_script("return $('#header_nav_user .world-icon').css('background-image')")).to include("/img/world.svg")
      #end
    end
    # it "Close the 'Header Navigation' dropdown menu" do
      # @ui.click('.globalTitle')
    # end
    if eircom_tenant == true
      if is_xmse == false
        it "Verify the 'Header Navigation' button colors while on 'My Network' {selected = rgb(0, 124, 186) and not_selected = rgb(153, 153, 153)}" do
          @ui.goto_mynetwork
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(0, 124, 186)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(153, 153, 153)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(153, 153, 153)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(153, 153, 153)")
        end
        it "Verify the 'Header Navigation' button colors while on 'Profiles landing page' {selected = rgb(0, 124, 186) and not_selected = rgb(153, 153, 153)}" do
          @ui.view_all_profiles
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(153, 153, 153)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(0, 124, 186)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(153, 153, 153)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(153, 153, 153)")
        end
        it "Verify the 'Header Navigation' button colors while on 'Reports landing page' {selected = rgb(0, 124, 186) and not_selected = rgb(153, 153, 153)}" do
          @ui.view_all_reports
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(153, 153, 153)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(153, 153, 153)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(153, 153, 153)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(0, 124, 186)")
        end
      end
      it "Verify the 'Header Navigation' button colors while on 'Access Services landing page' {selected = rgb(0, 124, 186) and not_selected = rgb(153, 153, 153)}" do
        @ui.goto_all_guestportals_view
        sleep 1
        if is_xmse == true
          expect(@browser.execute_script("return $('#header_nav_arrays').css('color')")).to eq("rgb(153, 153, 153)")
        elsif is_xmse == false
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(153, 153, 153)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(153, 153, 153)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(153, 153, 153)")
        end
        expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(0, 124, 186)")
      end
      if is_xmse == true
        it "Verify the 'Header Navigation' button colors while on 'Access Points' {selected = rgb(0, 124, 186) and not_selected = rgb(153, 153, 153)}" do
          @ui.click('#header_nav_arrays')
          sleep 1
          expect(@browser.execute_script("return $('#header_nav_arrays').css('color')")).to eq("rgb(0, 124, 186)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(153, 153, 153)")
        end
      end
    elsif avaya_tenant == true
      if is_xmse == false
        it "Verify the 'Header Navigation' button colors while on 'My Network' {selected = rgb(204, 0, 0) and not_selected = rgb(86, 90, 92)}" do
          @ui.goto_mynetwork
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(204, 0, 0)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(86, 90, 92)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(86, 90, 92)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(86, 90, 92)")
        end
        it "Verify the 'Header Navigation' button colors while on 'Profiles landing page' {selected = rgb(204, 0, 0) and not_selected = rgb(86, 90, 92)}" do
          @ui.view_all_profiles
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(86, 90, 92)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(204, 0, 0)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(86, 90, 92)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(86, 90, 92)")
        end
        it "Verify the 'Header Navigation' button colors while on 'Reports landing page' {selected = rgb(204, 0, 0) and not_selected = rgb(86, 90, 92)}" do
          @ui.view_all_reports
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(86, 90, 92)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(86, 90, 92)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(86, 90, 92)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(204, 0, 0)")
        end
      end
      it "Verify the 'Header Navigation' button colors while on 'Access Services landing page' {selected = rgb(204, 0, 0) and not_selected = rgb(86, 90, 92)}" do
        @ui.goto_all_guestportals_view
        sleep 1
        if is_xmse == true
          expect(@browser.execute_script("return $('#header_nav_arrays').css('color')")).to eq("rgb(86, 90, 92)")
        elsif is_xmse == false
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(86, 90, 92)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(86, 90, 92)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(86, 90, 92)")
        end
        expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(204, 0, 0)")
      end
      if is_xmse == true
        it "Verify the 'Header Navigation' button colors while on 'Access Points' {selected = rgb(204, 0, 0) and not_selected = rgb(86, 90, 92)}" do
          @ui.click('#header_nav_arrays')
          sleep 1
          expect(@browser.execute_script("return $('#header_nav_arrays').css('color')")).to eq("rgb(204, 0, 0)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(86, 90, 92)")
        end
      end
    else
      if is_xmse == false
        it "Verify the 'Header Navigation' button colors while on 'My Network' {selected = rgb(0, 124, 186) and not_selected = rgb(89, 88, 89)}" do
          @ui.goto_mynetwork
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(0, 124, 186)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(89, 88, 89)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(89, 88, 89)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(89, 88, 89)")
        end
        it "Verify the 'Header Navigation' button colors while on 'Profiles landing page' {selected = rgb(0, 124, 186) and not_selected = rgb(89, 88, 89)}" do
          @ui.view_all_profiles
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(89, 88, 89)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(0, 124, 186)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(89, 88, 89)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(89, 88, 89)")
        end
        it "Verify the 'Header Navigation' button colors while on 'Reports landing page' {selected = rgb(0, 124, 186) and not_selected = rgb(89, 88, 89)}" do
          @ui.view_all_reports
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(89, 88, 89)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(89, 88, 89)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(89, 88, 89)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(0, 124, 186)")
        end
      end
      it "Verify the 'Header Navigation' button colors while on 'Access Services landing page' {selected = rgb(0, 124, 186) and not_selected = rgb(89, 88, 89)}" do
        @ui.goto_all_guestportals_view
        sleep 1
        if is_xmse == true
          expect(@browser.execute_script("return $('#header_nav_arrays').css('color')")).to eq("rgb(89, 88, 89)")
        elsif is_xmse == false
          expect(@browser.execute_script("return $('#header_mynetwork_link').css('color')")).to eq("rgb(89, 88, 89)")
          expect(@browser.execute_script("return $('#header_nav_profiles span').css('color')")).to eq("rgb(89, 88, 89)")
          expect(@browser.execute_script("return $('#header_nav_reports span').css('color')")).to eq("rgb(89, 88, 89)")
        end
        expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(0, 124, 186)")
      end
      if is_xmse == true
        it "Verify the 'Header Navigation' button colors while on 'Access Points' {selected = rgb(0, 124, 186) and not_selected = rgb(89, 88, 89)}" do
          @ui.click('#header_nav_arrays')
          sleep 1
          expect(@browser.execute_script("return $('#header_nav_arrays').css('color')")).to eq("rgb(0, 124, 186)")
          expect(@browser.execute_script("return $('#header_nav_guestportals span').css('color')")).to eq("rgb(89, 88, 89)")
        end
      end
    end
  end
end

shared_examples "reset password" do
  describe "Verify the 'Reset Password' Logo and colors" do
    it "Verify the 'Reset Password' Logo uses the image 'img/Riverbed_Xirrus_logo.svg'" do
      @ui.css('#header_nav_user').wait_until_present
      @ui.click('#header_nav_user')
      sleep 1
      @ui.css('#header_settings_link').wait_until_present
      @ui.click('#header_settings_link')
      @ui.id('settings_view').wait_until_present
      @ui.id('myaccount_changepassword_btn').wait_until_present
      @ui.click('#myaccount_changepassword_btn')
      @ui.css('.modal-change-password').wait_until_present
      #expect(@browser.execute_script("return $('.modal-change-password .logo').css('background-image')")).to include("/img/Riverbed_Xirrus_logo.svg")
      expect(@ui.css(".modal-change-password .logo")).not_to exist
    end
    it "Verify color for the header is 'rgb(0, 124, 186)'" do
      expect(@browser.execute_script("return $('.modal-change-password xc-modal-header').css('background-color')")).to eq("rgb(0, 124, 186)")
    end
    it "Close the modal" do
      @ui.click('.modal-change-password .xc-modal-close')
      @ui.css('.modal-change-password').wait_while_present
    end
  end
end

shared_examples "tenant scoping dropdown" do
  describe "Verify the 'Tenant Scoping' dropdown" do
    it "Verify that the 'Tenant Scoping' dropdown has the icon '/img/site.svg'" do
      expect(@browser.execute_script("return $('#tenant_scope_options .arrow').css('background-image')")).to include("/img/site.svg")
    end
    it "Open the 'Tenant Scoping' dropdown list" do
      @ui.click('#tenant_scope_options .arrow')
      @ui.css('.ko_dropdownlist_list.active').wait_until_present
    end
    it "Verify that the a parent tenant has the icon '/img/house.svg'" do
      expect(@browser.execute_script("return $('.ko_dropdownlist_list.active ul .dd-parent span').css('background-image')")).to include("/img/house.svg")
    end
    it "Verify that the a child tenant has the icon '/img/site.svg'" do
      expect(@browser.execute_script("return $('.ko_dropdownlist_list.active ul .dd-child span').css('background-image')")).to include("/img/site.svg")
    end
    it "Close the 'Tenant Scopint' dropdown list" do
      @browser.execute_script("$('.ko_dropdownlist_list.active').removeClass('active')")
      @browser.execute_script("$('#ko_dropdownlist_overlay').hide()")
    end
  end
end

shared_examples "login forgot password pages" do
  describe "Verify the 'Login Page'" do
    it "Logout of the application" do
      @ui.css('#header_nav_user').wait_until_present
      @ui.click('#header_nav_user')
      @ui.css('#header_logout_link').wait_until_present
      @ui.click('#header_logout_link')
      @ui.css('.login_form').wait_until_present
    end
    it "Verify that the background image is '/assets/images/riverbed.svg'" do
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('body')).getPropertyValue('background-image');")).to include("/assets/images/riverbed.svg")
    end
    it "Verify that the background image is properly displayed on the entire screen" do
      expect(@browser.execute_script("return document.getElementsByTagName('body')[0].clientHeight")).to be_between(750, 1500)
      #expect(@browser.execute_script("return document.getElementsByTagName('body')[0].clientHeight")).to eq(@browser.execute_script("return document.getElementsByTagName('html')[0].clientHeight"))
    end
    it "Verify the Login Logo is '/assets/images/riverbed-xirrus-logo.svg'" do
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('.header')).getPropertyValue('background-image');")).to include("/assets/images/riverbed-xirrus-logo.svg")
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('.header')).getPropertyValue('height');")).to include("57px")
    end
    it "Verify that the 'LOG IN' button's color is 'rgb(238, 112, 54)'" do
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('.submitBtn')).getPropertyValue('background-color');")).to eq("rgb(238, 112, 54)")
    end
    it "Verify that the 'Username' input does not show the 'username-gray.svg' icon" do
      expect(@ui.css('.username .icon')).to exist
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('.username .icon')).getPropertyValue('height');")).to include("0px")
    end
    it "Verify that the 'Password' input does not show the 'password-gray.svg' icon" do
      expect(@ui.css('.password .icon')).to exist
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('.password .icon')).getPropertyValue('height');")).to include("0px")
    end
    it "Verify that the 'Forgot Password?' link has the color 'rgb(36, 117, 187)'" do
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('#forgot a')).getPropertyValue('color');")).to eq("rgb(36, 117, 187)")
    end
  end
  describe "Verify the 'Forgot Password' page" do
    it "Go to the 'Forgot Password' page" do
      @ui.click('#forgot a')
      @ui.css('#forgot').wait_while_present
      @ui.css('.login_form').wait_until_present
    end
    it "Verify that the background image is '/assets/images/riverbed.svg'" do
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('body')).getPropertyValue('background-image');")).to include("/assets/images/riverbed.svg")
    end
    it "Verify that the background image is properly displayed on the entire screen" do
      expect(@browser.execute_script("return document.getElementsByTagName('body')[0].clientHeight")).to be_between(750, 1500)
      #expect(@browser.execute_script("return document.getElementsByTagName('body')[0].clientHeight")).to eq(@browser.execute_script("return document.getElementsByTagName('html')[0].clientHeight"))
    end
    it "Verify the Login Logo is '/assets/images/riverbed-xirrus-logo.svg'" do
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('.header')).getPropertyValue('background-image');")).to include("/assets/images/riverbed-xirrus-logo.svg")
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('.header')).getPropertyValue('height');")).to include("57px")
    end
    it "Verify that the 'Username' input does not show the 'username-gray.svg' icon" do
      expect(@ui.css('.username .icon')).to exist
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('.username .icon')).getPropertyValue('height');")).to include("0px")
    end
    it "Verify that the 'RESET PASSWORD' button's color is 'rgb(238, 112, 54)'" do
      expect(@browser.execute_script("return window.getComputedStyle(document.querySelector('.submitBtn')).getPropertyValue('background-color');")).to eq("rgb(238, 112, 54)")
    end
  end
end

shared_examples "xmse access points link" do
  describe "Verify that the 'Access points' link on an XMSE tenant does not show the '.blue-help' icon" do
    it "The '.blue-help' icon is not displayed near the 'access Points' link" do
      expect(@ui.css('#header_arrays_link .blue-help')).not_to exist
    end
  end
end

shared_examples "xirrus tenant" do |is_xmse, eircom_tenant, avaya_tenant|
  it_behaves_like "header color"
  it_behaves_like "header logo"
  it_behaves_like "header help control", false, false
  #it_behaves_like "footer elements"
  it_behaves_like "reset password"
  if is_xmse == false
    it_behaves_like "whats new icon", eircom_tenant, avaya_tenant
    it_behaves_like "header navigation", true, false, eircom_tenant, avaya_tenant
    it_behaves_like "login forgot password pages"
  else
    it_behaves_like "header navigation", false, true, eircom_tenant, avaya_tenant
    it_behaves_like "xmse access points link"
  end
end

shared_examples "eircom avaya tenant" do |is_xmse, eircom_tenant, avaya_tenant|
  it_behaves_like "header help control", eircom_tenant, avaya_tenant
  if is_xmse != true
    it_behaves_like "whats new icon", eircom_tenant, avaya_tenant
  end
  it_behaves_like "header navigation", false, is_xmse, eircom_tenant, avaya_tenant
end