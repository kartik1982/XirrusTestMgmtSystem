require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"



def find_new_browser_tab_and_verify_help
  @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).wait_until_present
  @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).use do
    @browser.body(:css => "body").wait_until_present
    sleep 1.5
    return @browser.url
  end
end

shared_examples "test link" do |link|
  describe "Test that the help button navigates the user to the proper help page" do
    it "Test that the link is: #{link}" do
      @ui.get(:elements , {css: '.koHelpIcon'}).each do |help_icon|
        if !help_icon.parent.parent.attribute_value("class").include?('.alt-icon')
          help_icon.click
        end
      end
      #@ui.click('.koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include(link)
    end
    it "Close the 'Help' tab" do
      @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
  end
end

shared_examples "test map link" do
  describe "test map link" do
    it "Test map help link" do
        @ui.click('#header_mynetwork_link')
        sleep 3
        @ui.click('#dashboardHeader .maps a')
        sleep 1
    end

    it_behaves_like "test link", "#MapTop"
  end
end

shared_examples "test alerts link" do
  describe "test alerts link" do
    it "Test alerts help link" do
        @ui.click('#header_mynetwork_link')
        @ui.click('#mynetwork_tab_alerts')
        sleep 1
    end

    it_behaves_like "test link", "#Alerts"
  end
end

shared_examples "test profiles link" do
  describe "test profiles link" do
    it "Test profiles help link" do
        @ui.view_all_profiles
        sleep 1
    end

    it_behaves_like "test link", "#ProfilesTop"
  end
end

shared_examples "test profiles tab links" do |profile_name|
  describe "Test that the Profile tab links navigate the user to the proper help pages" do
    it "Navigate to the '#{profile_name}' profile" do
      @ui.goto_profile(profile_name)
      sleep 1
    end
    it "Verify that the General help link opens the proper help page" do
      sleep 1
      @ui.click('#profile_config_tab_general')
      sleep 1
      expect(@browser.url).to include("config/general")
      sleep 1
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ProfilesGeneral")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the SSID help link opens the proper help page" do
      sleep 1
      @ui.click('#profile_config_tab_ssids')
      sleep 4
      expect(@browser.url).to include("config/ssids")
      sleep 1
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ProfilesSSIDs")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the Network help link opens the proper help page" do
      sleep 1
      @ui.click('#profile_config_tab_network')
      sleep 1
      expect(@browser.url).to include("config/network")
      sleep 1
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ProfilesNetwork")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the Policies help link opens the proper help page" do
      sleep 1
      @ui.click('#profile_config_tab_policies')
      sleep 1
      expect(@browser.url).to include("config/policies")
      sleep 1
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ProfilesPolicies")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the Bonjour Director help link opens the proper help page" do
      sleep 1
      @ui.click('#profile_config_tab_bonjour')
      sleep 1
      expect(@browser.url).to include("config/bonjour")
      sleep 1
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ProfilesBonjour")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the Admin help link opens the proper help page" do
      sleep 1
      @ui.click('#profile_config_tab_admin')
      sleep 1
      expect(@browser.url).to include("config/admin")
      sleep 1
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ProfilesAdmin")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the Optimization help link opens the proper help page" do
      sleep 1
      @ui.click('#profile_config_advanced')
      sleep 1
      @ui.click('#profile_config_tab_optimization')
      sleep 1
      expect(@browser.url).to include("config/optimization")
      sleep 1
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ProfilesOptimization")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the Services help link opens the proper help page" do
      sleep 1
      @ui.click('#profile_config_tab_services')
      sleep 1
      expect(@browser.url).to include("config/services")
      sleep 1
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ProfilesServices")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
  end
end

shared_examples "test portals link" do
  describe "test portals link" do
    it "Test Portals landing page help link navigates the user to the proper help page" do
        @ui.goto_all_guestportals_view
        sleep 1
    end

    it_behaves_like "test link", "#GapTop"
  end
end

shared_examples "test portal pages links" do |name, portal_type|
  describe "Test that the Profile tab links navigate the user to the proper help pages" do
    it "Go to the portal named #{name}" do
      sleep 1
      navigate_to_portals_landing_page_and_open_specific_portal("tile",name,false)
      sleep 1
    end
    it "Ensure the application is on the proper profile (#{name}) on the General Configuration tab)" do
      @ui.click('#guestportal_config_tab_general')
      sleep 1
      expect(@ui.css('#profile_name').text).to eq(name)
      expect(@browser.url).to include("config/general")
    end
    it "Verify that the Edit Portal page help link opens the proper help page" do
      @ui.click('#profile_view .guestportal_heading .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#GapTop")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the General Configuration tab help link opens the proper help page" do
      sleep 2
      @ui.click('#guestportal_config_general_view .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#GapGeneral")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the Look & Feel tab help link opens the proper help page" do
      sleep 2
      @ui.click('#guestportal_config_tab_lookfeel')
      sleep 3
      @ui.click('#guestportal_config_lookfeel_view .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#GapLook")
    end
    it "Close the 'Help' tab" do
      @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the SSIDs tab help link opens the proper help page" do
      sleep 2
      @ui.click('#guestportal_config_tab_ssids')
      sleep 1
      @ui.click('#guestportal_config_ssids_view .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#GapSSIDs")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the Guest / Vouchers / Personal SSIDs tab help link opens the proper help page (portal type = #{portal_type})" do
      sleep 1
      @ui.click('#profile_tabs a:nth-child(2)')
      sleep 3
      @ui.click('#guestportal_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      case portal_type
        when "self_reg", "ambassador"
          expect(browser_url).to include("#GapGuests")
        when "onetouch"
          expect(browser_url).to include("#GapClick")
        when "onboarding"
          expect(browser_url).to include("#GapOnboardUsers")
        when "voucher"
            expect(browser_url).to include("#GapVouchers")
        when "personal"
          expect(browser_url).to include("#GapPersonalWiFi")
        when "google"
          expect(browser_url).to include("#GapGoogle")
        else
          puts 'Type not defined'
      end
    end
    it "Close the 'Help' tab" do
      @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
  end
end

shared_examples "test reports link" do
  describe "test reports link" do
    it "Test reports link" do
        @ui.view_all_reports
        sleep 1
    end
    it_behaves_like "test link", "#ReportsTop"
  end
end

shared_examples "test report pages links" do
  describe "Test that the Profile tab links navigate the user to the proper help pages" do
    it "Go to the 'Application Visibility Report'" do
      sleep 3
      @ui.goto_report("Application Visibility Report")
      sleep 1
    end
    it "Verify the 'View, Using and Modifying Reports' page help link opens the proper help page" do
      sleep 2
      @ui.click('#main_container #profile_view .report-preview-header .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ReportsDetailView")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify the 'Edit Reports' page help link opens the proper help page" do
      sleep 1
      @ui.click('#report_menu_btn')
      sleep 1
      @ui.click('.drop_menu_nav #report_edit')
      sleep 2
      expect(@browser.url).to include("/config")
      sleep 1
      @ui.click('#main_container #profile_view .report-config-header .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ReportsTemplateEdit")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify the 'Create Report' page help link opens the proper help page" do
      sleep 1
      @ui.click('#header_nav_reports')
      sleep 1
      @ui.click('#header_new_reports_btn')
      sleep 1
      expect(@browser.url).to include("/config")
      sleep 1
      @ui.click('#main_container #profile_view .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#ReportsTemplateEdit")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
  end
end

shared_examples "test CommandCenter top link" do
  describe "Test that the CommandCenter top link navigates the user to the proper help page" do
    it "Home" do
      @ui.click('#header_logo')
    end
    #it_behaves_like "go to CommandCenter"
    it_behaves_like "test link", "#CommandCenterTop"
  end
end

shared_examples "test CommandCenter tab links" do
  describe "Test that the CommandCenter tab links navigate the user to the proper help pages" do
    before :all do
        @ui.click('.user-icon')
        sleep 1
        @ui.click('#header_msp_link')
        sleep 1
    end
    it "Verify that the Domains help link opens the proper help page" do
      @ui.click('#msp_tab_accounts')
      sleep 2
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#CommandCenterDomains")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the Administrators help link opens the proper help page" do
      @ui.click('#msp_tab_users')
      sleep 2
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#CommandCenterAdmins")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
    it "Verify that the Arrays help link opens the proper help page" do
      @ui.click('#msp_tab_arrays')
      sleep 2
      @ui.click('#main_container .tabs_container .commonTitle .koHelpIcon')
      browser_url = find_new_browser_tab_and_verify_help
      expect(browser_url).to include("#CommandCenterAPs")
    end
    it "Close the 'Help' tab" do
        @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html/).close
    end
  end
end
