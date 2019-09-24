require_relative "../../TS_Search_Box/local_lib/search_box_lib.rb"

def verify_block_client_modal_and_perform_action(action, what_to_do)
	blocked_modal = @ui.css('.confirm .confirm')
	expect(blocked_modal).to be_present
	if action == "Blocked"
		expect(blocked_modal.div(css: ".title").span.text).to eq("Block client")
		expect(blocked_modal.div(css: ".msgbody").element(css: "div:first-child").text).to eq("Are you sure you want to block the selected client?")
		expect(blocked_modal.div(id: "confirmButtons").element(id: "_jq_dlg_btn_1").text).to eq("BLOCK")
	elsif action == "Allowed"
		expect(blocked_modal.div(css: ".title").span.text).to eq("Unblock client")
		expect(blocked_modal.div(css: ".msgbody").element(css: "div:first-child").text).to eq("Are you sure you want to unblock the selected client?")
		expect(blocked_modal.div(id: "confirmButtons").element(id: "_jq_dlg_btn_1").text).to eq("UNBLOCK")
	end
	expect(blocked_modal.div(id: "confirmButtons").element(id: "_jq_dlg_btn_0").text).to eq("Cancel")
	if what_to_do == "BLOCK/UNBLOCK"
		@ui.click("#_jq_dlg_btn_1")
	elsif what_to_do == "Cancel"
		@ui.click("#_jq_dlg_btn_0")
	end
	sleep 2
	expect(blocked_modal).not_to be_present
end

################################# GENERAL FEATURES #################################

shared_examples "go to mynetwork clients tab" do
	describe "Go to the Clients tab of My network" do
		it "Ensure you are on the 'My Network' area" do
			if @browser.url.include?("/#mynetwork/overview")
				puts "SKIPPED due to the fact that the application is already on the 'My Network' area"
			else
				@ui.click("#header_nav_mynetwork")
				sleep 1
			end
		end
		it "Go to the 'Clients' tab" do
			@ui.click('#mynetwork_tab_clients')
			sleep 2
			expect(@browser.url).to include("/#mynetwork/clients")
		end
	end
end

shared_examples "on clients tab view all clients all time" do
	#describe "On the Clients tab of My network set the view to All Clients / All Time" do
		it "Set the 'Show' type of clients dropdown list to 'All Clients'" do
			@ui.set_dropdown_entry('clients_state', 'All Clients')
			sleep 0.5
			expect(@ui.css('#clients_state a .text').text).to eq('All Clients')
		end
		it "Set the 'Time Span' type dropdown list to 'All time'" do
			@ui.set_dropdown_entry('clients_span', 'All time')
			sleep 0.5
			expect(@ui.css('#clients_span a .text').text).to eq('All time')
		end
		it "Set the view to '1000' entries per page" do
      @ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "1000")
    end
	#end
end
shared_examples "delete button available only for offline clients" do
  describe "delete button available only for offline clients" do
    it "Set the 'Show' type of clients dropdown list to 'Offline'" do
      @ui.set_dropdown_entry('clients_state', 'Offline')
      sleep 0.5
      expect(@ui.css('#clients_state a .text').text).to eq('Offline')
    end
    it "Set the 'Time Span' type dropdown list to 'All time'" do
      @ui.set_dropdown_entry('clients_span', 'All time')
      sleep 0.5
      expect(@ui.css('#clients_span a .text').text).to eq('All time')
    end
    it "verify that delete button is present when select offline clients" do
      @ui.css(".nssg-table .nssg-thead:nth-child(2) tr:first-child .nssg-th-select").click
      expect(@ui.css("#clients-delete-btn").present?).to eq(true)
      @ui.css("#clients-delete-btn").click
      @ui.css(".dialogOverlay").wait_until(&:present?)
      expect(@ui.css(".dialogBox  .title").text).to include("Delete client")
      expect(@ui.css(".dialogBox .msgbody").text).to include("Are you sure you want to delete")
      expect(@ui.css(".dialogBox .msgbody").text).to include("This is a permanent action and cannot be undone.")
      expect(@ui.css("#confirmButtons #_jq_dlg_btn_0").text).to eq("Cancel")
      expect(@ui.css("#confirmButtons #_jq_dlg_btn_1").text).to eq("YES, DELETE CLIENTS")
      @ui.css("#confirmButtons #_jq_dlg_btn_0").click
    end
    it "Set the 'Show' type of clients dropdown list to 'Online'" do
      @ui.set_dropdown_entry('clients_state', 'Online')
      sleep 0.5
      expect(@ui.css('#clients_state a .text').text).to eq('Online')
    end
    it "verify that delete button is NOT present when select Online clients" do
      @ui.css(".nssg-table .nssg-thead:nth-child(2) tr:first-child .nssg-th-select").click
      expect(@ui.css("#clients-delete-btn").present?).to eq(false)
    end
  end
end
################################# GENERAL FEATURES #################################

shared_examples "find a certain client hostname and verify the icon and text on device class cell" do |client_hostname, device_class_text, device_class_icon, navigate|
	describe "Find the client with the hostname set to '#{client_hostname}' and verify that it has the device class '#{device_class_text}' and the icon '#{device_class_icon}'" do
		if navigate == true
			context "General method - Go to Clients Tab (My Network)" do
				it_behaves_like "go to mynetwork clients tab"
			end
			context "Set the view mode to 'All Clients' and time span to 'All Time'" do
				it_behaves_like "on clients tab view all clients all time"
			end
		end
		context "Search for the client named '#{client_hostname}' and verify the device class text and icon" do
			it "Search for the client with the Hostname of '#{client_hostname}'" do
				@ui.set_input_val('.xc-search input', client_hostname)
				sleep 1
				expect(@ui.css('.nssg-table tbody').trs.length).to eq(1)
				@ui.find_grid_header_by_name_new("Client Hostname")
				expect(@ui.css(".nssg-table tbody tr:first-child td:nth-child(#{$header_count}) a").attribute_value("text")).to eq(client_hostname)
			end
			it "Search for the 'Device Class' column and verify that the text displayed is '#{device_class_text}' and that the icon displayed is '#{device_class_icon}'" do
				@ui.find_grid_header_by_name_new("Device Class")
				expect(@ui.css(".nssg-table tbody tr:first-child td:nth-child(#{$header_count}) div span:nth-child(2)").attribute_value("title")).to eq(device_class_text)
				expect(@ui.css(".nssg-table tbody tr:first-child td:nth-child(#{$header_count}) div .xc-icon#{device_class_icon}")).to exist
				if @ui.css('.xc-search .btn-clear').attribute_value("style") == ""
					@ui.click(".xc-search .btn-clear")
					sleep 2
				end
			end
		end
	end
end

shared_examples "export all clients and verify the results contain a certain client" do
	describe "Export all the clients from the Clients tab of My network and verify that the results contain all the clients that are available in the grid" do
		context "General method - Go to Clients Tab (My Network)" do
			it_behaves_like "go to mynetwork clients tab"
		end
		context "Set the view mode to 'All Clients' and time span to 'All Time'" do
			it_behaves_like "on clients tab view all clients all time"
		end
		context "Export all entries and verify that all the clients exist" do
			it "Set the view to '1000' entries per page" do
				@ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "1000")
			end
			it "Get all the client entries (Client Hostname value) that are available" do
				grid_length = @ui.css(".nssg-table tbody").trs.length
				$array_of_client_hostnames = Array[]
				while grid_length != 0
				  puts grid_length
					client_hostname_line_value = @ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(3) a").text
					$array_of_client_hostnames.push(client_hostname_line_value)
					grid_length = grid_length-=1
				end
			end
			it "Press the 'Export All' button" do
				@ui.click('#mn-cl-export-btn')
			end
			it "Verify that the exported list contains all the clients " do
				fname = @download + "/Clients-All-" + (Date.today.to_s) + ".csv"
		        file = File.open(fname, "r")
		        data = file.read
		        file.close

		        $array_of_client_hostnames.each do |client_hostname|
		        	expect(data.include?(client_hostname)).to eq(true)
		        end

		        @ui.click('#mynetwork_general_container .clients_tab .commonTitle')

		        File.delete(@download + "/Clients-All-" + (Date.today.to_s) + ".csv")
			end
			it "Set the view to '10' entries per page" do
				@ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "10")
			end
		end
	end
end

shared_examples "test PR 26750 - remove non valid search input using backspace" do
	describe "Test that the issue PR 26750 does not occur (removing a failed search's input using the backspace key" do
		context "General method - Go to Clients Tab (My Network)" do
			it_behaves_like "go to mynetwork clients tab"
		end
		context "Set the view mode to 'All Clients' and time span to 'All Time'" do
			it_behaves_like "on clients tab view all clients all time"
		end
		context "Perform the Test of the PR 26759" do
			it "Search for the client with the Hostname of 'ABCDEF' (leads to an empty search)" do
				@ui.set_input_val('.xc-search input', "ABCDEF")
				sleep 1
				expect(@ui.css('.nssg-table tbody').trs.length).to eq(0)
			end
			it "Drill into the 'Search' input box and using the <BACKSPACE> key delete all entries" do
				@ui.click('.xc-search input')
				sleep 0.5
				(1..6).each do
					@browser.send_keys :backspace
					sleep 0.2
				end
			end
			it "Verify that the search input box is visible" do
				expect(@ui.css('.xc-search input')).to be_visible
			end
		end
	end
end

shared_examples "test general features are present" do
	#describe "Test that the My Network, Clients tab has all the features available" do
		context "General method - Go to Clients Tab (My Network)" do
			it_behaves_like "go to mynetwork clients tab"
		end
		context "Set the view mode to 'All Clients' and time span to 'All Time'" do
			it_behaves_like "on clients tab view all clients all time"
		end
		context "Verify general features on the Clients tab" do
			it "Verify that the page has  all the features" do
				expect(@ui.css('.clients_tab .commonTitle').text).to eq('Clients on your network')
				expect(@ui.css('.clients_tab .commonSubtitle').text).to eq('Manage the clients connected to your network.')
				expect(@ui.css('#mn-cl-export-btn')).to be_visible
				expect(@ui.css('#clients_state')).to be_visible
				expect(@ui.css('#clients_span')).to be_visible
				expect(@ui.css('.columnPickerIcon')).to be_visible
				expect(@ui.css('.xc-search input')).to be_visible
				expect(@ui.css('.xc-search .btn-search')).to be_visible
				expect(@ui.css('.xc-search .btn-clear')).to exist
				expect(@ui.css('.nssg-paging .nssg-paging-pages')).to be_visible
				expect(@ui.css('.nssg-paging .nssg-paging-count')).to be_visible
				expect(@ui.css('.nssg-paging .nssg-paging-controls')).to be_visible
				expect(@ui.css('.nssg-paging .nssg-refresh')).to be_visible
				# expect(@ui.css('.nssg-table thead:nth-of-type(2)')).to be_visible
				expect(@ui.css('.nssg-table tbody')).to be_visible
				expect(@ui.css('#mynetwork-aps-filter')).to be_present
				expect(@ui.css('#mynetwork-aps-filter .text.ddlCaption').text).to eq("All Devices")
			end
		end
	#end
end

###################################### OTHERS ######################################

shared_examples "block unblock a certain client" do |client_hostname, action|
	describe "Find the client named '#{client_hostname}' and perform the action '#{action}'" do
		context "General method - Go to Clients Tab (My Network)" do
			it_behaves_like "go to mynetwork clients tab"
		end
		context "Set the view mode to 'All Clients' and time span to 'All Time'" do
			it_behaves_like "on clients tab view all clients all time"
		end
		context "Find the client and set the action #{action}" do
			it "Set the view to '1000' entries per page" do
				@ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "1000")
			end
			it "Get all the client entries (Client Hostname value) that are available and verify that the searched for client is in the grid" do
				grid_length = @ui.css(".nssg-table tbody").trs.length
				array_of_client_hostnames = Array[]
				while grid_length != 0
					client_hostname_line_value = @ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(3) a").text
					array_of_client_hostnames.push(client_hostname_line_value)
					grid_length = grid_length-=1
				end
				expect(array_of_client_hostnames).to include(client_hostname)
			end
			it "Place a tick for the needed client grid row and Block/Unblock it" do
				if @ui.grid_verify_strig_value_on_specific_line_by_column_name("Client Hostname", client_hostname, "a", "3", "a", "Allowed") != action
					@ui.grid_action_on_specific_line(3, "a", client_hostname, "tick")
					sleep 1
					if action == "Blocked"
						expect(@ui.css('#clients-block-btn')).to be_present
						@ui.click('#clients-block-btn')
						sleep 2
						verify_block_client_modal_and_perform_action(action, "BLOCK/UNBLOCK")
					elsif action == "Allowed"
						expect(@ui.css('#clients-unblock-btn')).to be_present
						@ui.click('#clients-unblock-btn')
						sleep 2
						verify_block_client_modal_and_perform_action(action, "BLOCK/UNBLOCK")
					end
				end
			end
			# it "Verify that the client is properly displayed in the grid" do
				# expect(@ui.grid_verify_strig_value_on_specific_line_by_column_name("Client Hostname", client_hostname, "a", "3", "a", action)).to eq(action)
			# end
			it "Set the view to '10' entries per page" do
				@ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "10")
			end
		end
	end
end

shared_examples "verify slideout for client" do |client_hostname|
	describe "Verify the client '#{client_hostname}' and the slideout tab's content" do
		context "General method - Go to Clients Tab (My Network)" do
			it_behaves_like "go to mynetwork clients tab"
		end
		context "Set the view mode to 'All Clients' and time span to 'All Time'" do
			it_behaves_like "on clients tab view all clients all time"
		end
		context "Open the client '#{client_hostname}' and verify the slideout tab's content" do
			it "Find the client and open the slideout tab" do
				@ui.grid_action_on_specific_line(3, "a", client_hostname, "invoke") and sleep 2
				@ui.css('client-details .ko_slideout_content xc-slideout-content').wait_until_present
			end
			it "Verify the Client health title stats of the slideout" do
        css_string_builder = ".client-health-title"
        expect(@ui.css('.client-health-title .icon-checkmark-circle-large')).to be_visible
        expect(@ui.css('.client-health-title .large').text.to_i).to be_between(0, 11)
        expect(@ui.css('.client-health-title .small').text).to eq("/10")
        expect(@ui.css('.client-health-title .koHelpIcon')).to be_visible
        @ui.css('.client-health-title .koHelpIcon').hover
        sleep 0.2
        expect(@ui.css("#ko_tooltip .ko_tooltip_content").text).to eq("The health score is 1-10. Anything below 5 shows warning sign, anthing above 5 shows check sign")
        expect(@ui.css('.client-health-title .title').text).to include("Health Score")
        expect(@ui.css('.client-health-title .title').text.gsub("Health Score","").strip).to eq(client_hostname)
      end
      it "Verify the AP stats of the slideout" do
        #First Row lables
        expect(@ui.css('.client-health-info .first-row .title').text).to eq("Now")
        expect(@ui.css('.client-health-info .first-row span:nth-child(2)').text).to eq("AP:")
        expect(@ui.css('.client-health-info .first-row span:nth-child(4)').text).to eq("RSSI:")
        expect(@ui.css('.client-health-info .first-row span:nth-child(6)').text).to eq("SNR:")
        expect(@ui.css('.client-health-info .first-row span:nth-child(8)').text).to eq("Packet Error:")
        expect(@ui.css('.client-health-info .first-row span:nth-child(10)').text).to eq("Packet Retry:")
        #Second row lables
        expect(@ui.css('.client-health-info .second-row span:nth-child(1)').text).to eq("Connect Rates:")
        expect(@ui.css('.client-health-info .second-row .icon-arrow-up6')).to be_visible
        expect(@ui.css('.client-health-info .second-row .icon-arrow-down6')).to be_visible
        expect(@ui.css('.client-health-info .second-row span:nth-child(6)').text).to eq("Capability:")
      end
      it "Verify the Client Health graph note of the slideout" do
        expect(@ui.css('.client-health-notes .solid-line')).to be_visible
        expect(@ui.css('.client-health-notes span:nth-child(2)').text).to eq("Associated")
        expect(@ui.css('.client-health-notes .dot-line')).to be_visible
        expect(@ui.css('.client-health-notes span:nth-child(4)').text).to eq("Unassociated")
      end
     it "Verify the Client Details panel button of the slideout" do
        expect(@ui.css('.client-health .client-health-detail-button').text).to eq("VIEW DETAILS")
        expect(@ui.css('#grid-sidepanel-details-next').text).to eq("Next Client")
        expect(@ui.css('#grid-sidepanel-details-prev').text).to eq("Previous Client")
        expect(@ui.css('.slideout-collapse-toggle-btn')).to be_visible        
      end
     it "Open Client View Details panel" do
        @ui.css('#client-health-detail').click
        sleep 2  
     end
     it "Verify the Client Details troubleshooting of the slideout" do
       expect(@browser.url).to include("/#mynetwork/clients/troubleshooting/")
       expect(@ui.css('.client-troubleshooting-title span').text).to eq(client_hostname)
       expect(@ui.css('.client-troubleshooting-title .client-details-device')).to be_visible
       expect(@ui.css('#client-troubleshooting-tabs')).to be_visible
       expect(@ui.css('#client-troubleshooting-tab-day').text).to eq("1 Day")
       expect(@ui.css('#client-troubleshooting-tab-week').text).to eq("1 Week")
       expect(@ui.css('#client-troubleshooting-tab-month').text).to eq("1 Month")
     end
     it "Verify Client RSSI section on Client troubleshooting slidout" do
       expect(@ui.css('#client-troubleshooting-container div:nth-child(1) .title').text).to eq("RSSI")
       @ui.css('#client-troubleshooting-container div:nth-child(1) .koHelpIcon').hover
       sleep 0.2
       expect(@ui.css("#ko_tooltip .ko_tooltip_content").text).to eq("Received Signal Strength Indicator (RSSI) represents the strength of the station’s signal as measured by access point's radio.")
       expect(@ui.css('#client-troubleshooting-container div:nth-child(1) .client-troubleshooting-notes span:nth-child(2)').text).to eq("Associated")
       expect(@ui.css('#client-troubleshooting-container div:nth-child(1) .client-troubleshooting-notes span:nth-child(4)').text).to eq("Unassociated")
     end
     it "Verify Client SNR section on Client troubleshooting slidout" do
       expect(@ui.css('#client-troubleshooting-container div:nth-child(2) .title').text).to eq("SNR")
       @ui.css('#client-troubleshooting-container div:nth-child(2) .koHelpIcon').hover
       sleep 0.2
       expect(@ui.css("#ko_tooltip .ko_tooltip_content").text).to eq("Signal-to-Noise Ratio (SNR) ratio as measured by access point's radio. A low value means that action may need to be taken to reduce sources of noise in the environment and/or improve the signal from the station.")
       expect(@ui.css('#client-troubleshooting-container div:nth-child(2) .client-troubleshooting-notes span:nth-child(2)').text).to eq("Associated")
       expect(@ui.css('#client-troubleshooting-container div:nth-child(2) .client-troubleshooting-notes span:nth-child(4)').text).to eq("Unassociated")
    end
    it "Verify Error Rates section on client troubleshooting slidout" do
       expect(@ui.css('#client-troubleshooting-container div:nth-child(3) .title').text).to eq("Error Rates")
       @ui.css('#client-troubleshooting-container div:nth-child(3) .koHelpIcon').hover
       sleep 0.2
       expect(@ui.css("#ko_tooltip .ko_tooltip_content").text).to eq("The ratio between the number of incorrectly received data packets and the total number of received packets. A high Packet Error Rate will result in performance degradation. The ratio between the number of data packets that were re-sent and the total number of received packets. A high rate of retries will result in performance degradation.")
       expect(@ui.css('#client-troubleshooting-container div:nth-child(3) .client-troubleshooting-notes span:nth-child(2)').text).to eq("Retry")
       expect(@ui.css('#client-troubleshooting-container div:nth-child(3) .client-troubleshooting-notes span:nth-child(4)').text).to eq("Error")
       expect(@ui.css('#client-troubleshooting-container div:nth-child(3) .client-troubleshooting-notes span:nth-child(6)').text).to eq("Unassociated")
     end
    it "Verify Client RSSI section on Client throubleshooting slidout" do
       expect(@ui.css('#client-troubleshooting-container div:nth-child(4) .title').text).to eq("Connect Rates")
       @ui.css('#client-troubleshooting-container div:nth-child(4) .koHelpIcon').hover
       sleep 0.2
       expect(@ui.css("#ko_tooltip .ko_tooltip_content").text).to eq("The actual connection speed of the connected station.")
       expect(@ui.css('#client-troubleshooting-container div:nth-child(4) .client-troubleshooting-notes span:nth-child(2)').text).to eq("Upload")
       expect(@ui.css('#client-troubleshooting-container div:nth-child(4) .client-troubleshooting-notes span:nth-child(4)').text).to eq("Download")
       expect(@ui.css('#client-troubleshooting-container div:nth-child(4) .client-troubleshooting-notes span:nth-child(6)').text).to eq("Unassociated")
      end
			# it "Verify the AP stats of the slideout" do
				# css_string_builder = ".client-details-general .apstats"
				# labels_hash = Hash[css_string_builder + " .apname .label" => ["Access Point", "Access Point no longer in this domain"], css_string_builder + " .apinfo div .label:nth-of-type(1)" => "IP address:", css_string_builder + " .apinfo div .label:nth-child(3)" => "Location:", css_string_builder + " .clientsconnected .label" => "# clients connected", css_string_builder + " .clientsintrouble .label" => "# clients in trouble"]
				# labels_hash.keys.each do |key|
					# if key.include?(".apname")
						# expect(labels_hash[key]).to include(@ui.css(key).text)
					# elsif key.include?(".apinfo")
						# if @ui.css(key).exists?
							# expect(@ui.css(key).text).to eq(labels_hash[key])
						# end
					# else
						# expect(@ui.css(key).text).to eq(labels_hash[key])
					# end
				# end
			# end
			# it "Verify the clients stats section of the slideout" do
				# css_string_builder = ".client-details-general .clientstats .stats-section:nth-of-type(1)"
				# labels_hash = Hash[css_string_builder + " .stats-row:nth-of-type(1) .rssi .label span" => "RSSI", css_string_builder + " .stats-row:nth-of-type(1) .packeterrorrate .label span" => "packet error rate", css_string_builder + " .stats-row:nth-of-type(1) .capability .label span" => "capability", css_string_builder + " .stats-row:nth-of-type(2) .snr .label span" => "SNR", css_string_builder + " .stats-row:nth-of-type(2) .packetretryrate .label span" => "packet retry rate", css_string_builder + " .stats-row:nth-of-type(2) .band .label span" => "band"]
				# labels_hash.keys.each do |key|
					# expect(@ui.css(key).text).to eq(labels_hash[key])
				# end
			# end
			# it "Verify the connection rate section on the slideout" do
				# css_string_builder = ".client-details-general .clientstats .connectrate"
				# labels_hash = Hash[css_string_builder + " .label span" => "connect rate", css_string_builder + " .connectrate-box .upload .label" => "upload", css_string_builder + " .connectrate-box .download .label" => "download"]
				# labels_hash.keys.each do |key|
					# expect(@ui.css(key).text).to eq(labels_hash[key])
				# end
			# end
			# css_string_builder = ".client-details-general .clientstats"
			# help_icons_hash = Hash[css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(1) .rssi .label .koHelpIcon" => "Received Signal Strength Indicator (RSSI) represents the strength of the station’s signal as measured by access point's radio.", css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(1) .packeterrorrate .label .koHelpIcon" => "The ratio between the number of incorrectly received data packets and the total number of received packets. A high Packet Error Rate will result in performance degradation.", css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(1) .capability .label .koHelpIcon" => "The maximum possible speed of the connected station.", css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(2) .snr .label .koHelpIcon" => "Signal-to-Noise Ratio (SNR) ratio as measured by access point's radio. A low value means that action may need to be taken to reduce sources of noise in the environment and/or improve the signal from the station.", css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(2) .packetretryrate .label .koHelpIcon" => "The ratio between the number of data packets that were re-sent and the total number of received packets. A high rate of retries will result in performance degradation.", css_string_builder + " .connectrate .label .koHelpIcon" => "The actual connection speed of the connected station."] # css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(2) .band .label .koHelpIcon" => "",
			# help_icons_hash.keys.each { |key|
				# it "Verify the 'Help' icon and the description text for the option #{key}" do
					# @ui.css(key).hover and sleep 1
					# expect(@ui.css("#ko_tooltip .ko_tooltip_content").text).to eq(help_icons_hash[key])
				# end
			# }
			# css_string_builder = ".client-details-general .clientstats"
			# controls_hash = Hash[css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(1) .rssi .value-unit .value" => ["-100", "0", "N/A", "value"], css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(1) .rssi .value-unit .unit" => "dBm", css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(1) .packeterrorrate .value" => ["-", "101%", "N/A", "value"], css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(2) .snr .value-unit .value" => ["-1", "101", "N/A", "value"], css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(2) .snr .value-unit .unit" => "dBm", css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(2) .packetretryrate .value" => ["-", ".00%", "1.01%", "N/A", "value"], css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(2) .band .value-unit .value" => ["2.4", "5"], css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(2) .band .value-unit .unit" => "GHz", css_string_builder + " .connectrate .connectrate-box .download .value-unit .value" => ["-", "9999", "N/A", "value"], css_string_builder + " .connectrate .connectrate-box .upload .value-unit .value" => ["-", "9999", "N/A", "value"]] # css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(1) .connectrate .download .value" => ["-", "9999", "N/A", "value"], css_string_builder + " .stats-section:nth-of-type(1) .stats-row:nth-of-type(1) .connectrate .upload .value" => ["-", "9999", "N/A", "value"],
			# controls_hash.keys.each { |key|
				# it "Verify the validity of the data in the slideout (#{key})" do
					# @ui.css(key).hover and sleep 1
					# if controls_hash[key].class == Array
						# if key.include? ".band"
							# expect(controls_hash[key]).to include(@ui.css(key).text)
						# else
							# expect(controls_hash[key]).not_to include(@ui.css(key).text)
						# end
					# else
						# expect(@ui.css(key).text).to eq(controls_hash[key])
					# end
				# end
			# }
			it "Close the Client details slideout" do
				# @ui.click('.ko_slideout_content .slideout-toggle') and sleep 2
				@ui.click('#mynetwork_tab_clients')
				sleep 1
				expect(@ui.css('.ko_slideout_container').attribute_value("class")).not_to include("opened")
			end
		  it "Set the view mode to 'All Clients' and time span to 'All Time'" do
        @ui.set_dropdown_entry('clients_state', 'All Clients')
        sleep 0.5
        @ui.set_dropdown_entry('clients_span', 'All time')
        sleep 0.5
      end
			it "Go to the first page of the grid (if possible) and open the first client in the grid and move to other clients" do
				if @ui.css('.nssg-paging-first').visible?
					@ui.click('.nssg-paging-first')
					sleep 2
				end
				@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) a').hover and sleep 2
				@ui.click('.nssg-table tbody tr:nth-child(1) .nssg-td-actions .nssg-action-invoke')
				sleep 2
				expect(@ui.css('.ko_slideout_container').attribute_value("class")).to include("opened")
				while @ui.css('#grid-sidepanel-details-next').attribute_value("disabled") == nil
					first_title = @ui.css('.ko_slideout_content .client-health-title .title').text
					@ui.click('#grid-sidepanel-details-next')
					sleep 2
					second_title = @ui.css('.ko_slideout_content .client-health-title .title').text
					expect(first_title).not_to eq(second_title)
				end
				while @ui.css('#grid-sidepanel-details-prev').attribute_value("disabled") == nil
					first_title = @ui.css('.ko_slideout_content .client-health-title .title').text
					@ui.click('#grid-sidepanel-details-prev')
					sleep 2
					second_title = @ui.css('.ko_slideout_content .client-health-title .title').text
					expect(first_title).not_to eq(second_title)
				end
			end
			it "Collapse and then maximize the slideout" do
				@ui.click('.slideout-collapse-toggle-btn')
				sleep 2
				expect(@ui.css('.ko_slideout_container').attribute_value("class")).to include("opened")
				sleep 2
				@ui.click('.slideout-collapse-toggle-btn.collapsed')
				sleep 2
				expect(@ui.css('.ko_slideout_container').attribute_value("class")).to include("opened")
				@ui.click('.ko_slideout_content .slideout-toggle')
				sleep 1
				expect(@ui.css('.ko_slideout_container').attribute_value("class")).not_to include("opened")
			end
		end
	end
end

shared_examples "open slideout and aternity for client" do |client_hostname|
	describe "Verify the client '#{client_hostname}' and the slideout tab's content" do
		context "General method - Go to Clients Tab (My Network)" do
			it_behaves_like "go to mynetwork clients tab"
		end
		context "Open the client '#{client_hostname}' and verify the slideout tab's content" do
			it "Find the client and open the slideout tab" do
				sleep 3
				@ui.grid_action_on_specific_line(3, "a", client_hostname, "invoke")
				sleep 3
				@ui.css('client-details .ko_slideout_content xc-slideout-content').wait_until_present
			end
			it "Open the 'SteelCentral Aternity' feature dropdown" do
				@ui.click('#client-details-aternity-menu .icon')
				sleep 2
				expect(@ui.css('#client-details-aternity-menu .drop_menu_nav.active')).to be_present
			end
			it "Verify that the available option is named 'Troubleshoot this device'" do
				expect(@ui.css('#client-details-aternity-menu .drop_menu_nav.active a:first-child').text).to eq('Troubleshoot this device')
				expect(@ui.css('#client-details-aternity-menu .drop_menu_nav.active a:nth-child(2)')).not_to exist
			end
			it "Open the Aternity feature and Verify the new browser's URL string" do
				@ui.click('#client-details-aternity-menu .drop_menu_nav.active a:first-child')
				@browser.window(:url => /utest.aternity.com/).wait_until_present
				@browser.window(:url => /utest.aternity.com/) do
            @browser_url_string = @browser.url
          end
			  expect(@browser_url_string).to include("troubleshoot/device/macaddr")
        expect(@browser_url_string).to include("00%3A24%3AD7%3A76%3AB8%3AF8")
			end
  	end
  end
 end

shared_examples "directly search for an a client using the url input of the browser" do |mac_address, client_name, failed_search| # XMSC-561 - Created on 15/01/2018
  describe "Verify that the user is properly navigated if a CLIENT MAC is inserted as the URL of the browser" do
    it "Set the browser url to 'https://www.xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/clients/#{mac_address}'" do
      @browser.execute_script("window.location.replace(\"https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/clients/#{mac_address}\")")
      sleep 3
    end
    it "Verify the following:
          - the location is 'My Network - Clients tab'
          - the URL is 'https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/clients/#{mac_address}'" do
      expect(@ui.css('.nssg-table')).to be_present
      expect(@ui.css('.commonTitle span').text).to eq("Clients on your network")
      expect(@browser.url).to eq("https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/clients/#{mac_address}")
    end
    if failed_search == false
      it "Verify the following:
            - the grid si filtered to that one result
            - the search bubble shows '1' result
            - the details slideout is opened
            - the slideout contains the proper Client's details
            - the clients show filter's value is 'All Clients'
            - the what period show filter's value is 'All time'
            - the profile/group filter show 'All Devices'" do
        expect(@ui.css('xc-slideout-content .client-health-title .title').text).to include(client_name)
        proper_search_box = find_proper_search_box
        expect(proper_search_box.element(css: ".bubble .count").text).to eq("1")
        expect(@ui.css('.client-details .left.opened .ko_slideout_content .slideout-toggle')).to be_present
        expect(@ui.css('.client-details .client-health-title .title').text).to include(client_name)
        expect(@ui.css('#clients_state .text').text).to eq("All Clients")
        expect(@ui.css('#clients_span .text').text).to eq("All time")
        expect(@ui.css('#mynetwork-aps-filter .text').text).to eq("All Devices")
      end
      it "Close the details slideout" do
        @ui.click('.client-details .left.opened .ko_slideout_content .slideout-toggle')
        @ui.css('.client-details .left.opened').wait_while_present
      end
    else
      it "Verify that the 'No Client Found' modal is displayed" do
        @ui.css('.confirm').wait_until_present
        expect(@ui.css('.confirm .title span').text).to eq("No Client Found")
        expect(@ui.css('.confirm .msgbody div').text).to eq("No Client found matching: \"#{mac_address}\"")
      end
      it "Close the modal" do
        @ui.click('#_jq_dlg_btn_0')
        @ui.css('.confirm').wait_while_present
      end
      it "Verify the following:
            - the grid shows the 'No results' search
            - the search bubble shows 0 results" do
        proper_search_box = find_proper_search_box
        expect(proper_search_box.element(css: ".bubble .count").text).to eq("0")
        expect(@ui.css('table tbody tr')).not_to exist
        expect(@ui.css('.noresults')).to be_present
      end
    end
    it "Cancel the search and return the URL to the default value" do
      proper_search_box = find_proper_search_box
      find_proper_search_box.element(css: ".btn-clear").click
      find_proper_search_box.element(css: ".btn-clear").wait_while_present
      @browser.execute_script("window.location.replace(\"https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/clients\")")
      sleep 2
    end
  end
end

shared_examples "verify profile filter on clients" do |profile_group_filter|
	describe "Use the 'Profile/Group' filter on the Clients area and verify that the grid properly responds" do
		it "Filter to the profile/group named '#{profile_group_filter}' and verify that the grid shows a proper amount of entries" do
			if @ui.css('#mynetwork-aps-filter .text').text != "All Devices"
				@ui.set_dropdown_entry("mynetwork-aps-filter", "All Devices")
				sleep 5
			end
			grid_entries_length_max = @ui.css('.nssg-table tbody').trs.length
			@ui.set_dropdown_entry("mynetwork-aps-filter", profile_group_filter)
			sleep 2
			grid_entries_length = @ui.css('.nssg-table tbody').trs.length
			expect(@ui.css("#mynetwork_tab_clients").attribute_value("class")).to eq("selected filtered")
			expect(@browser.execute_script("return $('#mynetwork_tab_clients').css('background-image')")).to include("/img/filter-green.png")
			expect(grid_entries_length_max).to be >= grid_entries_length
		end
	end
end

shared_examples "use profile group filter on clients" do |profile_group_filters|
	context "Set the view mode to 'All Clients' and time span to 'All Time'" do
		it_behaves_like "on clients tab view all clients all time"		
	end
	profile_group_filters.each do |profile_group_filter|
		it_behaves_like 'verify profile filter on clients', profile_group_filter
	end
	context "Reset the view to '10' entries per page" do
		it "Set the view to '10' entries per page" do
		  @browser.refresh
      sleep 5
		  @ui.set_dropdown_entry('clients_state', 'All Clients')
      sleep 0.5
      @ui.set_dropdown_entry('clients_span', 'All time')
      sleep 0.5
      if(@browser.elements(css: "nssg-table nssg-tobdy tr").length > 0)
        @ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "10")
      end			
		end
	end
end

shared_examples "verify profile group dropdown entries" do |profile_groups_entries|
	describe "Verify that the Profile/Group dropdown filter has the proper entries" do
		it "Verify that the filter options are '#{profile_groups_entries}'" do
			expect(@browser.url).to include("/#mynetwork/clients")
			@ui.get(:elements , {css: '.ko_dropdownlist_list.has_search'}).each do |el|
				if !el.attribute_value("class").include?("blue")
					@el_element = el
					break
				end
			end
			@profiles_groups_names_array = []
			@el_element.elements(:css => "ul li").each do |el|
				@profiles_groups_names_array << el.attribute_value("data-value")
			end
			@profiles_groups_names_array.delete_if {|x| x.class != String}
			expect(@ui.css('#mynetwork-aps-filter')).to be_present
			expect(@profiles_groups_names_array.sort).to eq(profile_groups_entries.sort)
			@ui.click('#mynetwork-aps-filter .arrow')
			sleep 1
			expect(@ui.css('.ko_dropdownlist_list.has_search.active')).to be_present
			expect(@ui.css('.ko_dropdownlist_list.has_search.active ul').lis.length).to eq(profile_groups_entries.length + 1)
			@ui.click('.ko_dropdownlist_list.has_search.active ul li:first-child')
			sleep 1
			@ui.click('#mynetwork_tab_clients')
		end
	end
end
shared_examples "directly search for an a client using the url input with time filter" do |mac_address, client_name, time_filter|  
  describe "Verify that the user is properly navigated if a CLIENT MAC and Time filter inserted as the URL of the browser" do
    linuxtime=""
    if (time_filter=="Last 24 Hours")
      linuxtime=(DateTime.now - (2.0/24)).to_time.to_i
    elsif (time_filter=="Last 7 Days")
     linuxtime=(DateTime.now - (2.0)).to_time.to_i
    elsif (time_filter=="Last 30 Days")
      linuxtime=(DateTime.now - (35.0)).to_time.to_i
    end
   it "Ensure you are on the 'My Network' area" do
      if @browser.url.include?("/#mynetwork/overview")
        puts "SKIPPED due to the fact that the application is already on the 'My Network' area"
      else
        @ui.click("#header_nav_mynetwork")
        sleep 1
      end
    end
    it "Set the browser url to 'https://www.xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/clients/#{mac_address}?clientDetailsTimeStamp=#{linuxtime}'" do
      @browser.execute_script("window.location.replace(\"https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/clients/#{mac_address}?clientDetailsTimeStamp=#{linuxtime}\")")
      sleep 3
    end
    it "Verify that Clients details page open for Client #{client_name} and time filter #{time_filter}" do
      expect(@ui.css('.client-health-title')).to be_visible
      expect(@ui.css('.client-health-title .title').text).to include(client_name)
      expect(@ui.css('#client-details-troubleshooting-timeframe').text).to eq(time_filter)
    end
    it "Ensure you are on the 'My Network' area" do
      if @browser.url.include?("/#mynetwork/overview")
        puts "SKIPPED due to the fact that the application is already on the 'My Network' area"
      else
        @ui.click("#header_nav_mynetwork")
        sleep 1
      end
    end
  end
end

shared_examples "directly search for an a access point using the url input with time filter" do |mac_address, ap_name, time_filter|  
  describe "Verify that the user is properly navigated if a Access Point MAC and Time filter inserted as the URL of the browser" do
    linuxtime=""
    if (time_filter=="Last 24 Hours")
      linuxtime=(DateTime.now - (2.0/24)).to_time.to_i
    elsif (time_filter=="Last 7 Days")
     linuxtime=(DateTime.now - (2.0)).to_time.to_i
    elsif (time_filter=="Last 30 Days")
      linuxtime=(DateTime.now - (35.0)).to_time.to_i
    end
    it "Ensure you are on the 'My Network' area" do
      if @browser.url.include?("/#mynetwork/overview")
        puts "SKIPPED due to the fact that the application is already on the 'My Network' area"
      else
        @ui.click("#header_nav_mynetwork")
        sleep 1
      end
    end
    it "Set the browser url to 'https://www.xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/aps/aps/#{mac_address}/stats?apDetailsTimeStamp=#{linuxtime}'" do
      @browser.execute_script("window.location.replace(\"https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/aps/aps/#{mac_address}/stats?apDetailsTimeStamp=#{linuxtime}\")")
      sleep 3
    end
   it "Verify that Access Point details page open for AP #{ap_name} and time filter #{time_filter}" do
      expect(@ui.css('#arraydetails_tab_troubleshooting')).to be_visible
      expect(@ui.css('.slideout_title .title').text).to include(ap_name)
      expect(@ui.css('#array-details-troubleshooting-timeframe').text).to eq(time_filter)
    end
    it "Ensure you are on the 'My Network' area" do
      if @browser.url.include?("/#mynetwork/overview")
        puts "SKIPPED due to the fact that the application is already on the 'My Network' area"
      else
        @ui.click("#header_nav_mynetwork")
        sleep 1
      end
    end
  end
end
shared_examples "change client name from client slidout and verify" do |original_client_name, new_client_name, client_mac|
  describe "change client name #{original_client_name} to #{new_client_name} from client slidout" do
    it "Find the client and open the slideout tab" do
        sleep 3
        @ui.grid_action_on_specific_line(3, "a", original_client_name, "invoke")
        sleep 3
        @ui.css('client-details .ko_slideout_content xc-slideout-content').wait_until_present
      end
      it "Change client hostname using edit" do
        sleep 1
        @ui.css(".client-edit-icon").click
        @ui.set_input_val("#new-hostname", new_client_name)
        sleep 0.5
        @ui.css("#updateclient_create").click        
      end
      it "verify client name change on details panel" do
        sleep 1
        expect(@ui.css(".client-health-title span.title").text).to include(new_client_name)
        @ui.css("#client-health-detail").click
        sleep 0.5
        expect(@ui.css(".client-troubleshooting-title span:nth-child(1)").text).to eq(new_client_name)
        @ui.css("#mynetwork_tab_clients").click
        @ui.grid_action_on_specific_line(12, "div", client_mac, "tick")
        sleep 0.1
        expect(@ui.css("#mynetwork_general_container table tbody tr:nth-child(#{$grid_length}) td:nth-child(3) a").text).to eq(new_client_name)
      end
  end
end

shared_examples "verify client name on dashboard" do |client_name|
  describe "verify client name #{client_name} on dashboard" do
    it "navigate to dashboard" do
      @ui.css("#mynetwork_tab_overview").click
      sleep 1
      @browser.elements(css: "#myNetworkOverview #dashboardHeader ul li").each do|dashname|
        if dashname.element(css: ".dashname").text == "Clients"
          dashname.click
          break
        end
      end      
    end
    it "verify that station new name is reflecting in list" do
      station_list=[]
      @browser.elements(css: "#dashboardContainer ul li").each do |overview|
        if overview.element(css: ".title span:nth-child(1)").text == "Top Clients"
          puts overview.elements(css: ".widget_table table tbody tr").length
          overview.elements(css: ".widget_table table tbody tr").each do |client|
            station_list << client.element(css: ".TABLEWIDGET_clientHostName span").text
          end
          break
        end        
      end
      expect(station_list).to include(client_name)
    end
  end
end
  
