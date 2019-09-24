require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"

shared_examples "verify switches column" do |column|
	describe "Verify switches on the 'Switches' tab and column #{column}" do
		it "Verify that the #{column} column exists" do
			@ui.find_grid_header_by_name_support_management(column)
			$column_string = ".nssg-thead tr:nth-child(1) th:nth-child(#{$header_count})"
			expect(@ui.css("#{$column_string}")).to exist
			expect(@ui.css("#{$column_string}")).to be_visible
		end
	end
end

def switch_grid_restore_default
  #TBD- willl wait for ID to be finilize  
end
shared_examples "assign switch(es) to profile" do |profile_name, switch_serial_numbers|
  describe "Assign the Switch(es) in the My Network - Switch tab to the profile named #{profile_name}" do
    before :all do
      go_to_my_network_switches_tab
    end
    it "assign switches to the #{profile_name} profile" do
      switch_grid_restore_default
      #loop to tick all switches by serial number
      switch_serial_numbers.each do |switch_sn|
        css_path = @ui.grid_tick_on_specific_line("4", switch_sn, "a")
        expect(css_path).not_to eq(nil)
        sleep 1
      end
      #move to profile
      @ui.click('.moveto_button')
      sleep 1
      items = @ui.css('.move_to_nav .items')
      items.wait_until(&:present?)
      item = items.a(:text => profile_name)
      item.wait_until(&:present?)
      item.click
      sleep 1
      @ui.confirm_dialog
    end
    it "Expect the Profile cell to have the value #{profile_name}" do
      switch_serial_numbers.each do |switch_sn|
        expect(@ui.grid_verify_strig_value_on_specific_line("4", switch_sn, "a", "5", "a", profile_name)).to eq(profile_name)
      end      
    end
  end
end
shared_examples "unasign Switch(es) from profile" do |switch_serial_numbers|
  describe "unasign access points from profile" do
    before :all do
      go_to_my_network_switches_tab
    end
    it "unasign switch(es) from profile" do
       #loop to tick all switches by serial number
      switch_serial_numbers.each do |switch_sn|
        css_path = @ui.grid_tick_on_specific_line("4", switch_sn, "a")
        expect(css_path).not_to eq(nil)
        sleep 1
      end
      sleep 1
      @ui.click('.moveto_button')
      sleep 1
      @ui.click('#switches_moveto_00000000-0000-0000-0000-000000000000')
      sleep 1
      @ui.confirm_dialog
    end
    it "Expect the Profile cell to not have any value (be unassigned)" do
      switch_serial_numbers.each do |switch_sn|
        expect(@ui.grid_verify_strig_value_on_specific_line("4", switch_sn, "a", "5", "a", "")).to eq("")
      end 
    end
  end
end

shared_examples "General switch and port panel verification" do |switch_model, switch_sn, switch_hostname|
  describe "Verify general Switch details and Port details panel for model-#{switch_model} with serial number #{switch_sn}" do
    if switch_model=="XS-6012P"
      switch_details=[{bank_name: "PoE+ 1G", bank_ports: 12, port_offset: 0}, {bank_name: "SFP 1G", bank_ports: 2, port_offset: 12}]
    end
    if switch_model=="XS-6024MP"
      switch_details=[{bank_name: "High Power PoE 2.5G", bank_ports: 8, port_offset: 0}, {bank_name: "PoE+ 1G", bank_ports: 16, port_offset: 8}, {bank_name: "SFP+ 10G",bank_ports: 4, port_offset: 24}]
    end
    if switch_model=="XS-6048MP"
      switch_details=[{bank_name: "High Power PoE 2.5G", bank_ports: 16, port_offset: 0}, {bank_name: "PoE+ 1G", bank_ports: 14, port_offset: 16}, {bank_name: "PoE+ 1G", bank_ports: 18, port_offset: 30}, {bank_name: "SFP+ 10G",bank_ports: 4, port_offset: 48}]
    end
    it "Navigate to mynetowkr->Switch tab and open Switch edit/view panel" do
      @browser.refresh
      @ui.css("#mynetwork_tab_switches").click
      sleep 2
      @ui.grid_action_on_specific_line("4", "a", switch_sn, "click_model")
      sleep 2
    end
      # include_examples "Verify switch edit view detail panel for port banks", switch_hostname, switch_details
    it "Verify switch edit view details panel" do 
      banks = @browser.elements(:css, "xc-switch-details .switch-unit span table")
      banks.each_with_index  do|bank, i|
        expect(bank.element(:css, "caption span").text).to eq(switch_details[i][:bank_name])
        expect(bank.elements(:css, "tbody td").length).to eq(switch_details[i][:bank_ports])
        ports = bank.elements(:css, "tbody td")
        ports_per_row=ports.length/2
        ports.each_with_index do |port, x|
          if x < ports_per_row
            expect(port.element(:css, ".cell-header").text).to eq((x*2+1+switch_details[i][:port_offset]).to_s);
          else
            expect(port.element(:css, ".cell-header").text).to eq(((x-ports_per_row)*2+2+switch_details[i][:port_offset]).to_s);
          end          
        end               
      end
    end
  end #describe
end #shared_examples


shared_examples "General Switch Port Template general tab" do |port_template_name, port_template_desc|
  describe "General Switch Port Template general tab" do
    it "navigate to Switch port template gride panel" do
      goto_switch_port_template
      @browser.element(:link, "Port Templates").click
      sleep 0.5
    end
    it "Delete all existing port templates" do
      sleep 1
      delete_all_switch_port_templates
    end
    
    it "Add new template name- #{port_template_name}" do
      @ui.css("#new_switch_port_templates_btn").click
      @ui.css("xc-slideout-content").wait_until(&:present?)
      @ui.set_input_val("#switch-port-template-name",port_template_name)
      @ui.set_input_val("#switch-port-template-description", port_template_desc)
      @ui.css(".switch-port-select-icon").click
      sleep 0.2
      @ui.css(".switch-port-icon.antenna").click
      sleep 0.2      
      @ui.css(".switch-port-select-icon").click
      @ui.css("#switch-port-template-save").click
      @ui.css(".msgbody").wait_until(&:present?)
      expect(@ui.css(".msgbody").text).to eq("Network switch port template saved successfully.")
      @ui.css(".msgbody").wait_while_present
    end 
    it "Verify Switch Port general tab" do   
        sleep 1
        goto_switch_port_template_setting(port_template_name)
        expect(@ui.get(:text_field, {id: "switch-port-template-name"}).value).to eq(port_template_name)
        expect(@ui.get(:text_field, {id: "switch-port-template-description"}).value).to eq(port_template_desc)
        expect(@ui.css(".switch-port-icon").attribute_value("class")).to include("antenna")
        @ui.css(".slideout-collapse-toggle-btn").click
      end
  end #describe
end #shared_examples

shared_examples "General Switch Port Template configuration tab" do |port_template_name|
  describe "General Switch Port Template configuration tab" do
    it "navigate to Switch port template gride and open template name - #{port_template_name}" do
      @ui.go_to_switch_templates_tile
      @browser.element(:link, "Port Templates").click
      sleep 0.5
      goto_switch_port_template_setting(port_template_name)
      @ui.css("#switch-port-template-slideout-tab-port-settings").click
      sleep 1
    end
    it "Verify General Switch port Template configuration tab" do
        Verify_switch_port_details_panel(nil, nil)
    end
  end
end

shared_examples "switch reboot feature" do |status, profile_name, switch_sn|
  describe "Verify switch reboot feature from profile and mynetowork switch tab" do
    it "Go to the profile named '#{profile_name}'" do
      @ui.go_to_profile_tile(true)
      @ui.goto_profile profile_name
      sleep 2
      @ui.click('#profile_tab_switches')
      sleep 1.5
      expect(@browser.url).to include('/#profiles/')
      expect(@browser.url).to include('/switches')
    end
    it "select switch to reboot" do
      sleep 1
      css_path= @ui.grid_tick_on_specific_line("4", switch_sn, "a")
      expect(css_path).not_to eq(nil)
      sleep 1
    end
    it "verify reboot option is active when switch is online status" do
      @ui.click('#arrays_more_btn')
      expect(@ui.css('#switches-menu-reboot').text).to eq("Reboot")
      sleep 0.5
      if status == "offline"
        expect(@ui.css('#switches-menu-reboot').attribute_value('class')).to include("disabled")
      else
        expect(@ui.css('#switches-menu-reboot').attribute_value('class')).not_to include("disabled")
        @ui.css('#switches-menu-reboot').click
        sleep 1
        @ui.css('.dialogOverlay.confirm').wait_until(&:present?)
        expect(@ui.css('.dialogBox .title').text).to eq("Reboot Switches?")
        expect(@ui.css('.dialogBox .msgbody div').text).to eq("Access points and all other devices will be disconnected from Switch during reboot. Are you sure you want to reboot the selected Switch?\n\nNote: Only Switches that are currently online will be rebooted.")
        expect(@ui.css('.dialogBox #confirmButtons #_jq_dlg_btn_0').text).to eq("Cancel")
        expect(@ui.css('.dialogBox #confirmButtons #_jq_dlg_btn_1').text).to eq("REBOOT SWITCH")
        @ui.css('.dialogBox #confirmButtons #_jq_dlg_btn_1').click
        @ui.css('.dialogOverlay .success').wait_until(&:present?)
        expect(@ui.css('.dialogOverlay .success .msgbody div').text).to eq("Switch reboot triggered\nChanges will take effect momentarily")
      end   
   end
   it "navigate to mynetowkr switch tab" do
     go_to_my_network_switches_tab
   end
    it "select switch to reboot" do
      sleep 1
      css_path = @ui.grid_tick_on_specific_line("4", switch_sn, "a")
      expect(css_path).not_to eq(nil)
      sleep 1
    end
    it "verify reboot option is active when switch is online status" do
      @ui.click('#arrays_more_btn')
      expect(@ui.css('#switches-menu-reboot').text).to eq("Reboot")
      sleep 0.5
      if status == "offline"
        expect(@ui.css('#switches-menu-reboot').attribute_value('class')).to include("disabled")
      else
        expect(@ui.css('#switches-menu-reboot').attribute_value('class')).not_to include("disabled")
        @ui.css('#switches-menu-reboot').click
        sleep 1
        @ui.css('.dialogOverlay.confirm').wait_until(&:present?)
        expect(@ui.css('.dialogBox .title').text).to eq("Reboot Switches?")
        expect(@ui.css('.dialogBox .msgbody div').text).to eq("Access points and all other devices will be disconnected from Switch during reboot. Are you sure you want to reboot the selected Switch?\n\nNote: Only Switches that are currently online will be rebooted.")
        expect(@ui.css('.dialogBox .msgbody .info').text).to eq("Note: Only Switches that are currently online will be rebooted.")
        expect(@ui.css('.dialogBox #confirmButtons #_jq_dlg_btn_0').text).to eq("Cancel")
        expect(@ui.css('.dialogBox #confirmButtons #_jq_dlg_btn_1').text).to eq("REBOOT SWITCH")
        @ui.css('.dialogBox #confirmButtons #_jq_dlg_btn_1').click
        @ui.css('.dialogOverlay .success').wait_until(&:present?)
        expect(@ui.css('.dialogOverlay .success .msgbody div').text).to eq("Switch reboot triggered\nChanges will take effect momentarily")
      end   
     end
  end #describe
end #shared_examples

def Verify_switch_port_details_panel(port, switch_hostname)
    sleep 0.5
    if port.nil?
      expect(@ui.css(".grid-sidepanel-details-title").text).to eq("Add/Edit Switch Port Template")
    else
      expect(@ui.css(".grid-sidepanel-details-title").text).to eq("Edit Configuration for Port #{port} on #{switch_hostname}")
    end    
    port_fields=@browser.elements(:css, ".switch-port-template-tab .xc-field")  
    expect(port_fields[1].element(:css, "label").text).to eq("Name:")  
    expect(port_fields[3].element(:css, "label").text).to eq("Start From")
    expect(port_fields[3].element(:css, "span").attribute_value("class")).to include("ko_dropdownlist")
    expect(port_fields[3].element(:css, ".ko_dropdownlist_button").text).to eq("Select Template")
    expect(port_fields[4].element(:css, "label").text).to eq("Description:") 
    expect(port_fields[5].element(:css, "label").text).to eq("Icon:")    
    expect(port_fields[6].element(:css, "label").text).to eq("Enable Port:")
    expect(port_fields[6].element(:css, "span").attribute_value("class")).to include("switch")
    expect(port_fields[6].checkbox(:css, "#switch-port-template-enabled_switch").set?).to eq(true)
    if @browser.checkbox(:css, "#switch-port-template-enabled_switch").set?
      expect(port_fields[7].element(:css, "label").text).to eq("Port Speed:")
      expect(port_fields[7].element(:css, "span").attribute_value("class")).to include("ko_dropdownlist")
      expect(port_fields[7].element(:css, ".ko_dropdownlist_button").text).to eq("Auto")
      if port_fields[7].element(:css, ".ko_dropdownlist_button").text != "Auto"
        expect(port_fields[8].element(:css, "label").text).to eq("Duplex Mode:")
        expect(port_fields[8].element(:css, "span").attribute_value("class")).to include("ko_dropdownlist")
        expect(port_fields[8].element(:css, ".ko_dropdownlist_button").text).to eq("Full duplex")
      end
      expect(port_fields[9].element(:css, "label").text).to eq("Port Type:")
      expect(port_fields[9].element(:css, "span").attribute_value("class")).to include("ko_dropdownlist")
      expect(port_fields[9].element(:css, ".ko_dropdownlist_button").text).to eq("Access")
      expect(port_fields[10].element(:css, "label").text).to eq("VLAN:")
      expect(port_fields[10].element(:css, "input").attribute_value("type")).to include("text")
      expect(port_fields[10].text_field(:id, "switch-port-template-nativeVlan").value).to eq("1")
      if port_fields[9].element(:css, ".ko_dropdownlist_button").text != "Access"
         expect(port_fields[11].element(:css, "label").text).to eq("VLANs")
         expect(port_fields[11].element(:css, "xc-vlans-editor div").attribute_value("class")).to include("vlans-editor")
         expect(port_fields[11].element(:css, "#vlan-editor-input").value).to eq("")
      end     
      expect(port_fields[12].element(:css, "label").text).to eq("PoE")
      expect(port_fields[12].element(:css, "span").attribute_value("class")).to include("switch")
      expect(port_fields[12].checkbox(:css, "#switch-port-template-poe_switch").set?).to eq(true)
      expect(port_fields[13].element(:css, "label").text).to eq("PoE Priority:")
      expect(port_fields[13].element(:css, "span").attribute_value("class")).to include("ko_dropdownlist")
      expect(port_fields[13].element(:css, ".ko_dropdownlist_button").text).to eq("Low")
      expect(port_fields[14].element(:css, "label").text).to eq("STP BPDU Guard:")
      expect(port_fields[14].element(:css, "span").attribute_value("class")).to include("switch")
      expect(port_fields[14].checkbox(:css, "#switch-port-template-stpBpduGuardEnabled_switch").set?).to eq(false)
      expect(port_fields[15].element(:css, "label").text).to eq("Access Security:")    
      expect(port_fields[15].element(:css, "span").attribute_value("class")).to include("switch")
      expect(port_fields[15].checkbox(:css, "#switch-port-template-dot1xSecurity_switch").set?).to eq(false)
      if port_fields[15].checkbox(:css, "#switch-port-template-dot1xSecurity_switch").set?
         expect(port_fields[16].element(:css, "label").text).to eq("Port Auth Mode:")
         expect(port_fields[16].element(:css, "span").attribute_value("class")).to include("ko_dropdownlist")
         expect(port_fields[16].element(:css, ".ko_dropdownlist_button").text).to eq("802.1x MAC Based")      
      end
    end  
    @ui.css(".slideout-collapse-toggle-btn").click
    sleep 0.5    
end

shared_examples "verify switch template using port template config" do |sw_template_name, sw_model, sw_port_template_1, sw_port_template_2, sw_port_template_3, sw_port_template_4|
 describe "verify switch template using port templates #{sw_port_template_1[:name]} and #{sw_port_template_2[:name]} and #{sw_port_template_3[:name]} and #{sw_port_template_3[:name]}" do
    it "Navigate to switch template panel" do
      goto_switch_template
    end
    it "verify switch template with ports template-#{sw_port_template_1[:name]} and template-#{sw_port_template_2[:name]} and template-#{sw_port_template_3[:name]} and template-#{sw_port_template_4[:name]}" do
        portnum=nil
        port_templates_files=[sw_port_template_1, sw_port_template_2, sw_port_template_3, sw_port_template_4]
        switch_templates = @browser.elements(:css, '#switch_templates ul li')
        switch_by_name=nil
        switch_templates.each do |switch_template|
          if switch_template.element(:css, '.switchtemplate_name_heading_Value').text==sw_template_name
             switch_by_name=switch_template
             model=switch_template.element(:css, '.switchtemplate_model_heading_Value').text
          end
        end
        switch_by_name.elements(:css, '.switch-unit table').length.times do |i|
          css_path = ".switch-unit table:nth-child(#{i+1}) tbody  tr td"
          ports = switch_by_name.elements(:css, css_path)
          ports.each do |port|
            port.element(:css, ".mac_chk_label").click
            sleep 0.5
            portnum=@ui.css('.grid-sidepanel-details-title').text.gsub('Add/Edit Switch Template - Port', '').strip
            verify_switch_port_configuration(port_templates_files[i], sw_model, portnum)
            port.element(:css, ".mac_chk_label").click
            sleep 0.5
          end           
        end       
      end
  end
end

shared_examples "verify profile switch tab configuration using port config" do |profile_name, sw_model, sw_port_template_1, sw_port_template_2, sw_port_template_3, sw_port_template_4|
 describe "verify profile switch tab configuration using port templates #{sw_port_template_1[:name]} and #{sw_port_template_2[:name]} and #{sw_port_template_3[:name]} and #{sw_port_template_4[:name]}" do
   it "Go to the profile named '#{profile_name}'" do
       @ui.go_to_profile_tile(true)
       @ui.goto_profile profile_name
   end
   it "Ensure you are on the 'Switch' tab" do
       @ui.css('#profile_config_tab_switch').click
       sleep 1
    end
    it "verify ports configuration by port template-#{sw_port_template_1[:name]} and template-#{sw_port_template_2[:name]} and template-#{sw_port_template_3[:name]}" do
        port_templates_files=[sw_port_template_1, sw_port_template_2, sw_port_template_3, sw_port_template_4]
        portnum=nil
        switch_templates = @browser.elements(:css, '#profile_switch_templates ul li')
        switch_by_model=nil
        switch_templates.each do |switch_template|
          if switch_template.element(:css, '.switchtemplate_model_heading_Value').text==sw_model
             switch_by_model=switch_template
          end
        end         
        switch_by_model.elements(:css, '.switch-unit table').length.times do |i|
          css_path = ".switch-unit table:nth-child(#{i+1}) tbody  tr td"
          ports = switch_by_model.elements(:css, css_path)
          ports.each do |port|
            port.element(:css, ".mac_chk_label").click
            sleep 0.5
            portnum=@ui.css('.grid-sidepanel-details-title').text.gsub('Add/Edit Switch Template - Port','').strip
            verify_switch_port_configuration(port_templates_files[i], sw_model, portnum)
            port.element(:css, ".mac_chk_label").click
            sleep 0.5
          end 
        end  
      end
  end
end

shared_examples "configure switch template using port template" do |sw_template_name, sw_port_template_1, sw_port_template_2, sw_port_template_3, sw_port_template_4|
 describe "configure switch template using port templates #{sw_port_template_1} and #{sw_port_template_2} and #{sw_port_template_3} and #{sw_port_template_4}" do
    it "Navigate to switch template panel" do
      goto_switch_template
    end
    it "configure ports with template- #{sw_port_template_1} and template- #{sw_port_template_2} and template- #(sw_port_template_3) and template- #(sw_port_template_4)" do
        port_templates_files=[sw_port_template_1, sw_port_template_2, sw_port_template_3, sw_port_template_4]
        switch_templates = @browser.elements(:css, '#switch_templates ul li')
        switch_by_name=nil
        switch_templates.each do |switch_template|
          if switch_template.element(:css, '.switchtemplate_name_heading_Value').text==sw_template_name
             switch_by_name=switch_template
          end
        end  
        switch_by_name.elements(:css, '.switch-unit table').length.times do|i|  
          css_path = ".switch-unit table:nth-child(#{i+1}) tbody  tr td"
          ports = switch_by_name.elements(:css, css_path)
          ports.each do |port|
            port.element(:css, ".mac_chk_label").click
            sleep 0.5
          end
          @ui.set_dropdown_entry_by_path(".switch-port-template-tab div.xc-field:nth-child(4) .ko_dropdownlist", port_templates_files[i])
          @browser.button(:text => 'Save').click
          sleep 2 
        end
      end
  end
end

shared_examples "perform changes on switch tab of a profile by loading switch template" do |profile_name, sw_template_name, sw_model|
  describe "Perform changes to switch tabs of the profile named '#{profile_name}' by loading switch template" do
   it "Go to the profile named '#{profile_name}'" do
       @ui.goto_profile profile_name
   end
   it "Ensure you are on the 'Switch' tab" do
       @ui.css('#profile_config_tab_switch').click
       sleep 1
    end
   it "configure switch tab in profile by load switch template" do
     # find which template to load
      sw_models = @browser.elements(:css, "#profile_switch_templates ul li")
      sw_models.each do |model|
        puts model.element(:css, '.switchtemplate_model_heading_Value').text
        if model.element(:css, '.switchtemplate_model_heading_Value').text == sw_model
          model.element(:css, '#edit_profile_switch_btn').click
          break
        end
      end
      sleep 3
      @ui.set_dropdown_entry_by_path("div.xc-field .ko_dropdownlist", sw_template_name)
      sleep 1
      @ui.css('#newprofile_create').click
      sleep 2
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)    
    end
  end
end

 shared_examples "delete all switch port templates" do
  describe "General Switch Port Template configuration tab" do
    it "Navigate to switch port template panel" do
      goto_switch_port_template
    end
    it "Delete all switch port template" do
        delete_all_switch_port_templates
    end
  end
end

 shared_examples "delete all switch templates" do
  describe "General Switch Template configuration tab" do
    it "Navigate to switch template panel" do
      goto_switch_template
    end
    it "Delete all switch template" do
      delete_all_switch_templates
    end
  end
end

shared_examples "create switch port template"do |switch_port_template_name, switch_port_template_description|
  describe "Create switch port template with name #{switch_port_template_name}" do
      it "Navigate to switch port template panel" do
      goto_switch_port_template
    end
    it "Add switch port template with #{switch_port_template_name} and #{switch_port_template_description}" do
      add_switch_port_template(switch_port_template_name, switch_port_template_description)
    end  
  end
end

shared_examples "create switch template"do |switch_template_name, switch_template_description, switch_model|
  describe "Create switch template with name #{switch_template_name}" do
      it "Navigate to switch template panel" do
      goto_switch_template
    end
    it "Add switch template with #{switch_template_name}, model: #{switch_model} and #{switch_template_description}" do
      add_switch_template(switch_template_name, switch_template_description, switch_model)
    end  
  end
end

shared_examples "configure switch port template" do |port_config|
  describe "configure switch port with params passed" do
    it "Navigate to Switch port template and open template" do
      goto_switch_port_template_setting(port_config[:name])
    end
    it "Configure switch port template" do
      configure_switch_port_paramters(port_config)
    end    
  end  
end

shared_examples "verify switch port template configuration" do |port_config|
  describe "verify switch port template-#{port_config[:name]} with params passed" do
    it "Navigate to Switch port template and open template" do
      sleep 1
      goto_switch_port_template_setting(port_config[:name])
    end
    it "verify switch port template" do
      verify_switch_port_configuration(port_config, "none", "none")
    end    
  end  
end

shared_examples "Export Switches from Switch tab" do |columns, sw_serialNumbers|
  describe "Export Switches from Switch tab" do    
    it "navigate to mynetwork switch tab" do
      @ui.css('#header_mynetwork_link').click
      sleep 1
      @ui.css('#mynetwork_tab_switches').click
      sleep 2
    end   
    it "Press the 'Export All' button" do
      @ui.css('#mn-cl-export-btn').wait_until(&:present?)
      @ui.css('#mn-cl-export-btn').click
      sleep 1
    end   
    it "Verify that the exported file exists and it contains the needed details" do
      fname = @download + "/NetworkSwitches-All-" + (Date.today.to_s) + ".csv"
      file = File.open(fname, "r")
      data = file.read
      file.close
      sleep 1
      columns.each do |column|
         expect(data.include?(column)).to eq(true)
      end
      sw_serialNumbers.each do |sw_sn|
        expect(data.include?(sw_sn)).to eq(true)
      end
      sleep 1
      File.delete(@download + "/NetworkSwitches-All-" + (Date.today.to_s) + ".csv")
    end
  end
end

shared_examples "verify switch port stats panel status" do |name, section, status, switch_sn|
  describe "Verify switch port stats panel #{status} for section #[section]" do
    css=nil
    it "navigate to section #{section} and open port" do
    case section
      when "profile_switch_config"
         @ui.go_to_profile_tile(true)
         @ui.goto_profile name
         sleep 1
         @ui.css('#profile_config_tab_switch').click
         sleep 1
         @ui.css("#profile_switch_templates ul li:nth-child(1) .switch-unit table:nth-child(1) tr:nth-child(1) td .mac_chk_label").click
         
      when "switch_template"
        goto_switch_template
        @ui.css("#switch_templates ul li:nth-child(1) .switch-unit table:nth-child(1) tr:nth-child(1) td .mac_chk_label").click
        
      when "port_template"
        goto_switch_port_template
        goto_switch_port_template_setting(name)
        
      when "profile_switch_tab"
        @ui.go_to_profile_tile(true)
        @ui.goto_profile name
        sleep 2
        @ui.click('#profile_tab_switches')
        sleep 1.5
        @ui.grid_action_on_specific_line("4", "a", switch_sn, "click_model")
        sleep 1
        @ui.css("xc-switch-details .switch-unit table:nth-child(1) tr:nth-child(1) td .mac_chk_label").click
      else
        go_to_my_network_switches_tab
        @ui.grid_action_on_specific_line("4", "a", switch_sn, "click_model")
        @ui.css("xc-switch-details .switch-unit table:nth-child(1) tr:nth-child(1) td .mac_chk_label").click
      end          
    end 
    it "Verify port stats tab" do
      if status==false
        expect(!@ui.css('#switch-port-template-slideout-tab-port-troubleshooting').present?).to eq(true)
      else
        expect(@ui.css('#switch-port-template-slideout-tab-port-troubleshooting').present?).to eq(true)
        @ui.css('#switch-port-template-slideout-tab-port-troubleshooting').click
        sleep 0.5
        expect(@ui.css('svg g:nth-child(6) text:nth-child(2)').text).to eq("Download")
        expect(@ui.css('svg g:nth-child(6) text:nth-child(3)').text).to eq("Upload")
        expect(@ui.css('svg g:nth-child(6) text:nth-child(4)').text).to eq("Total")
        expect(@ui.css('.details-footer #array-details-troubleshooting-chart').text).to eq("Data Throughput")
        expect(@ui.css('.details-footer #array-details-troubleshooting-timeframe').text).to eq("Last 24 Hours")   
        @ui.css("xc-switch-details .switch-unit table:nth-child(1) tr:nth-child(2) td .mac_chk_label").click 
        sleep 0.5
        expect(@ui.css('.nochart').text).to eq("Statistics are available for individual ports only.")    
      end
    end 
  end
end
shared_examples "device filter online-offline-all" do |device_type|
  describe "device filter online-offline-all" do
    it "navigate to mynetowkr #{device_type} tab" do
      if device_type =="switch"
        go_to_my_network_switches_tab
      else
        go_to_my_network_arrays_tab
      end     
    end
    it "verify options in drop-down list" do
      #get all drop-down option
      @ui.css("#arrays_state .ko_dropdownlist_button").click
      #verify that online-offline and all devices option availbale
      expect(@browser.elements(:css, ".ko_dropdownlist_list.active ul li").length).to eq(3)
      expect(@ui.css(".ko_dropdownlist_list.active ul li:nth-child(1)").text).to eq("All Devices")
      expect(@ui.css(".ko_dropdownlist_list.active ul li:nth-child(2)").text).to eq("Online")
      expect(@ui.css(".ko_dropdownlist_list.active ul li:nth-child(3)").text).to eq("Offline")
      @ui.css("#ko_dropdownlist_overlay").click
    end
  end
end
def delete_all_switch_port_templates
    template_list = @browser.elements(:css, "#switch_port_templates ul li")
    template_list.each do |template|
      @ui.show_needed_control("#switch_port_templates .tile:nth-child(1) .overlay")
      sleep 1
      @ui.click('.overlay .deleteIcon')
      sleep 1
      @ui.click('#_jq_dlg_btn_1')
      sleep 1.5
      if @ui.css('.error').exists?
         @browser.refresh
         sleep 1
         @ui.css("#switch_port_templates").wait_until(&:present?)
      end
   end
end

def delete_all_switch_templates 
    template_list = @browser.elements(:css, "#switch_templates ul li")
    template_list.each do |template|
      css_path= "#switch_templates ul li:nth-child(1) a:nth-child(1) div:nth-child(1) span:nth-child(7)"
      script = "$(\"#{css_path}\").click()"      
      @browser.execute_script(script)
      sleep 1
      @ui.click('#_jq_dlg_btn_1')
      sleep 1.5
      if @ui.css('.error').exists?
         @browser.refresh
         sleep 2
         @ui.css("#switch_templates").wait_until(&:present?)
      end
   end
end

def goto_switch_port_template_setting(port_template_name)
  if !@ui.css('#new_switch_port_templates_btn').exists?
      sleep 0.5
      @ui.css("#header_nav_profiles").click
      sleep 0.5
      @browser.element(:link, "Templates").click
      sleep 1      
  end
  @browser.element(:link, "Port Templates").click
  sleep 1
    template_list = @browser.elements(:css, "#switch_port_templates ul li")
    template_list.each do |template|
       if template.element(:css, "a span").text  == port_template_name
          template.element(:css, "a span").click
          break
       end
     end
    @ui.css("xc-slideout-content").wait_until(&:present?)
    sleep 0.5
end

def goto_switch_port_template
  if !@ui.css('#new_switch_port_templates_btn').exists?
      sleep 0.5
      @ui.css("#header_nav_profiles").click
      sleep 0.5
      @browser.element(:link, "Templates").click
      sleep 1      
  end
  @browser.element(:link, "Port Templates").click
  sleep 0.5
end

def goto_switch_template
    if !@ui.css('#new_switch_templates_btn').exists?
      sleep 0.5
      @ui.css("#header_nav_profiles").click
      sleep 0.5
      @browser.element(:link, "Templates").click
      sleep 1      
  end
  @browser.element(:link, "Switch Templates").click
  sleep 0.5
end

def add_switch_port_template(switch_port_template_name, switch_port_description)
      @ui.css("#new_switch_port_templates_btn").click
      @ui.css("xc-slideout-content").wait_until(&:present?)
      @ui.set_input_val("#switch-port-template-name",switch_port_template_name)
      @ui.set_input_val("#switch-port-template-description", switch_port_description)
      @ui.css("#switch-port-template-save").click
      @ui.css(".msgbody").wait_until(&:present?)
      expect(@ui.css(".msgbody").text).to eq("Network switch port template saved successfully.")
      @ui.css(".msgbody").wait_while_present
end

def add_switch_template(switch_template_name, switch_template_description, switch_model)
      sleep 0.5
      @ui.css("#new_switch_templates_btn").click
      sleep 1
      @ui.css("#profiles_newprofile").wait_until(&:present?)
      @ui.set_input_val("#new-template-name",switch_template_name)
      sleep 0.5
      @ui.set_dropdown_entry('new-template-model', switch_model)
      sleep 0.5
      @ui.set_input_val("#new-template-description", switch_template_description)
      @ui.css("#newtemplate_create").click
      sleep 1
end

def configure_switch_port_paramters(port_config) 
    @ui.set_input_val("#switch-port-template-name", port_config[:name])
    @ui.set_input_val("#switch-port-template-description", port_config[:description])
    sleep 0.5
    @ui.css(".switch-port-select-icon").click
    sleep 0.2
    @ui.css(".switch-port-icon."+port_config[:icon]).click
    sleep 0.2  
    if port_config[:portenable]=="enabled"
      if !@ui.get(:checkbox, {id: "switch-port-template-enabled_switch"}).set?
        @ui.css('#switch-port-template-enabled').click
        sleep 1
      end
      @ui.set_dropdown_entry_by_path(".switch-port-template-tab div.xc-field:nth-child(8) span:nth-child(2)", port_config[:speed])
      if port_config[:speed] != "Auto"
        @ui.set_dropdown_entry_by_path(".switch-port-template-tab div.xc-field:nth-child(9) span:nth-child(2)", "Full duplex")
      end
        @ui.set_dropdown_entry_by_path(".switch-port-template-tab div.xc-field:nth-child(10) span:nth-child(2)", port_config[:type])
        @ui.set_input_val("#switch-port-template-nativeVlan", port_config[:native_vlan])
        sleep 0.2
        @ui.css('#switch-port-template-slideout-tab-port-settings').click
      if port_config[:type] == "Access"
          if port_config[:access_security]=="enabled"
            if !@ui.get(:checkbox, {id: "switch-port-template-dot1xSecurity_switch"}).set?
              @ui.css('#switch-port-template-dot1xSecurity').click
              sleep 1            
            end
          @ui.set_dropdown_entry_by_path(".switch-port-template-tab div.xc-field:nth-child(17) span:nth-child(2)", port_config[:auth_mode])
          else
            if @ui.get(:checkbox, {id: "switch-port-template-dot1xSecurity_switch"}).set?
              @ui.css('#switch-port-template-dot1xSecurity').click
              sleep 1
            end 
         end
      else
        @ui.set_input_val("#vlan-editor-input", port_config[:member_vlans]) 
        @ui.css("#switch-port-template-slideout-tab-port-settings").click     
      end
      if port_config[:poe]=="enabled"
        if !@ui.get(:checkbox, {id: "switch-port-template-poe_switch"}).set?
          @ui.css('#switch-port-template-poe').click
          sleep 1
        end
          @ui.set_dropdown_entry_by_path(".switch-port-template-tab div.xc-field:nth-child(14) span:nth-child(2)", port_config[:poe_priority])
       else
         if @ui.get(:checkbox, {id: "switch-port-template-poe_switch"}).set?
           @ui.css('#switch-port-template-poe').click
           sleep 1
          end
        end
        if port_config[:stp_guard]=="enabled"
          if !@ui.get(:checkbox, {id: "switch-port-template-stpBpduGuardEnabled_switch"}).set?
            @ui.css('#switch-port-template-stpBpduGuardEnabled').click
            sleep 1
          end
        else
          if @ui.get(:checkbox, {id: "switch-port-template-stpBpduGuardEnabled_switch"}).set?
            @ui.css('#switch-port-template-stpBpduGuardEnabled').click
            sleep 1
            end 
         end         
     else
      if @ui.get(:checkbox, {id: "switch-port-template-enabled_switch"}).set?
        @ui.css('#switch-port-template-enabled').click
        sleep 1
      end 
    end  
  @ui.css("#switch-port-template-save").click
  @ui.css(".msgbody").wait_until(&:present?)
  expect(@ui.css(".msgbody").text).to eq("Network switch port template saved successfully.")
  @ui.css(".msgbody").wait_while_present
end

def verify_switch_port_configuration(port_config, model, port) 
  sleep 1 
  if @browser.url.include?('#switchtemplates/switchporttemplates') == true
    expect(@ui.get(:text_field, {id: "switch-port-template-name"}).value).to eq(port_config[:name])
  end  
  expect(@ui.get(:text_field, {id: "switch-port-template-description"}).value).to eq(port_config[:description])  
  expect(@ui.css("div.xc-field .switch-port-icon").attribute_value("class")).to include(port_config[:icon])
  if @ui.get(:checkbox, {id: "switch-port-template-enabled_switch"}).set?
    act_porteanble= "enabled"
    expect(act_porteanble).to eq(port_config[:portenable])
    expect(@ui.css('.switch-port-template-tab div.xc-field:nth-child(8) span:nth-child(2) a:nth-child(1) span:nth-child(1)').text).to eq(port_config[:speed])
    if @ui.css('.switch-port-template-tab div.xc-field:nth-child(8) span:nth-child(2) a:nth-child(1) span:nth-child(1)').text != "Auto"
      expect(@ui.css('.switch-port-template-tab div.xc-field:nth-child(9) span:nth-child(2) a:nth-child(1) span:nth-child(1)').text).to eq("Full duplex")
    end
    if @ui.css('.switch-port-template-tab div.xc-field:nth-child(10) span:nth-child(2) a:nth-child(1) span:nth-child(1)').text == "Access"
       expect(@ui.css('.switch-port-template-tab div.xc-field:nth-child(10) span:nth-child(2) a:nth-child(1) span:nth-child(1)').text).to eq(port_config[:type])
       expect(@ui.get(:text_field, {id: "switch-port-template-nativeVlan"}).value).to eq(port_config[:native_vlan])
      if @ui.get(:checkbox, {id: "switch-port-template-dot1xSecurity_switch"}).set?
        act_security= "enabled"
        expect(act_security).to eq(port_config[:access_security])
        expect(@ui.css('.switch-port-template-tab div.xc-field:nth-child(17) span:nth-child(2) a:nth-child(1) span:nth-child(1)').text).to eq(port_config[:auth_mode])
      else 
        act_security= "disabled"
        expect(act_security).to eq(port_config[:access_security])
      end 
    else
        expect(@ui.get(:text_field, {id: "vlan-editor-input"}).value).to eq(port_config[:member_vlans])
    end  
    
    if !((port.match /13|14/) && model == "XS-6012P")
      if !((port.match /25|26|27|28/) && model == "XS-6024MP")
        if !((port.match /49|50|51|52/) && model == "XS-6048MP")
          if @ui.get(:checkbox, {id: "switch-port-template-poe_switch"}).set?
            act_poe= "enabled"
            expect(act_poe).to eq(port_config[:poe])
            expect(@ui.css('.switch-port-template-tab div.xc-field:nth-child(14) span:nth-child(2) a:nth-child(1) span:nth-child(1)').text).to eq(port_config[:poe_priority])
          else 
            act_poe= "disabled"
            expect(act_poe).to eq(port_config[:poe])
          end
         end
       end
    end
    
    
    if @ui.get(:checkbox, {id: "switch-port-template-stpBpduGuardEnabled_switch"}).set?
      act_stp_gurad = "enabled"
    else
      act_stp_gurad = "disabled"
    end
    expect(act_stp_gurad).to eq(port_config[:stp_guard])       
  else
    act_porteanble="disabled"   
    expect(act_porteanble).to eq(port_config[:portenable]) 
  end 
  @ui.css(".slideout-collapse-toggle-btn").click
  sleep 0.5 
end
