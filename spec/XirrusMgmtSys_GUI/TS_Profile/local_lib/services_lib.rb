require_relative "profile_lib.rb"
shared_examples "test location services - positive other data format" do |profile_name, url_name, forward_period, customer_key, url_name_2, aos_light|
	describe "This will test the Location Services configuration tab on the profile named #{profile_name} (POSITIVE TESTING) for 'OTHER' data format" do
		it "Open the profile named #{profile_name}" do
			sleep 1
			if aos_light == true
				@ui.click('#profile_tab_config')
			else
				@ui.goto_profile(profile_name)
			end
			sleep 1
			expect(@browser.url).to include("/config")
		end
		it "Go to the Services tab" do
			sleep 1
			@ui.click('#profile_config_advanced')
			sleep 1
			@ui.click('#profile_config_tab_services')
			sleep 1
			expect(@browser.url).to include("/config/services")
		end
		#Need to enable through Floor plan, basic setup update needed.
		# it "Enable the Location Reporting feature" do
			# sleep 1
			# @ui.click('#profile-services-location-enable')
			# sleep 1
		# end
		it "Enable the 'Send location to an external service' switch" do
			if @ui.css('#profile-services-location-send-switch').present?
				@ui.click('#profile-services-location-send-switch')
			end
      sleep 0.5
		end
		if aos_light == true
			it "Verify the 'Location Reporting' container does not show the 'Data Format' switch" do
				expect(@ui.css('#profile-services-location-dataformat')).not_to exist
			end
		else
			it "Verify the 'Location Reporting' container components" do
				expect(@ui.css('#profile-services-location-dataformat')).to be_visible
				expect(@ui.get(:checkbox, {id: 'profile-services-location-dataformat_switch'}).set?).to eq(false)
				expect(@ui.css('#profile-services-location-dataformat').parent.element(:css => '.togglebox_heading').text).to eq('What data format do you want to use?')
				expect(@ui.css('#profile-services-location-dataformat .switch_label .left').text).to eq("XPS")
				expect(@ui.css('#profile-services-location-dataformat .switch_label .right').text).to eq("Other")
				expect(@ui.css('.profile-services-contents.active div:nth-child(3)').attribute_value("style")).not_to eq("display: none;")
			end
		end
		it "Set the URL to forward data to - #{url_name}" do
			@ui.click("#profile-services-forward-url")
			@ui.set_input_val("#profile-services-forward-url", url_name)
			sleep 1
		end
		it "Set the Forwarding period to - #{forward_period}" do
			@ui.click('#profile-services-forward-period')
			@ui.set_input_val('#profile-services-forward-period', forward_period)
			sleep 1
		end
		it "Set the Customer key to - #{customer_key}" do
			@ui.click('#profile-services-customerkey')
			@ui.set_input_val('#profile-services-customerkey', customer_key)
			sleep 1
		end
		it "Press the <SAVE ALL> button" do
			press_profile_save_config_no_schedule
			sleep 1
		end
		it "Verify that the URL field has the value #{url_name} + forwarding period is set to #{forward_period} seconds + customer_key is set + enable per-radio data is set to NO" do
			expect(@ui.get(:text_field, {id: "profile-services-forward-url"}).value).to eq(url_name)
			expect(@ui.get(:text_field, {id: "profile-services-forward-period"}).value).to eq(forward_period.to_s)
			expect(@ui.get(:text_field, {id: "profile-services-customerkey"}).value).not_to eq("")
			expect(@ui.get(:text_field, {id: "profile-services-customerkey"}).value).to eq("--------")
			expect(@ui.get(:checkbox, {id: "profile-services-peradio-enable_switch"}).set?).to eq(false)
		end
		it "Set the enable per-radio data switch to true" do
			@ui.click('#profile-services-peradio-enable')
		end
		it "Press the <SAVE ALL> button" do
			press_profile_save_config_no_schedule
			sleep 1
		end
		it "Verify that the enable per-radio data is set to YES" do
			expect(@ui.get(:checkbox, {id: "profile-services-peradio-enable_switch"}).set?).to eq(true)
		end
		it "Set the Period Forward to - #{forward_period} + 3 using the spinner controls" do
			@ui.click('#profile-services-forward-period')
			(0..2).each do
				@ui.css('#profile-services-forward-period').parent.element(css: '.spinner_controls .spinner_up').click
			end
			sleep 1
		end
		it "Set the URL to forward data to - #{url_name_2}" do
			@ui.click('#profile-services-forward-url')
			@ui.set_input_val('#profile-services-forward-url', url_name_2)
			sleep 1
		end
		it "Press the <SAVE ALL> button" do
			press_profile_save_config_no_schedule
			sleep 1
		end
		it "Verify that the URL field has the value #{url_name_2} + forwarding period is set to #{forward_period} + 3 seconds + customer_key is set + enable per-radio data is set to YES" do
			new_forward_period = forward_period + 3
			expect(@ui.get(:text_field, {id: "profile-services-forward-url"}).value).to eq(url_name_2)
			expect(@ui.get(:text_field, {id: "profile-services-forward-period"}).value).to eq(new_forward_period.to_s)
			expect(@ui.get(:text_field, {id: "profile-services-customerkey"}).value).not_to eq("")
      expect(@ui.get(:text_field, {id: "profile-services-customerkey"}).value).to eq("--------")
			expect(@ui.get(:checkbox, {id: "profile-services-peradio-enable_switch"}).set?).to eq(true)
		end
		#Switch removed from profile
		# it "Disable the Location Reporting feature" do
			# sleep 1
			# @ui.click('#profile-services-location-enable')
			# sleep 1
		# end
		it "Disable the send Location data Reporting feature" do
      sleep 1
      @ui.click('#profile-services-location-send-switch')
      sleep 1
    end
		it "Press the <SAVE ALL> button" do
			press_profile_save_config_no_schedule
			sleep 1
		end
		#Switch removed from profile
		# it "Verify that the Location Reporting switch is set to NO" do
			# expect(@ui.get(:checkbox, {id: "profile-services-location-enable_switch"}).set?).to eq(false)
		# end
		it "Verify that when reenabling the Location Reporting the 'Customer Key' input field is empty" do
			# @ui.click('#profile-services-location-enable')
			@ui.click('#profile-services-location-send-switch')
			sleep 1
			if !@ui.css('#profile-services-customerkey').visible?
				@ui.click('#profile-services-location-send-switch')
	      sleep 0.5
	    end
	    expect(@ui.get(:text_field, {id: "profile-services-customerkey"}).value).not_to eq("--------")
	    expect(@ui.get(:text_field, {id: "profile-services-customerkey"}).value).to eq("")
		end
		it "Verify changes when canceling the 'Save Changes' prompt" do
			# if @ui.get(:checkbox, {id: "profile-services-location-enable_switch"}).set? == false
				# @ui.click('#profile-services-location-enable')
				# sleep 0.5
				# @ui.click('#profile-services-location-send-switch')
	      # sleep 0.5
			# end
			# sleep 1
			if !@ui.css('#profile-services-forward-url').visible?
				@ui.click('#profile-services-location-send-switch')
	      sleep 0.5
	    end
			@ui.set_input_val('#profile-services-forward-url', url_name)
			sleep 1
			@ui.set_input_val('#profile-services-forward-period', forward_period)
			sleep 1
			@ui.click('#profile_tab_arrays')
			sleep 1
			@ui.click('#_jq_dlg_btn_1')
			sleep 1
			expect(@ui.get(:checkbox, {id: "profile-services-location-send-switch_switch"}).set?).to eq(true)
			expect(@ui.get(:text_field, {id: "profile-services-forward-url"}).value).to eq(url_name)
			expect(@ui.get(:text_field, {id: "profile-services-forward-period"}).value).to eq(forward_period.to_s)
		end
		it "Verify changes when not saving the actions from the 'Save Changes' prompt" do
			sleep 2
			@ui.click('#profile_tab_arrays')
			sleep 1
			@ui.click('#_jq_dlg_btn_0')
			sleep 5
			@ui.click('#profile_tab_config')
			sleep 2
			@ui.click('#profile_config_advanced')
			sleep 1
			@ui.click('#profile_config_tab_services')
			sleep 1
			@browser.refresh
			sleep 5
			expect(@browser.url).to include("/config/services")
			sleep 1
			expect(@ui.get(:checkbox, {id: "profile-services-location-send-switch_switch"}).set?).to eq(false)
		end
		it "Verify changes when saving the actions from the 'Save Changes' prompt" do
			# @ui.click('#profile-services-location-enable')
			# sleep 1
			@ui.click('#profile-services-location-send-switch')
      sleep 0.5
			@ui.set_input_val('#profile-services-forward-url', url_name)
			sleep 1
			@ui.set_input_val('#profile-services-forward-period', forward_period)
			sleep 1
			@ui.click('#profile_tab_arrays')
			sleep 1
			# @ui.click('#_jq_dlg_btn_2') updated due to removed save change option
			@ui.click('#_jq_dlg_btn_1')
			press_profile_save_config_no_schedule
			sleep 6
			@ui.click('#profile_tab_config')
			sleep 2
			@ui.click('#profile_config_advanced')
			sleep 1
			@ui.click('#profile_config_tab_services')
			sleep 1
			@browser.refresh
			sleep 5
			expect(@browser.url).to include("/config/services")
			sleep 1
			expect(@ui.get(:checkbox, {id: "profile-services-location-send-switch_switch"}).set?).to eq(true)
			expect(@ui.get(:text_field, {id: "profile-services-forward-url"}).value).to eq(url_name)
      expect(@ui.get(:text_field, {id: "profile-services-forward-period"}).value).to eq(forward_period.to_s)
		end
		it "Disable the Location Reporting feature" do
			sleep 1
			# @ui.click('#profile-services-location-enable')
			@ui.click('#profile-services-location-send-switch')
			sleep 1
			press_profile_save_config_no_schedule
			sleep 2
			@browser.refresh
			sleep 6
		end
	end
end

shared_examples "test location services - positive xms data format" do |profile_name, url_name, url_name_2|
	describe "This will test the Location Services configuration tab on the profile named #{profile_name} (POSITIVE TESTING) for XMS data format" do
		it "Open the profile named #{profile_name}" do
			sleep 1
			@ui.goto_profile(profile_name)
			sleep 1
			expect(@browser.url).to include("/config")
		end
		it "Go to the Services tab" do
			sleep 1
			@ui.click('#profile_config_advanced')
			sleep 1
			@ui.click('#profile_config_tab_services')
			sleep 1
			expect(@browser.url).to include("/config/services")
		end
		it "Enable the Location Reporting feature and select the 'XPS' data format" do
			# sleep 1
			# @ui.click('#profile-services-location-enable')
			sleep 1
			@ui.click('#profile-services-location-send-switch')
      sleep 2
			@ui.click('#profile-services-location-dataformat')
		end
		it "Verify the 'Location Reporting' container components" do
			expect(@ui.css('#profile-services-location-dataformat')).to be_visible
			expect(@ui.get(:checkbox, {id: 'profile-services-location-dataformat_switch'}).set?).to eq(true)
			expect(@ui.css('#profile-services-location-dataformat').parent.element(:css => '.togglebox_heading').text).to eq('What data format do you want to use?')
			expect(@ui.css('#profile-services-location-dataformat .switch_label .left').text).to eq("XPS")
			expect(@ui.css('#profile-services-location-dataformat .switch_label .right').text).to eq("Other")
			expect(@ui.css('.profile-services-contents.active div:nth-child(3)').attribute_value("style")).to eq("display: none;")
			expect(@ui.css('#profile-services-forward-period')).not_to be_visible
		end
		it "Set the URL to forward data to - #{url_name}" do
			@ui.click("#profile-services-forward-url")
			@ui.set_input_val("#profile-services-forward-url", url_name)
			sleep 1
		end
		it "Press the <SAVE ALL> button" do
			press_profile_save_config_no_schedule
			sleep 1
		end
		it "Expect that the URL value is kept ('#{url_name}')" do
			expect(@ui.get(:input, {id: 'profile-services-forward-url'}).value).to eq(url_name)
		end
		it "Change the value in the URL field to '#{url_name_2}'" do
			@ui.set_input_val("#profile-services-forward-url", url_name_2)
			sleep 1
		end
		it "Press the <SAVE ALL> button" do
			press_profile_save_config_no_schedule
			sleep 1
		end
		it "Expect that the URL value is kept ('#{url_name_2}')" do
			expect(@ui.get(:input, {id: 'profile-services-forward-url'}).value).to eq(url_name_2)
		end
	end
end

shared_examples "test location services - negatige" do |profile_name|
	describe "This will test the Location Services configuration tab on the profile named #{profile_name} (NEGATIVE TESTING)" do
		it "Refresh the browser and ensure that the Services page is displayed" do
			sleep 1
			@browser.refresh
			sleep 4
			@ui.click('#profile_config_advanced')
			sleep 1
			@ui.click('#profile_config_tab_services')
			sleep 1
			expect(@browser.url).to include("/config/services")
		end
		# it "Enable the Location Reporting feature" do
			# sleep 1
			# @ui.click('#profile-services-location-enable')
			# sleep 1
		# end
		it "Enable the 'Send location to an external service' switch" do
			if @ui.css('#profile-services-location-send-switch').present?
				@ui.click('#profile-services-location-send-switch')
			end
      sleep 0.5
		end
		it "Set the URL to forward data to empty and verify the error tooltip is properly displayed (This field is required.)" do
			@ui.click('#profile-services-forward-url')
			@ui.set_input_val('#profile-services-forward-url', ' ')
			@ui.click('#profile_config_services_view .commonSubtitle')
			@ui.set_input_val('#profile-services-forward-url', '')
			@ui.click('#profile_config_services_view .commonSubtitle')
			sleep 1
			expect(@ui.css('#profile_config_services_view .togglebox .togglebox_contents .services-field .xirrus-error')).to be_visible
			expect(@ui.css('#profile_config_services_view .togglebox .togglebox_contents .services-field .xirrus-error').text).to eq("This field is required.")
			expect(@ui.css('#profile_config_tab_services .invalidIcon')).to be_visible
		end
		it "Set the URL to forward data to the string 'INCORRECT URL' and verify the error tooltip is properly displayed (Please enter a valid url.)" do
			@ui.click('#profile-services-forward-url')
			@ui.set_input_val('#profile-services-forward-url', 'INCORRECT URL')
			@ui.click('#profile_config_services_view .commonSubtitle')
			sleep 1
			expect(@ui.css('#profile_config_services_view .togglebox .togglebox_contents .services-field .xirrus-error')).to be_visible
			expect(@ui.css('#profile_config_services_view .togglebox .togglebox_contents .services-field .xirrus-error').text).to eq("Please enter a valid url.")
			expect(@ui.css('#profile_config_tab_services .invalidIcon')).to be_visible
		end
		it "Press the <SAVE ALL> button" do
			press_profile_save_config_no_schedule
			sleep 1
		end
		it "Verify that the user properly receives an error message" do
			sleep 1
			expect(@ui.css('.temperror')).to be_visible
			sleep 5
		end
		it "Verify min/max values for the Forwarding period control (5/50000)" do
			if @browser.button(:text => 'Cancel').visible?
                @browser.button(:text => 'Cancel').click
            end
			sleep 1
			@ui.set_input_val('#profile-services-forward-period', "91342")
			sleep 1
			(0..2).each do
				@ui.css('#profile-services-forward-period').parent.element(css: '.spinner_controls .spinner_up').click
			end
			sleep 1
			@ui.click('#profile_config_services_view .commonSubtitle')
			expect(@ui.get(:input, {css: '#profile-services-forward-period'}).value).to eq("50000")

			sleep 1
			@ui.set_input_val('#profile-services-forward-period', "0")
			sleep 1
			(0..2).each do
				@ui.css('#profile-services-forward-period').parent.element(css: '.spinner_controls .spinner_down').click
			end
			sleep 1
			@ui.click('#profile_config_services_view .commonSubtitle')
			expect(@ui.get(:input, {css: '#profile-services-forward-period'}).value).to eq("5")
		end
		it "Verify the customer key input box supports a 50 character string" do

			test_pass = "Abcdefghij0123456789_abcdefghi9876543210!@#$%^&*()"

			sleep 1
			@ui.set_input_val('#profile-services-forward-url', "https://google.com")
			sleep 1
			@ui.set_input_val('#profile-services-customerkey', test_pass)
			sleep 1
			press_profile_save_config_no_schedule
			sleep 1
			expect(@ui.get(:input, {css: '#profile-services-customerkey'}).value).not_to eq("")
			expect(@ui.get(:input, {css: '#profile-services-customerkey'}).value).to eq("--------")
		end
	end
end
shared_examples "test location services - MAC address hashing non-xps" do |profile_name, url_name, forward_period, customer_key, url_name_2, aos_light|
  describe "This will test the Location Services configuration tab on the profile named #{profile_name} (POSITIVE TESTING) for 'OTHER' data format" do
    it "Open the profile named #{profile_name}" do
      sleep 1
      if aos_light == true
        @ui.click('#profile_tab_config')
      else
        @ui.goto_profile(profile_name)
      end
      sleep 1
      expect(@browser.url).to include("/config")
    end
    it "Go to the Services tab" do
      sleep 1
      @ui.click('#profile_config_advanced')
      sleep 1
      @ui.click('#profile_config_tab_services')
      sleep 1
      expect(@browser.url).to include("/config/services")
    end
    it "Enable the 'Send location to an external service' switch" do
      if @ui.css('#profile-services-location-send-switch').present?
        @ui.click('#profile-services-location-send-switch')
      end
      sleep 0.5
    end
    if aos_light == true
      it "Verify the 'Location Reporting' container does not show the 'Data Format' switch" do
        expect(@ui.css('#profile-services-location-dataformat')).not_to exist
      end
    else
      it "Verify the 'Location Reporting' container components" do
        expect(@ui.css('#profile-services-location-dataformat')).to be_visible
        expect(@ui.get(:checkbox, {id: 'profile-services-location-dataformat_switch'}).set?).to eq(false)
        expect(@ui.css('#profile-services-location-dataformat').parent.element(:css => '.togglebox_heading').text).to eq('What data format do you want to use?')
        expect(@ui.css('#profile-services-location-dataformat .switch_label .left').text).to eq("XPS")
        expect(@ui.css('#profile-services-location-dataformat .switch_label .right').text).to eq("Other")
        expect(@ui.css('.profile-services-url-label').text).to eq("Provide a URL to forward data:")
        expect(@ui.css('.services-field .services-label').text).to eq("Forwarding period (sec.):")
        expect(@ui.css('.services-field.services-per-radio .services-label').text).to eq("Would you like to enable per-radio data?")
        expect(@ui.css('.services-field.services-macaddress-hashing .services-label').text).to eq("Enable MAC Address hashing")
        expect(@ui.get(:checkbox,{id: 'profile-services-macaddress-hash-switch_switch'}).set?).to eq(false)        
      end
    end
    it "Set the URL to forward data to - #{url_name}" do
      @ui.click("#profile-services-forward-url")
      @ui.set_input_val("#profile-services-forward-url", url_name)
      sleep 1
    end
    it "Set the Forwarding period to - #{forward_period}" do
      @ui.click('#profile-services-forward-period')
      @ui.set_input_val('#profile-services-forward-period', forward_period)
      sleep 1
    end
    it "set MAC address hasing enable" do
       @ui.click('#profile-services-macaddress-hash-switch')
       sleep 1
       expect(@ui.css('#profile-services-macaddress-hash-methods .ko_dropdownlist_button .text').text).to eq("MD5")
       @ui.set_dropdown_entry("profile-services-macaddress-hash-methods", "SHA1")
       sleep 1
       expect(@ui.css('#profile-services-macaddress-hash-methods .ko_dropdownlist_button .text').text).to eq("SHA1")
       @ui.set_dropdown_entry("profile-services-macaddress-hash-methods", "Customer or Encryption Key")
       sleep 1
       expect(@ui.css('#profile-services-macaddress-hash-methods .ko_dropdownlist_button .text').text).to eq("Customer or Encryption Key")
       sleep 1
    end      
    it "Set the Customer key to - #{customer_key}" do
      @ui.click('#profile-services-customerkey')
      @ui.set_input_val('#profile-services-customerkey', customer_key)
      sleep 1
    end
    it "Press the <SAVE ALL> button" do
      press_profile_save_config_no_schedule
      sleep 1
    end
    it "Verify that the URL field has the value #{url_name} + forwarding period is set to #{forward_period} seconds + customer_key is set + enable per-radio data is set to NO" do
      expect(@ui.get(:text_field, {id: "profile-services-forward-url"}).value).to eq(url_name)
      expect(@ui.get(:text_field, {id: "profile-services-forward-period"}).value).to eq(forward_period.to_s)
      expect(@ui.get(:text_field, {id: "profile-services-customerkey"}).value).not_to eq("")
      expect(@ui.get(:text_field, {id: "profile-services-customerkey"}).value).to eq("--------")
      expect(@ui.get(:checkbox, {id: "profile-services-peradio-enable_switch"}).set?).to eq(false)
      expect(@ui.get(:checkbox,{id: 'profile-services-macaddress-hash-switch_switch'}).set?).to eq(true)   
    end
    it "Set the enable per-radio data switch to true" do
      @ui.click('#profile-services-peradio-enable')
    end
    it "Press the <SAVE ALL> button" do
      press_profile_save_config_no_schedule
      sleep 1
    end
    it "Verify that the enable per-radio data is set to YES" do
      expect(@ui.get(:checkbox, {id: "profile-services-peradio-enable_switch"}).set?).to eq(true)
    end
    it "Set the Period Forward to - #{forward_period} + 3 using the spinner controls" do
      @ui.click('#profile-services-forward-period')
      (0..2).each do
        @ui.css('#profile-services-forward-period').parent.element(css: '.spinner_controls .spinner_up').click
      end
      sleep 1
    end
    it "Set the URL to forward data to - #{url_name_2}" do
      @ui.click('#profile-services-forward-url')
      @ui.set_input_val('#profile-services-forward-url', url_name_2)
      sleep 1
    end
    it "Press the <SAVE ALL> button" do
      press_profile_save_config_no_schedule
      sleep 1
    end
    it "Verify that the URL field has the value #{url_name_2} + forwarding period is set to #{forward_period} + 3 seconds + customer_key is set + enable per-radio data is set to YES" do
      new_forward_period = forward_period + 3
      expect(@ui.get(:text_field, {id: "profile-services-forward-url"}).value).to eq(url_name_2)
      expect(@ui.get(:text_field, {id: "profile-services-forward-period"}).value).to eq(new_forward_period.to_s)
      expect(@ui.get(:text_field, {id: "profile-services-customerkey"}).value).not_to eq("")
      expect(@ui.get(:text_field, {id: "profile-services-customerkey"}).value).to eq("--------")
      expect(@ui.get(:checkbox, {id: "profile-services-peradio-enable_switch"}).set?).to eq(true)
    end
    it "Disable the send Location data Reporting feature" do
      sleep 1
      @ui.click('#profile-services-location-send-switch')
      sleep 1
    end
    it "Press the <SAVE ALL> button" do
      press_profile_save_config_no_schedule
      sleep 1
    end
    it "Verify that when reenabling the Location Reporting the 'MAC Address Hasing' switch should be disable" do
      @ui.click('#profile-services-location-send-switch')
      sleep 1
      expect(@ui.get(:checkbox,{id: 'profile-services-macaddress-hash-switch_switch'}).set?).to eq(false)
    end
    it "Verify changes when canceling the 'Save Changes' prompt" do
      if !@ui.css('#profile-services-forward-url').visible?
        @ui.click('#profile-services-location-send-switch')
        sleep 0.5
      end
      @ui.set_input_val('#profile-services-forward-url', url_name)
      sleep 1
      @ui.set_input_val('#profile-services-forward-period', forward_period)
      sleep 1
      @ui.click('#profile_tab_arrays')
      sleep 1
      @ui.click('#_jq_dlg_btn_1')
      sleep 1
      expect(@ui.get(:checkbox, {id: "profile-services-location-send-switch_switch"}).set?).to eq(true)
      expect(@ui.get(:text_field, {id: "profile-services-forward-url"}).value).to eq(url_name)
      expect(@ui.get(:text_field, {id: "profile-services-forward-period"}).value).to eq(forward_period.to_s)
    end
    it "Verify changes when not saving the actions from the 'Save Changes' prompt" do
      sleep 2
      @ui.click('#profile_tab_arrays')
      sleep 1
      @ui.click('#_jq_dlg_btn_0')
      sleep 5
      @ui.click('#profile_tab_config')
      sleep 2
      @ui.click('#profile_config_advanced')
      sleep 1
      @ui.click('#profile_config_tab_services')
      sleep 1
      @browser.refresh
      sleep 5
      expect(@browser.url).to include("/config/services")
      sleep 1
      expect(@ui.get(:checkbox, {id: "profile-services-location-send-switch_switch"}).set?).to eq(false)
    end
    it "Verify changes when saving the actions from the 'Save Changes' prompt" do
      @ui.click('#profile-services-location-send-switch')
      sleep 0.5
      @ui.set_input_val('#profile-services-forward-url', url_name)
      sleep 1
      @ui.set_input_val('#profile-services-forward-period', forward_period)
      sleep 1
      @ui.click('#profile_tab_arrays')
      sleep 1
      @ui.click('#_jq_dlg_btn_1')
      press_profile_save_config_no_schedule
      sleep 6
      @ui.click('#profile_tab_config')
      sleep 2
      @ui.click('#profile_config_advanced')
      sleep 1
      @ui.click('#profile_config_tab_services')
      sleep 1
      @browser.refresh
      sleep 5
      expect(@browser.url).to include("/config/services")
      sleep 1
      expect(@ui.get(:checkbox, {id: "profile-services-location-send-switch_switch"}).set?).to eq(true)
      expect(@ui.get(:text_field, {id: "profile-services-forward-url"}).value).to eq(url_name)
      expect(@ui.get(:text_field, {id: "profile-services-forward-period"}).value).to eq(forward_period.to_s)
    end
    it "Disable the Location Reporting feature" do
      sleep 1
      @ui.click('#profile-services-location-send-switch')
      sleep 1
      press_profile_save_config_no_schedule
      sleep 2
      @browser.refresh
      sleep 6
    end
  end
end