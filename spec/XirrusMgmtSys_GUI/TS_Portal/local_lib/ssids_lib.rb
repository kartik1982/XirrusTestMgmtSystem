require_relative "portal_lib.rb"

shared_examples "go to portal" do |portal_name|
  describe "Go to the portal named '#{portal_name}' and then to the SSIDs tab" do
    it "Go to the portal named '#{portal_name}'" do
      # make sure it goes to the portal
      navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
    end
    it "Go to the SSIDs tab" do
      @ui.click('#guestportal_config_tab_ssids')
      sleep 2
      expect(@browser.url).to include('/config/ssids')
    end
  end
end

shared_examples "add ssid to portal" do |portal_name, portal_type, ssid_name|
  describe "Add the SSID named '#{ssid_name}' to the portal named '#{portal_name}'" do
    it "Add the SSID named '#{ssid_name}' to the portal" do
      @ui.click('#ssid_addnew_btn')
      sleep 1
      @ui.click('#add_ssids .lhs ul li')
      sleep 1
      @ui.click('#ssids_add_modal_move_btn')
      @ui.click('#ssids_add_modal_addssids_btn')
      if(portal_type=="onboarding")
          @ui.confirm_dialog
          sleep 1
      end
      sleep 2
      expect(@ui.css('#ssid_add_modal')).not_to be_visible
    end
    it "Save the portal" do
      @ui.save_guestportal
      sleep 1
      if(portal_type=="voucher")
          @ui.click('#manageguests_vouchermodal .buttons .orange')
          sleep 1
      end
    end
  end
end

shared_examples "verify ssid name and profile name" do |ssid_name, profile_name, facebook|
  describe "Verify that the portal shows the '#{ssid_name}' SSID as beloging to the profile '#{profile_name}'" do
    if facebook == true
      it "Verify that the application does not show any SSID assigned to the portal" do
        @ui.save_guestportal
        sleep 2
        expect(@ui.css('.nssg-tbody tr')).not_to exist
      end
    else
      it "Verify SSID and profile" do
        name = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) div')
        name.wait_until_present
        expect(name.title).to eq(ssid_name)
        profile = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(4) div')
        profile.wait_until_present
        expect(profile.title).to eq(profile_name)
      end
    end
  end
end

shared_examples "check for encryption/auth update to SSID for onboarding" do |profile_name, portal_name|
  describe "check for encryption/auth update to SSID for onboarding" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.css('#profile_config_tab_ssids').wait_until_present
      @ui.click('#profile_config_tab_ssids')
    end
    it "check for encryption/auth update to SSID for onboarding" do
        eauth_val = @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth .nssg-td-text')
        eauth_val.wait_until_present
        expect(eauth_val.title).to eq('WPA2/802.1x')
        portal = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-text')
        portal.wait_until_present
        expect(portal.title).to eq(portal_name)
    end
  end
end

shared_examples "update portal ssids settings" do |portal_name, portal_type, profile_name, ssid_name, facebook|
  it_behaves_like "go to portal", portal_name
  it_behaves_like "add ssid to portal", portal_name, portal_type, ssid_name
  it_behaves_like "verify ssid name and profile name", ssid_name, profile_name, facebook
end