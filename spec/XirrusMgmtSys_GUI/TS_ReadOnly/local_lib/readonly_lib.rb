require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"

def get_profile_tile(name)
	profile_list = @ui.id("profiles_list")
    profile_list.wait_until_present
    profile = profile_list.element(:css => ".tile span[title='" + name + "']")
    sleep 0.5
    profile.parent.parent
end

def get_portals_tile(name)
	portals_list = @ui.id("guestportals_list")
    portals_list.wait_until_present
    portal = portals_list.element(:css => ".tile span[title='" + name + "']")
    sleep 0.5
    portal.parent.parent
end

def get_reports_tile(name)
	reporst_list = @ui.id("reports_list")
    reporst_list.wait_until_present
    report = reporst_list.element(:css => ".tile span[title='" + name + "']")
    sleep 0.5
    report.parent.parent
end

shared_examples "verify command center admin area readonly" do
	describe "Verify that using a Read-Only account on the Command Center area does not create any issues" do
		it "Verify Command center admin area" do
			expect(@browser.url).to include("msp/dashboard")
			expect(@ui.css('.right-tab-menu').spans.length).to eq(1)
			expect(@ui.css('#msp_tab_dashboard')).to be_present
			expect(@ui.css('.commonTitle')).to exist
			expect(@ui.css('.xc-search')).to exist
		end
	end
end

shared_examples "main readonly warning bar" do |msp|  #Changed on 31/05/2017 - due to US4935
	describe "Verify that the 'Main Read-Only Warning Bar' is displayed on all screens of the application" do
		it "Ensure the 'Main Read-Only Warning Bar' is displayed on the home screen" do
			if msp == true
				expect(@browser.url).to include('/#msp/dashboard')
				expect(@ui.css('.right-tab-menu').spans.length).to eq(1)
				expect(@ui.css('.right-tab-menu').span.text).to eq("Dashboard")
			else
				expect(@browser.url).to include('/#mynetwork/overview')
			end
			expect(@ui.css('.read-only-warning')).to be_present
			expect(@ui.css('.read-only-warning').text).to eq('Read-only view - Any changes made to settings will not be saved')
		end
		it "Ensure the 'Main Read-Only Warning Bar' is displayed on the 'Profiles' landing page" do
			@ui.click('#header_nav_profiles')
			sleep 0.5
			@ui.click('#header_nav_profiles #view_all_nav_item')
			sleep 1
			expect(@browser.url).to include('/#profiles')
			expect(@ui.css('.read-only-warning')).to be_present
			expect(@ui.css('.read-only-warning').text).to eq('Read-only view - Any changes made to settings will not be saved')
		end
		if msp == false
			it "Ensure the 'Main Read-Only Warning Bar' is displayed on the 'Access Services' landing page" do
				@ui.click('#header_nav_guestportals')
				sleep 0.5
				@ui.click('#header_nav_guestportals #view_all_nav_item')
				sleep 1
				expect(@browser.url).to include('/#guestportals')
				expect(@ui.css('.read-only-warning')).to be_present
				expect(@ui.css('.read-only-warning').text).to eq('Read-only view - Any changes made to settings will not be saved')
			end
			it "Ensure the 'Main Read-Only Warning Bar' is displayed on the 'Reports' landing page" do
				@ui.click('#header_nav_reports')
				sleep 0.5
				@ui.click('#header_nav_reports #view_all_nav_item')
				sleep 1
				expect(@browser.url).to include('/#reports')
				expect(@ui.css('.read-only-warning')).to be_present
				expect(@ui.css('.read-only-warning').text).to eq('Read-only view - Any changes made to settings will not be saved')
			end
		end
		it "Ensure the 'Main Read-Only Warning Bar' is displayed on the 'Contact Us...' page" do
			@ui.click('#header_nav_user')
			sleep 0.5
			@ui.click('#header_contact')
			sleep 1
			expect(@browser.url).to include('/#contact')
			expect(@ui.css('.read-only-warning')).to be_present
			expect(@ui.css('.read-only-warning').text).to eq('Read-only view - Any changes made to settings will not be saved')
		end
		it "Ensure the 'Main Read-Only Warning Bar' is displayed on the 'Settings' page" do
			@ui.click('#header_nav_user')
			sleep 0.5
			@ui.click('#header_settings_link')
			sleep 1
			expect(@browser.url).to include('/#settings/myaccount')
			expect(@ui.css('.read-only-warning')).to be_present
			expect(@ui.css('.read-only-warning').text).to eq('Read-only view - Any changes made to settings will not be saved')
		end
	end
end

shared_examples "verify readonly function does not allow the user to perform changes in the application mynetwork" do |profile_name|
	describe "Verify that the user priviledge of Read-Only will not permint any changes to be made within the application" do
		it "Go to the 'My Network' area" do
			@ui.click('#header_mynetwork_link')
			sleep 2
		end
		it "Go to the 'Floor Plans' area and verify that there are no editing options available" do
			@ui.click('#mynetwork_tab_locations')
			sleep 2
			expect(@browser.url).to include('/#mynetwork/floorplans')
			expect(@ui.css('#new_location_tile')).not_to exist
			expect(@ui.css('#new_location_btn')).not_to exist
		end
		it "Go to the 'Alerts' area and verify that the grid entries are not editable" do
			@ui.click('#mynetwork_tab_alerts')
			sleep 2
			expect(@browser.url).to include('/#mynetwork/alerts')
			@ui.set_dropdown_entry('mynetwork_alerts_state','All Statuses')
			sleep 0.5
			expect(@ui.css('.nssg-table thead tr .nssg-th-select .mac_chk')).not_to be_visible
		end
		it "Go to the 'Access Points' area and verify that the grid entries are not editable" do
			@ui.click('#mynetwork_tab_arrays')
			sleep 2
			expect(@browser.url).to include('/#mynetwork/aps')
			sleep 0.5
			expect(@ui.css('.nssg-table thead tr .nssg-th-select')).to exist
		end
		#Commenting adding Access Point into profile and Optimized when user is read only - removed option when user get error for privilege
		it "Select first AP in the grid and verify that no move to profile button present on GUI" do
		    access_point_name = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(3) .nssg-td-text").text
		    @ui.grid_tick_on_specific_line("3", access_point_name, "a")
		    sleep 1
		    expect(@ui.css('#mynetwork_arrays_moveto_btn')).not_to exist		    
		    sleep 1
		end
		it "verify that no optimized button present on GUI" do
		    expect(@ui.css('#arrays_optimize_button_btn')).not_to exist		    
		    sleep 1
		end
		# it "Select first AP in the grid and try to move it to the profile '#{profile_name}'" do
		#     access_point_name = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(3) .nssg-td-text").text
		#     @ui.grid_tick_on_specific_line("3", access_point_name, "a")
		#     sleep 1
		#     expect(@ui.css('#mynetwork_arrays_moveto_btn')).not_to exist
		#     expect(@ui.css('#arrays_optimize_button_btn')).not_to exist
		#     @ui.click('.moveto_button')
		#     sleep 1
		#     items = @ui.css('.move_to_nav .items')
		#     items.wait_until_present
		#     item = items.a(:text => profile_name)
		#     item.wait_until_present
		#     item.click
		#     sleep 1
		#     @ui.confirm_dialog
		#     sleep 1
		#     expect(@ui.css('.error')).to exist
		#     #expect(@ui.css('.error .title').text).to eq("403 Forbidden")
		#     #expect(@ui.css('.error .msgbody div').text).to eq("You don’t have permission to perform this operation")
		#    # expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(5) .nssg-td-text").text).to eq("")
		#     sleep 1
		# end
		# it "Press the 'Optimize' button and place a tick in the 'Band' checkbox then press the 'Optimize' button" do
	 #      press_optimize_button_and_verify_dropdown_list_content
	 #      sleep 1
	 #      tick_certain_optimizations_option_and_press_the_optimize_button("Band")
	 #    end
	 #    it "Expect the 'Optimize Access Point(s)' modal to be displayed" do
	 #      verify_optimize_prompt_modal_contents("Band")
	 #    end
	 #    it "Press the 'Optimize Now' button and verify that the proper message is displayed" do
	 #      submit_the_optimizations_and_verify_the_optimizations_message("Read-Only")
	 #    end
	end
end

shared_examples "verify readonly function does not allow the user to perform changes in the application msp profiles" do |profile_name|
  describe "Verify that the user priviledge of Read-Only will not permint any changes to be made within the application" do
    it "Go to the 'Profiles' landing page and verify a new profile cannot be created" do
      @ui.click('#header_nav_profiles')
      sleep 0.5
      @ui.click('#header_nav_profiles #view_all_nav_item')
      sleep 1
      @ui.click('#header_nav_profiles')
      sleep 0.5
      expect(@ui.css('#header_profiles_arrow .profile_nav .button_wrapper')).not_to exist
      @ui.click('#header_nav_profiles')
      sleep 1
      expect(@ui.css('#new_profile_btn')).not_to exist
      expect(@ui.css('#new_profile_tile')).not_to exist
    end
    it "On the 'Profiles' landing page verify that on hover, the context buttons are not displayed" do
      needed_profile = get_profile_tile(profile_name)
      needed_profile.hover
      sleep 1
      hover_overlay = needed_profile.element(:css => ".overlay")
      expect(hover_overlay).not_to exist
      sleep 0.5
    end
    it "Open the profile named '#{profile_name}' and verify that the 'Tools' dropdown list and the 'Save All' button are not displayed" do
      get_profile_tile(profile_name).click
      sleep 1
      expect(@ui.css('#profile_menu_btn')).not_to exist
      expect(@ui.css('#profile_config_save_btn')).not_to exist
    end
    it "Edit the name and description fields, navigate to the Access Points then back and verify that the editing has not be saved" do
      profile_name_input = @ui.get(:text_field, {id: 'profile_config_basic_profilename'})
      description_input = @ui.get(:textarea, {id: 'profile_config_basic_description'})

      profile_name_value = profile_name_input.value
      description_value = description_input.value

      profile_name_input.set "TEST NAME"
      description_input.set "TEST DESCRIPTION"

      @ui.click('#header_mynetwork_link')
      sleep 0.5
      expect(@ui.css('.dialogOverlay')).not_to exist
      sleep 3
      @ui.click('#header_nav_profiles')
      sleep 0.5
      @ui.click('#header_nav_profiles #view_all_nav_item')
      sleep 1
      get_profile_tile(profile_name).click
      sleep 1
      @ui.click('#profile_tab_config')
      sleep 1
      profile_name_input = @ui.get(:text_field, {id: 'profile_config_basic_profilename'})
      description_input = @ui.get(:textarea, {id: 'profile_config_basic_description'})

      expect(profile_name_value).to eq(profile_name_input.value)
      expect(description_value).to eq(description_input.value)
    end
    it "Go to the SSIDs tab, add an new line, navigate to the clients tab then back and verify that the line is not saved" do
      @ui.click('#profile_config_tab_ssids')
      sleep 3
      expect(@ui.css('.nssg-table .tbody')).not_to exist

      @ui.click('#profile_ssid_addnew_btn')
      sleep 1
      @ui.get(:text_field, {css: '.nssg-table tbody tr:first-child td:nth-child(3) input'}).set "TEST SSID"

      @ui.click('#profile_config_ssids_view .commonTitle')
      expect(@ui.css('.nssg-table tbody').trs.length).to eq(1)

      @ui.click('#header_mynetwork_link')
      sleep 0.5
      expect(@ui.css('.dialogOverlay')).not_to exist
      sleep 3
      @ui.click('#header_nav_profiles')
      sleep 0.5
      @ui.click('#header_nav_profiles #view_all_nav_item')
      sleep 1
      get_profile_tile(profile_name).click
      sleep 1
      @ui.click('#profile_tab_config')
      sleep 1
      @ui.click('#profile_config_tab_ssids')
      sleep 1
      expect(@ui.css('.nssg-table .tbody')).not_to exist
    end
    it "Go to the Network tab, enable VLAN support, navigate to the home page, return to the profile and verify that the VLAN support is not enabled" do
      @ui.click('#profile_config_tab_network')
      sleep 1
      @ui.click('#network_show_advanced')
      sleep 0.5

      @ui.click('#profile_config_network_enableVLAN .switch_label .left')
      sleep 0.5
      @ui.set_input_val('#profile-config-network-vlans-input',"222")
      sleep 0.5
      @ui.click('#profile-config-network-vlans-btn')
      sleep 1

      @ui.click('#header_mynetwork_link')
      sleep 0.5
      expect(@ui.css('.dialogOverlay')).not_to exist
      sleep 3

      @ui.click('#header_nav_profiles')
      sleep 0.5
      @ui.click('#header_nav_profiles #view_all_nav_item')
      sleep 1
      get_profile_tile(profile_name).click
      sleep 1

      @ui.click('#profile_config_tab_network')
      sleep 1
      @ui.click('#network_show_advanced')
      sleep 0.5

      expect(@ui.get(:checkbox, {id: "profile_config_network_enableVLAN_switch"}).set?).to eq(false)
    end
    it "GO to the policies tab, add a policy and verify it is not remembered upon reloading the profile" do
      @ui.click('#profile_config_tab_policies')
      sleep 3
      @ui.click('.policies-container .policy-type-container:first-child .policy-head .policy-head-right .white.v-center.push-left')
      sleep 1
      @ui.click('#policy-rule-submit')
      sleep 1
      @ui.click('#header_nav_profiles')
      sleep 0.5
      @ui.click('#header_nav_profiles #view_all_nav_item')
      sleep 0.5
      expect(@ui.css('.dialogOverlay')).not_to exist
      sleep 3
      get_profile_tile(profile_name).click
      sleep 1

      @ui.click('#profile_config_tab_policies')
      sleep 1
      expect(@ui.css('.policies-container .policy-type-container:first-child .policy-head .policy-head-right .policy-rule-count').text).to eq("0 Rules")
      sleep 1
    end
    it "Go to the Admin tab, Optimizations tab and Services tab, verify that none of the changes are kept" do
      expect(@ui.css('#profile_config_tab_bonjour').attribute_value("class")).not_to eq("profile_config_tab disabled")
      sleep 1

      @ui.click('#profile_config_tab_admin')
      sleep 1
      @ui.set_input_val('#profile_config_admin_name', "TEST NAME")
      sleep 0.5

      email = @ui.get(:text_field, { id: 'profile_config_admin_email' })
        email.wait_until_present
          email.set "updateemail@xirrus.com"

      @ui.click('#profile_config_advanced')
      sleep 0.5
      @ui.click('#profile_config_tab_optimization')
      sleep 1


          client_togglebox = @ui.css('#optimize_client .opt_header a')
          client_togglebox.wait_until_present
          if(client_togglebox.attribute_value("class")=="expand_collapse")
              client_togglebox.click
          end
          @ui.click('#optimization_fastroam_switch .switch_label')
          sleep 1

          expect(@ui.get(:checkbox, {id: "optimization_fastroam_switch_switch"}).set?).to eq(false)

      @ui.click('#profile_config_tab_services')
      sleep 1
      @ui.click('#profile-services-location-send-switch')
      sleep 1
      @ui.click('#profile_config_services_view .togglebox .togglebox_contents .services-field .full')
      @ui.set_input_val('#profile_config_services_view .togglebox .togglebox_contents .services-field .full', "https://www.test.com")
      sleep 1
      @ui.click('#header_logo')
      sleep 0.5
      expect(@ui.css('.dialogOverlay')).not_to exist
      sleep 3
      @ui.click('#header_nav_profiles')
      sleep 0.5
      @ui.click('#header_nav_profiles #view_all_nav_item')
      sleep 1
      get_profile_tile(profile_name).click
      sleep 1

      expect(@ui.css('#profile_config_tab_bonjour').attribute_value("class")).not_to eq("profile_config_tab disabled")
      sleep 1

      @ui.click('#profile_config_tab_admin')
      sleep 1
      expect(@ui.get(:text_field, {id: "profile_config_admin_name"}).value).to eq("")
      expect(email.value).not_to eq("updateemail@xirrus.com")
      sleep 0.5
      @ui.click('#profile_config_advanced')
      sleep 0.5

      @ui.click('#profile_config_tab_optimization')
      sleep 1
      client_togglebox = @ui.css('#optimize_client .opt_header a')
          client_togglebox.wait_until_present
          if(client_togglebox.attribute_value("class")=="expand_collapse")
              client_togglebox.click
          end
          sleep 1

          expect(@ui.get(:checkbox, {id: "optimization_fastroam_switch_switch"}).set?).to eq(true)


      @ui.click('#profile_config_tab_services')
      sleep 1
      expect(@ui.get(:checkbox, {css: "#profile_config_services_view .togglebox .switch .switch_checkbox"}).set?).to eq(false)
    end    
  end
end

shared_examples "verify readonly function does not allow the user to perform changes in the application profiles" do |profile_name|
	describe "Verify that the user priviledge of Read-Only will not permint any changes to be made within the application" do
		it "Go to the 'Profiles' landing page and verify a new profile cannot be created" do
			@ui.click('#header_nav_profiles')
			sleep 0.5
			@ui.click('#header_nav_profiles #view_all_nav_item')
			sleep 1
			@ui.click('#header_nav_profiles')
			sleep 0.5
			expect(@ui.css('#header_profiles_arrow .profile_nav .button_wrapper')).not_to exist
			@ui.click('#header_nav_profiles')
			sleep 1
			expect(@ui.css('#new_profile_btn')).not_to exist
			expect(@ui.css('#new_profile_tile')).not_to exist
		end
		it "On the 'Profiles' landing page verify that on hover, the context buttons are not displayed" do
			needed_profile = get_profile_tile(profile_name)
			needed_profile.hover
			sleep 1
			hover_overlay = needed_profile.element(:css => ".overlay")
			expect(hover_overlay).not_to exist
			sleep 0.5
		end
		it "Open the profile named '#{profile_name}' and verify that the 'Tools' dropdown list and the 'Save All' button are not displayed" do
			get_profile_tile(profile_name).click
			sleep 1
			expect(@ui.css('#profile_menu_btn')).not_to exist
			expect(@ui.css('#profile_config_save_btn')).not_to exist
		end
		it "Edit the name and description fields, navigate to the Access Points then back and verify that the editing has not be saved" do
			profile_name_input = @ui.get(:text_field, {id: 'profile_config_basic_profilename'})
			description_input = @ui.get(:textarea, {id: 'profile_config_basic_description'})

			profile_name_value = profile_name_input.value
			description_value = description_input.value

			profile_name_input.set "TEST NAME"
			description_input.set "TEST DESCRIPTION"

			sleep 1
			@ui.click('#profile_tab_arrays')
			sleep 0.5
			expect(@ui.css('.dialogOverlay')).not_to exist
			sleep 3

			@ui.click('#profile_tab_config')
			sleep 1

			profile_name_input = @ui.get(:text_field, {id: 'profile_config_basic_profilename'})
			description_input = @ui.get(:textarea, {id: 'profile_config_basic_description'})

			expect(profile_name_value).to eq(profile_name_input.value)
			expect(description_value).to eq(description_input.value)
		end
		it "Go to the SSIDs tab, add an new line, navigate to the clients tab then back and verify that the line is not saved" do
			@ui.click('#profile_config_tab_ssids')
			sleep 3
			expect(@ui.css('.nssg-table .tbody')).not_to exist

			@ui.click('#profile_ssid_addnew_btn')
			sleep 1
			@ui.get(:text_field, {css: '.nssg-table tbody tr:first-child td:nth-child(3) input'}).set "TEST SSID"

			@ui.click('#profile_config_ssids_view .commonTitle')
			expect(@ui.css('.nssg-table tbody').trs.length).to eq(1)

			@ui.click('#profile_tab_clients')
			sleep 0.5
			expect(@ui.css('.dialogOverlay')).not_to exist
			sleep 3

			@ui.click('#profile_tab_config')
			sleep 1
			@ui.click('#profile_config_tab_ssids')
			sleep 1
			expect(@ui.css('.nssg-table .tbody')).not_to exist
		end
		it "Go to the Network tab, enable VLAN support, navigate to the home page, return to the profile and verify that the VLAN support is not enabled" do
			@ui.click('#profile_config_tab_network')
			sleep 1
			@ui.click('#network_show_advanced')
			sleep 0.5

			@ui.click('#profile_config_network_enableVLAN .switch_label .left')
			sleep 0.5
			@ui.set_input_val('#profile-config-network-vlans-input',"222")
			sleep 0.5
			@ui.click('#profile-config-network-vlans-btn')
			sleep 1

			@ui.click('#header_mynetwork_link')
			sleep 0.5
			expect(@ui.css('.dialogOverlay')).not_to exist
			sleep 3

			@ui.click('#header_nav_profiles')
			sleep 0.5
			@ui.click('#header_nav_profiles #view_all_nav_item')
			sleep 1
			get_profile_tile(profile_name).click
			sleep 1

			@ui.click('#profile_config_tab_network')
			sleep 1
			@ui.click('#network_show_advanced')
			sleep 0.5

			expect(@ui.get(:checkbox, {id: "profile_config_network_enableVLAN_switch"}).set?).to eq(false)
		end
		it "GO to the policies tab, add a policy and verify it is not remembered upon reloading the profile" do
			@ui.click('#profile_config_tab_policies')
			sleep 3
			@ui.click('.policies-container .policy-type-container:first-child .policy-head .policy-head-right .white.v-center.push-left')
			sleep 1
			@ui.click('#policy-rule-submit')
			sleep 1
			@ui.click('#header_nav_profiles')
			sleep 0.5
			@ui.click('#header_nav_profiles #view_all_nav_item')
			sleep 0.5
			expect(@ui.css('.dialogOverlay')).not_to exist
			sleep 3
			get_profile_tile(profile_name).click
			sleep 1

			@ui.click('#profile_config_tab_policies')
			sleep 1
			expect(@ui.css('.policies-container .policy-type-container:first-child .policy-head .policy-head-right .policy-rule-count').text).to eq("0 Rules")
			sleep 1
		end
		it "Go to the Admin tab, Optimizations tab and Services tab, verify that none of the changes are kept" do
			expect(@ui.css('#profile_config_tab_bonjour').attribute_value("class")).not_to eq("profile_config_tab disabled")
			sleep 1

			@ui.click('#profile_config_tab_admin')
			sleep 1
			@ui.set_input_val('#profile_config_admin_name', "TEST NAME")
			sleep 0.5

			email = @ui.get(:text_field, { id: 'profile_config_admin_email' })
		    email.wait_until_present
      		email.set "updateemail@xirrus.com"

			@ui.click('#profile_config_advanced')
			sleep 0.5
			@ui.click('#profile_config_tab_optimization')
			sleep 1


	        client_togglebox = @ui.css('#optimize_client .opt_header a')
	        client_togglebox.wait_until_present
	        if(client_togglebox.attribute_value("class")=="expand_collapse")
	            client_togglebox.click
	        end
	        @ui.click('#optimization_fastroam_switch .switch_label')
	        sleep 1

	        expect(@ui.get(:checkbox, {id: "optimization_fastroam_switch_switch"}).set?).to eq(false)

			@ui.click('#profile_config_tab_services')
			sleep 1

			@ui.click('#profile-services-location-send-switch')
			sleep 1

			@ui.click('#profile_config_services_view .togglebox .togglebox_contents .services-field .full')
			@ui.set_input_val('#profile_config_services_view .togglebox .togglebox_contents .services-field .full', "https://www.test.com")
			sleep 1

			@ui.click('#header_logo')
			sleep 0.5
			expect(@ui.css('.dialogOverlay')).not_to exist
			sleep 3

			@ui.click('#header_nav_profiles')
			sleep 0.5
			@ui.click('#header_nav_profiles #view_all_nav_item')
			sleep 1
			get_profile_tile(profile_name).click
			sleep 1

			expect(@ui.css('#profile_config_tab_bonjour').attribute_value("class")).not_to eq("profile_config_tab disabled")
			sleep 1

			@ui.click('#profile_config_tab_admin')
			sleep 1
			expect(@ui.get(:text_field, {id: "profile_config_admin_name"}).value).to eq("")
			expect(email.value).not_to eq("updateemail@xirrus.com")
			sleep 0.5
			@ui.click('#profile_config_advanced')
			sleep 0.5

			@ui.click('#profile_config_tab_optimization')
			sleep 1
			client_togglebox = @ui.css('#optimize_client .opt_header a')
	        client_togglebox.wait_until_present
	        if(client_togglebox.attribute_value("class")=="expand_collapse")
	            client_togglebox.click
	        end
	        sleep 1

	        expect(@ui.get(:checkbox, {id: "optimization_fastroam_switch_switch"}).set?).to eq(true)


			@ui.click('#profile_config_tab_services')
			sleep 1
			expect(@ui.get(:checkbox, {css: "#profile_config_services_view .togglebox .switch .switch_checkbox"}).set?).to eq(false)
		end
		it "Go to the 'Access Points' tab on the profile and verify that the 'Add Access Points' button is not displayed" do
			@ui.click('#profile_tab_arrays')
			sleep 1
			if @ui.css('.confirm').exists? and @ui.css('#_jq_dlg_btn_0').visible?
				@ui.click('#_jq_dlg_btn_0')
			end
			sleep 2
			expect(@ui.css('#profile_array_add_btn')).not_to exist
			sleep 1
			@ui.click('#header_logo')
		end
	end
end

shared_examples "verify readonly function does not allow the user to perform changes in the application portals" do |portal_name|
	describe "Verify that the user priviledge of Read-Only will not permint any changes to be made within the application" do
		it "Go to the 'Access Points' landing page and verify a new portal cannot be created" do
			@ui.click('#header_nav_guestportals')
			sleep 0.5
			@ui.click('#header_nav_guestportals #view_all_nav_item')
			sleep 1
			@ui.click('#header_nav_guestportals')
			sleep 0.5
			expect(@ui.css('#header_guestportals_arrow .guestportals_nav .button_wrapper')).not_to exist
			@ui.click('#header_nav_guestportals')
			sleep 1
			expect(@ui.css('#new_guestportal_btn')).not_to exist
			expect(@ui.css('#new_guestportal_tile')).not_to exist
		end
		it "Open the portal named '#{portal_name}' and expect that the 'Tools' dropdown list and the 'Save All' button are not displayed" do
			get_portals_tile(portal_name).click
			sleep 1
			expect(@ui.css('#guestportal_config_save_btn')).not_to exist
			expect(@ui.css('#profile_menu_btn')).not_to exist
		end
		it "Change the 'Portal Name' and 'Portal Description'" do
			portal_name_input = @ui.get(:text_field, {id: "guestportal_config_basic_guestportalname"})
			portal_description_input = @ui.get(:textarea, {id: "guestportal_config_basic_description"})

			$portal_name_value = portal_name_input.value
			$portal_description_value = portal_description_input.value

			portal_name_input.set "NEW NAME"
			sleep 0.5
			portal_description_input.set "NEW DESCRIPTION TEXT"
		end
		it "Go to the 'Look & Feel' tab and change the Company Name then add the sign in option of Facebook" do
			@ui.click('#guestportal_config_tab_lookfeel')
			@ui.css("#guestportal_config_lookfeel_companyname").wait_until_present
			sleep 0.5
			@ui.set_input_val("#guestportal_config_lookfeel_companyname", "NEW COMPANY NAME")

			sleep 1
			@ui.click("#facebook + .mac_chk_label")
		end
		it "Go to the 'SSIDs' tab and verify that the button '+ Assign SSIDs' is not displayed" do
			@ui.click('#guestportal_config_tab_ssids')
			sleep 1

			expect(@ui.css('#ssid_addnew_btn')).not_to exist
		end
#		it "Go to the 'Guests' tab, verify that the '+New Guest' button isn't displayed then return to the 'Configurations' tabs and verify that none of the changes were saved" do
#			@ui.css('#profile_tabs a:nth-child(2)').click
#			sleep 0.5
#			expect(@ui.css('.dialogOverlay')).not_to exist
#			sleep 3
#			expect(@ui.css('#manageguests_addnew_btn')).not_to exist
#
#			sleep 0.5
#			@ui.css('#profile_tabs a:first-child').click
#			sleep 1
#
#			portal_name_input = @ui.get(:text_field, {id: "guestportal_config_basic_guestportalname"})
#			portal_description_input = @ui.get(:textarea, {id: "guestportal_config_basic_description"})
#
#			expect(portal_name_input.value).to eq($portal_name_value)
#			expect(portal_description_input.value).to eq($portal_description_value)
#
#			sleep 1
#			@ui.click('#guestportal_config_tab_lookfeel')
#			sleep 1
#
#			company_name_input = @ui.get(:text_field, {id: "guestportal_config_lookfeel_companyname"})
#
#			expect(company_name_input.value).to eq("")
#
#			expect(@ui.get(:checkbox, {id: "facebook"}).set?).to eq(false)
#		end
	end
end


shared_examples "verify readonly function does not allow the user to perform changes in the application reports" do
	describe "Verify that the user priviledge of Read-Only will not permint any changes to be made within the application" do
		it "Go to the 'Reports' landing page and verify a new report cannot be created" do
			@ui.click('#header_nav_reports')
			sleep 0.5
			@ui.click('#header_nav_reports #view_all_nav_item')
			sleep 1
			@ui.click('#header_nav_reports')
			sleep 0.5
			expect(@ui.css('#header_reports_arrow .reports_nav .button_wrapper')).not_to exist
			@ui.click('#header_nav_reports')
			sleep 1
			expect(@ui.css('#new_report_btn')).not_to exist
			expect(@ui.css('#new_report_tile')).not_to exist
		end
		it "Open the report named 'Application Visibility Report' and verify 'Tools' dropdown list has only the 'Edit Report' option" do
			get_reports_tile('Application Visibility Report').click
			sleep 4
			@ui.click('#report_menu_btn')
			sleep 1
			expect(@ui.css('.report-preview-header .drop_menu.active .drop_menu_nav.active #report_favorite')).not_to exist
			expect(@ui.css('.report-preview-header .drop_menu.active .drop_menu_nav.active #report_view')).not_to exist
			expect(@ui.css('.report-preview-header .drop_menu.active .drop_menu_nav.active #report_duplicate')).not_to exist
			expect(@ui.css('.report-preview-header .drop_menu.active .drop_menu_nav.active #report_delete')).not_to exist
		end
		it "Go to the 'Edit Report' area and verify that the 'Save' button isn't present and that the 'Tools' dropdown list has only the 'View Report' option" do
			@ui.css('.report-preview-header .drop_menu.active .drop_menu_nav.active #report_edit').click
			sleep 1
			expect(@ui.css('.report-config-header-buttons .report-config-save.button.orange')).not_to exist
		end
		it "Change the description text and add a new page" do
			description_textarea = @ui.get(:textarea, {id: "report-config-description"})

			$description_textarea_value = description_textarea.value

			description_textarea.set "NEW DESCRIPTION"
			sleep 0.5

			@browser.execute_script('$("#suggestion_box").hide()')

			pages_list = @ui.css('.xc-preview-panel-thumbs-list ul')
			$pages_list_length = pages_list.lis.length

			@ui.click('#report-add-page')
			sleep 1
		end
		it "navigate to the My Network area and return to the report to verify that the description text and the pages length isn't changed" do

			@ui.css('#header_logo').click
			sleep 0.5
			expect(@ui.css('.dialogOverlay')).not_to exist
			sleep 1

			@ui.click('#header_nav_reports')
			sleep 0.5
			@ui.click('#header_nav_reports #view_all_nav_item')
			sleep 1
			get_reports_tile('Application Visibility Report').click
			sleep 1
			@ui.click('#report_menu_btn')
			sleep 0.5
			@ui.css('.report-preview-header .drop_menu.active .drop_menu_nav.active #report_edit').click
			sleep 1

			description_textarea = @ui.get(:textarea, {id: "report-config-description"})

			expect(description_textarea.value).to eq($description_textarea_value)

			pages_list = @ui.css('.xc-preview-panel-thumbs-list ul')

			expect(pages_list.lis.length).to eq($pages_list_length)
		end
	end
end
