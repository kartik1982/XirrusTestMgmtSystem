shared_examples "go to the access control tab" do |portal_name|
  describe "Go to the tab 'Access Control'" do
    it "Go to portal" do
      @ui.goto_guestportal(portal_name)
    end
    it "Verify that the 'Access Control' tab is visible, click on it and verify that the navigation worked properly" do
      expect(@ui.id('profile_name').text).to eq(portal_name)
      expect(@ui.css('#profile_tabs a:nth-child(3) .name').text).to eq("Access Control")
      sleep 0.5
      @ui.click('#profile_tabs a:nth-child(3) .name')
      sleep 1
      @ui.css('.manageguests').wait_until(&:present?)
      expect(@browser.url).to include("/acl")
    end
  end
end

shared_examples "verify the access control tab elements" do |portal_name|
  describe "Verify that the tab 'Access Control' has the proper elements on the portal '#{portal_name}'" do
    it "Verify main features are present" do
      expect(@ui.css('.manageguests')).to be_present
      expect(@ui.css('.manageguests .commonTitle span').text).to eq("EasyPass Portal")
      expect(@ui.css('.manageguests .commonSubtitle').text).to eq("Manage access for devices on your wireless network. Only devices whose MAC addresses are listed below will be allowed on the network. If no devices are listed, all devices will be allowed to connect.")
      expect(@ui.css('xc-grid')).to exist
      expect(@ui.css('xc-grid columnpicker .blue')).to be_present
      expect(@ui.css('xc-grid .xc-grid-header-section search .xc-search')).to be_present
      expect(@ui.css('xc-grid .xc-grid-header-section .nssg-refresh')).to be_present
      expect(@ui.css('xc-csv-menu .blue')).to be_present
      expect(@ui.id('guestportal-acl-addnew')).to be_present
    end
  end
end

shared_examples "create new device entry" do |mac_address, details|
  describe "Create a new Device entry in the grid having the MAC as '#{mac_address}' and the details '#{details}'" do
    it "Open the 'Add/Edit Device' slideout " do
      @ui.id('guestportal-acl-addnew').wait_until(&:present?)
      @ui.click("#guestportal-acl-addnew")
      sleep 1
      @ui.css('.ko_slideout_container.left.opened .ko_slideout_content').wait_until(&:present?)
    end
    it "Set the MAC address as '#{mac_address}' and details as '#{details}'" do
      @ui.set_input_val('#guestportal-acl-details-general-macaddress', mac_address)
      sleep 1
      @ui.set_textarea_val('#guestportal-acl-details-general-note', details)
      sleep 1
    end
    it "Press the <SAVE> button and close the slideout" do
      @ui.click('#guestportal-acl-save')
      sleep 2
      if @ui.css('ko_slideout_container.left.opened').exists?
        @ui.click('.ko_slideout_container.left.opened .ko_slideout_content .slideout-toggle')
        @ui.click('.ko_slideout_container.left.opened').wait_while_present
      end
    end
  end
end

shared_examples "delete a device entry" do |mac_address|
  describe "Delete the device entry with the MAC 'mac_address'" do
    it "xxx" do
      puts Time.now
      rows = @ui.css('.nssg-table tbody').trs
      rows.each do |row|
        if row.td(:class => "nssg-td nssg-td-text").text == mac_address
          row.td(:class => "nssg-td nssg-td-select").label.click
          break
        end
      end
      puts Time.now
      puts ""
      expect(@ui.css('#guestportal-acl-delete')).to be_present
      expect(@ui.css('.xc-grid-selection-bubble .count').text).to eq("1")
      expect(@ui.css('.xc-grid-selection-bubble div:nth-child(2)').text).to eq("Device Selected")
      @ui.click('#guestportal-acl-delete')
      @ui.css('.confirm').wait_until(&:present?)
      @ui.click('#_jq_dlg_btn_1')
      @ui.css('.confirm').wait_while_present
      sleep 2
      puts Time.now
      rows = @ui.css('.nssg-table tbody').trs
      rows.each do |row|
        expect(row.td(:class => "nssg-td nssg-td-text").text).not_to eq(mac_address)
      end
      puts Time.now
    end
  end
end

shared_examples "quick create 10000 device entries" do
  describe "Create 10000 new Device entry in the grid having the a random MAC and description" do
      it "Open the 'Add/Edit Device' slideout, set the random MAC address and random details then press the <SAVE> button and close the slideout " do
        random_mac_array = []
        10000.times do
          random_mac_array.push(XMS.random_mac)
        end
        random_mac_array.each_with_index do |mac_address, index|
          @ui.id('guestportal-acl-addnew').wait_until(&:present?)
          @ui.click("#guestportal-acl-addnew")
          @ui.css('.ko_slideout_container.left.opened .ko_slideout_content').wait_until(&:present?)
          @ui.set_input_val('#guestportal-acl-details-general-macaddress', mac_address)
          sleep 0.5
          @ui.set_textarea_val('#guestportal-acl-details-general-note', XMS.chars_255)
          sleep 0.5
          @ui.click('#guestportal-acl-save')
          sleep 1
          if @ui.css('ko_slideout_container.left.opened').exists?
            @ui.click('.ko_slideout_container.left.opened .ko_slideout_content .slideout-toggle')
            @ui.click('.ko_slideout_container.left.opened').wait_while_present
          end
          #expect(@ui.css('.nssg-paging-count strong:nth-child(2)').text.to_i).to eq(index+1)
        end
      end
  end
end