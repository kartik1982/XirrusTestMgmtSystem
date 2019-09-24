shared_examples "add access points to account" do |ap_sn, ap_hostname, ap_location|
  describe "Add the AP with '#{ap_sn}' to an account" do
    it "Ensure you are on the 'Provisioned' tab" do
      if !@browser.url.include?("/#mynetwork/aps/provisioned")
        @ui.click('#header_mynetwork_link')
        sleep 1
        @ui.click('#mynetwork_tab_arrays')
        sleep 1
        @ui.css("#arrays_grid .nssg-table").wait_until_present
        sleep 1
        @ui.css("#profile_config_tab_provisioned").click
      end
    end
    it "Add the AP with the SN '#{ap_sn}', hostname of '#{ap_hostname}' and location '#{ap_location}'" do
      @ui.click("#mynetwork-arrays-provisioned .top-right .orange")
      sleep 1
      expect(@ui.css('#xmodal-aps-addnew')).to be_present
      @ui.set_input_val(".xmodal-aps-addnew-serial", ap_sn)
      sleep 0.5
      @ui.set_input_val(".xmodal-aps-addnew-hostname", ap_hostname)
      sleep 0.5
      @ui.set_input_val(".xmodal-aps-addnew-location", ap_location)
      sleep 0.5
      @ui.click("#xmodal-aps-addnew-addapsbtn")
      sleep 1
      expect(@ui.css('#xmodal-aps-addnew')).not_to be_present
    end
    it "Search trough the grid until you find the entry with SN '#{ap_sn}'" do
      @ui.grid_verify_strig_value_on_specific_line_by_column_name("Serial Number", ap_sn, "div", "2", "div", ap_sn)
    end
  end
end

shared_examples "delete certain Access Points using serial number" do |ap_sn|
  describe "Delete the AP with the Serial Number '#{ap_sn}'" do
    it "Place a tick for the line that has the SN '#{ap_sn}'" do
      @ui.grid_tick_on_specific_line("2", ap_sn, "div")
    end
    it "Press the delete button and confirm the deletion" do
      ap_number_before = @ui.css(".nssg-paging .nssg-paging-count strong:last-child").text.to_i
      sleep 0.5
      @ui.click('#arrays-delete-btn')
      sleep 2
      @ui.click('#_jq_dlg_btn_1')
      sleep 2
      @ui.click(".nssg-refresh")
      sleep 0.2
      while @ui.css('#mynetwork-arrays-provisioned grid .nssg-wrap').attribute_value("class") == "nssg-wrap isLoading"
        sleep 0.5
      end
      ap_number_after = @ui.css(".nssg-paging .nssg-paging-count strong:last-child").text.to_i
      expect(ap_number_before).not_to eq(ap_number_after)
      expect(ap_number_before > ap_number_after).to eq(true)
    end
  end
end

shared_examples "verify access point import" do
  describe "Verify that a .csv file with 10 entries can be imported" do
    it "Import the file 'import_accesspoints.csv' to the tenant" do
      if @ui.css('.nssg-paging .nssg-paging-count').exists?
        ap_number_before = @ui.css(".nssg-paging .nssg-paging-count strong:last-child").text.to_i
      else
        ap_number_before = 0
      end
      file = Dir.pwd + "/import_accesspoints.csv"
      @browser.execute_script('$(\'#provisioned_importallcsv_btn ~ .moxie-shim input[type="file"]\').css({"opacity":"1"})')
      @browser.execute_script('$(\'#provisioned_importallcsv_btn ~ .moxie-shim input[type="file"]\').click()')
      sleep 2
      @browser.file_field(:css,"input[type='file']").set(file)
      sleep 2
      @browser.execute_script('$(\'#provisioned_importallcsv_btn ~ .moxie-shim input[type="file"]\').hide()')
      sleep 4
      ap_number_after = @ui.css(".nssg-paging .nssg-paging-count strong:last-child").text.to_i
      expect(ap_number_before).not_to eq(ap_number_after)
      expect(ap_number_before + 10).to eq(ap_number_after)
    end
    it "Verify that the grid shows the entries 'AUTO000000001' to 'AUTO000000010'" do
      (1..10).each do |i|
        if i != 10
          expect(@ui.grid_verify_strig_value_on_specific_line_by_column_name("Serial Number", "AUTO00000000#{i}", "div", "2", "div", "AUTO00000000#{i}")).to eq("AUTO00000000#{i}")
        else
          expect(@ui.grid_verify_strig_value_on_specific_line_by_column_name("Serial Number", "AUTO0000000#{i}", "div", "2", "div", "AUTO0000000#{i}")).to eq("AUTO0000000#{i}")
        end
        expect($search_failed_booleand).to eq(nil)
      end
    end
  end
end

shared_examples "verify access point provision panel" do
  describe "verify access point provision panel" do
    it "Ensure you are on the 'Provisioned' tab" do
      if !@browser.url.include?("/#mynetwork/aps/provisioned")
        @ui.click('#header_mynetwork_link')
        sleep 1
        @ui.click('#mynetwork_tab_arrays')
        sleep 1
        @ui.css("#arrays_grid .nssg-table").wait_until_present
        sleep 1
        @ui.css("#profile_config_tab_provisioned").click
      end
    end
    it "verify access point provision panel" do
      expect(@ui.css("#mynetwork-arrays-provisioned .commonTitle").text).to eq("Provisioned Access Points")
      expect(@ui.css("#mynetwork-arrays-provisioned .commonSubtitle").text).to eq("Manage your provisioned Access Points.")
      expect(@ui.css("#provisioned_importallcsv_btn").present?).to eq(true)
      expect(@ui.css("#provisioned_importallcsv_btn").text).to eq("Import")
      expect(@ui.css("#mynetwork-arrays-provisioned .top-right button.orange").present?).to eq(true)
      expect(@ui.css("#mynetwork-arrays-provisioned .top-right button.orange").text).to eq("+ ADD AP TO ACCOUNT")
      expect(@ui.css("#mynetwork-arrays-provisioned .nssg-refresh").present?).to eq(true)
    end
  end
end
shared_examples "verify duplicate sn error message" do |serial_number|
  describe "Verify that the application properly shows the 'Duplicate SN' error message" do
    it "Try to add the AP with Serial Number '#{serial_number}'" do
      @ui.click("#mynetwork-arrays-provisioned .top-right .orange")
      sleep 1
      expect(@ui.css('#xmodal-aps-addnew')).to be_present
      @ui.set_input_val(".xmodal-aps-addnew-serial", serial_number)
      sleep 0.5
      @ui.set_input_val(".xmodal-aps-addnew-hostname", "Hostname-" + UTIL.ickey_shuffle(9))
      sleep 0.5
      @ui.set_input_val(".xmodal-aps-addnew-location", "Location " + UTIL.ickey_shuffle(9))
      sleep 0.5
      expect(@ui.css("#xmodal-aps-addnew-addapsbtn").attribute_value("disabled")).to eq("true")
      expect(@ui.css("#xmodal-aps-addnew-addapsbtn")).to be_visible
      sleep 1
      expect(@ui.css('#xmodal-aps-addnew')).to be_present
      expect(@ui.css('.xmodal-aps-addnew-item .xc-field:nth-child(1) .xirrus-error')).to be_visible
      expect(@ui.css('.xmodal-aps-addnew-item .xc-field:nth-child(1) .xirrus-error').text).to eq("Duplicate serial number")
      sleep 1
      @ui.click('#xmodal-aps-addnew_closemodalbtn')
      sleep 2
      expect(@ui.css('#xmodal-aps-addnew')).not_to be_present
    end
    it "Try to reead the AP with Serial Number '#{serial_number}'" do
      @ui.click("#mynetwork-arrays-provisioned .top-right .orange")
      sleep 1
      expect(@ui.css('#xmodal-aps-addnew')).to be_present
      @ui.set_input_val(".xmodal-aps-addnew-serial", serial_number)
      sleep 0.5
      @ui.click(".xmodal-aps-addnew-message")
      sleep 0.5
      expect(@ui.css('.xmodal-aps-addnew-item .xc-field:nth-child(1) .xirrus-error')).to be_visible
      expect(@ui.css('.xmodal-aps-addnew-item .xc-field:nth-child(1) .xirrus-error').text).to eq("Duplicate serial number")
      expect(@ui.get(:button , { id: 'xmodal-aps-addnew-addapsbtn'}).enabled?).to eq(false)
      sleep 0.5
      @ui.click('#xmodal-aps-addnew-cancelbtn')
      sleep 1
      expect(@ui.css('#xmodal-aps-addnew')).not_to be_present
    end
  end
end

shared_examples "verify invalid sn error message" do
  describe "Verify that the application shwos the proper error message when 'TEST_INVALID' is used as SN" do
    it "Verfiy that the application properly reponds" do
      @ui.click("#mynetwork-arrays-provisioned .top-right .orange")
      sleep 1
      expect(@ui.css('#xmodal-aps-addnew')).to be_present
      @ui.set_input_val(".xmodal-aps-addnew-serial", "TEST_INVALID")
      sleep 1
      @ui.click(".xmodal-aps-addnew-hostname")
      sleep 0.5
      expect(@ui.css('.xmodal-aps-addnew-item .xc-field:nth-child(1) .xirrus-error')).to be_visible
      expect(@ui.css('.xmodal-aps-addnew-item .xc-field:nth-child(1) .xirrus-error').text).to eq("Invalid serial number")
      expect(@ui.get(:button , { id: 'xmodal-aps-addnew-addapsbtn'}).enabled?).to eq(false)
      sleep 0.5
      @ui.click('#xmodal-aps-addnew-cancelbtn')
      sleep 1
      expect(@ui.css('#xmodal-aps-addnew')).not_to be_present
    end
  end
end
shared_examples "verify improper import" do
  describe "Verify that a .csv file with 100 entries can't be imported" do
    it "Try to import the file 'import_avaya_100_aps.csv' to the tenant" do
      ap_number_before = @ui.css(".nssg-paging .nssg-paging-count strong:last-child").text.to_i
      file = Dir.pwd + "/import_100_accesspoints.csv"
      @browser.execute_script('$(\'input[type="file"]\').css({"opacity":"1"})')
      @browser.execute_script('$(\'input[type="file"]\').click()')
      sleep 2
      @browser.file_field(:css,"input[type='file']").set(file)
      sleep 2
      @browser.execute_script('$(\'input[type="file"]\').hide()')
      sleep 4
      ap_number_after = @ui.css(".nssg-paging .nssg-paging-count strong:last-child").text.to_i
      expect(ap_number_before).to eq(ap_number_after)
    end
  end
end

shared_examples "verify accesspoints provision slot bar chart" do |used_slot, total_slot|
  describe "verify accesspoints provision slot bar chart for used_slot-#{used_slot} out of #{total_slot}" do
    it "verify that bar chart is displyed on GUI" do
      expect(@ui.css("xc-meter .c-meter").present?).to eq(true)
      expect(@ui.css("#backoffice_arrays .commonTitle span:nth-child(2)").text).to eq("Access Points") 
      expect(@ui.css("xc-meter .c-meter span.value").text).to eq("#{used_slot} of #{total_slot}")      
    end
  end  
end
