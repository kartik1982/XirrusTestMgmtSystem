require_relative "../../TS_Portal/local_lib/portal_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"

def click_the_refresh_grid_button(path, new_grid)
	stop = 1
	if @ui.css(path).exists? and @ui.css(path).attribute_value("class").include?('nssg-wrap isLoading')
		while @ui.css(path).attribute_value('class') == 'nssg-wrap isLoading'
			sleep 0.1
			puts "before rescue " + stop.to_s
			stop+=1
			if stop == 20
				break
			end
		end
	end
	refresh_button = @ui.css('.nssg-refresh')
	refresh_button.hover
	sleep 0.5
	stop = 1
	refresh_button.click
	if new_grid == nil
		if @ui.css(path).attribute_value('class') == 'nssg-wrap isLoading'
			#expect(@ui.css(path).attribute_value('class')).to eq('nssg-wrap isLoading')
			puts "found if"
			return 1
		else
			while @ui.css(path).attribute_value('class') != 'nssg-wrap isLoading'
				puts "after rescue " + stop.to_s
				sleep 0.1
				stop += 1
				if stop == 20
					return 0
				end
			end
		end
	else
		sleep 2
		expect(@ui.css(path)).to exist
		expect(@ui.css('.temperror')).not_to exist
		expect(@ui.css('.error')).not_to exist
		return 1
	end
end

def verify_page_contents(to_equal, is_visible)
	to_equal.each { |selector, value|
		expect(@ui.css(selector).text).to eq(value)
	}

	is_visible.each { |path|
		expect(@ui.css(path)).to be_visible
	}

	@ui.get_grid_length
end

def set_paging_view_per_grid(how_many_lines)
	if @ui.css('.nssg-table tbody').trs.length != 0
		current_view_mode = @ui.css('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button span:first-child').text
		unless current_view_mode == how_many_lines
			@ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
		  	@ui.ul_list_select_by_string('.ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul', how_many_lines)
		else
			puts "The view is already at '#{how_many_lines}' per page... skipping."
		end
	else
		puts "The grid is empty... skipping."
		log("The grid is empty... skipping.")
	end
end

def create_user_or_guest(portal_type)
	random_name = UTIL.random_fullname
	random_email = UTIL.random_email
	random_company = UTIL.departments
	random_note = UTIL.chars_255
	random_id = UTIL.ickey_shuffle(6)

	if portal_type == 'onboarding'
		@ui.click('#manageguests_addnew_btn')
		sleep 0.5
		expect(@ui.css('.ko_slideout_content')).to be_visible
		@ui.set_input_val('#manageguests_usermodal_name',random_name)
		sleep 0.5
		@ui.set_input_val('#manageguests_usermodal_id',random_id)
		sleep 0.5
		@ui.set_textarea_val('#manageguests_usermodal_note',random_note)
		sleep 0.8
		@ui.click('.ko_slideout_content .bottom_buttons .button.orange')
		sleep 1
	else
		@ui.click('#manageguests_addnew_btn')
		sleep 0.5
		expect(@ui.css('.ko_slideout_content')).to be_visible
		@ui.set_input_val('#guestmodal_name_input',random_name)
		sleep 0.5
		@ui.set_input_val('#guestmodal_email_input',random_email)
		sleep 0.5
		@ui.set_input_val('#guestambassador_guestmodal div:nth-child(6) input',random_company)
		sleep 0.5
		@ui.set_input_val('#guestambassador_guestmodal div:nth-child(7) input',random_note)
		sleep 0.8
		@ui.click('#guestdetails_save')
		sleep 1
		@ui.click('#guestambassador_guestpassword .content .more_options .button.orange.done')
		sleep 1
	end
end


shared_examples "my network - access points tab" do
	describe "AREA: My Network - Access Points tab - Grid general settings and Refresh button" do
		it "Navigate to the Access Points tab (My Network)" do
			@ui.click('#header_mynetwork_link')
			sleep 2
			@ui.click('#mynetwork_tab_arrays')
			sleep 0.5
			expect(@browser.url).to include('/#mynetwork/aps')
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			$eq = Hash[
				'#mynetwork_general_container .arrays_tab .commonTitle' => 'All Access Points',
				'#mynetwork_general_container .arrays_tab .commonSubtitle' => 'Manage your Access Points by editing them and assigning them to profiles.'
			]
			$is_visible = [
				'#mynetwork_arrays_grid_cp',
				'#arrays_grid .pull-right .xc-search',
				'#arrays_grid .push-down.clearfix .nssg-paging .nssg-paging-count',
				'#arrays_grid .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('#arrays_grid grid div:first-child', true)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify that all elements are still properly displayed" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "my network - alerts tab" do
	describe "AREA: My Network - Alerts tab - Grid general settings and Refresh button" do
		it "Navigate to the Alerts tab (My Network)" do
			@ui.click('#header_mynetwork_link')
			sleep 2
			@ui.click('#mynetwork_tab_alerts')
			sleep 0.5
			expect(@browser.url).to include('/#mynetwork/alerts')
		end
		it "Set the Filter to show 'All Alerts'" do
			@ui.set_dropdown_entry("mynetwork_alerts_state", "All Statuses")
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			$eq = Hash[
				'#mynetwork_alerts_tab .commonTitle span' => 'Alerts'
			]
			$is_visible = [
				'#mynetwork_alerts_tab .filter.greybox',
				'#mynetwork_alerts_tab .columnPickerIcon',
				'#mynetwork_alerts_tab .nssg-paging .nssg-paging-count',
				'#mynetwork_alerts_tab .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('#mynetwork_alerts_tab .nssg-table tbody', true)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify that all elements are still properly displayed" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "settings - user accounts tab" do
	describe "AREA: Settings - User Accounts tab - Grid general settings and Refresh button" do
		it "Navigate to the User Accounts tab (Settings)" do
			@ui.click('#header_nav_user')
			sleep 1
			@ui.click('#header_settings_link')
			sleep 2
			@ui.click('#settings_tab_useraccounts')
			sleep 0.5
			expect(@browser.url).to include('/#settings/useraccounts')
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
		$eq = Hash[
				'#settings_useraccounts .commonTitle' => 'User Accounts',
				'#settings_useraccounts .commonSubtitle' => 'User Accounts'
			]
			$is_visible = [
				'#user_grid',
				'#user_grid .push-down.clearfix .nssg-paging .nssg-paging-selector-container',
				'#user_grid .push-down.clearfix .nssg-paging .nssg-paging-count',
				'#user_grid .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('#user_grid grid div:first-child', nil)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify that all elements are still properly displayed" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "settings - provider management tab" do
	describe "AREA: Settings - Provider Management tab - Grid general settings and Refresh button" do
		it "Navigate to the Provider Management tab (Settings)" do
			@ui.click('#header_nav_user')
			sleep 1
			@ui.click('#header_settings_link')
			sleep 2
			@ui.click('#settings_tab_mobileproviders')
			sleep 0.5
			expect(@browser.url).to include('/#settings/mobileproviders')
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			$eq = Hash[
				'#mobileproviders_view .commonTitle' => 'Provider Management',
				'#mobileproviders_view .commonSubtitle' => 'Choose which providers will be accessable for each country code in Guest Access mobile settings
Please note: selected providers are responsible for delivering text messages. XMS cannot guarantee delivery by providers.'
			]
			$is_visible = [
				'#mobileproviders_grid',
				'#mobileproviders_grid .push-down.clearfix .nssg-paging .nssg-paging-selector-container',
				'#mobileproviders_grid .push-down.clearfix .nssg-paging .nssg-paging-selector-container',
				'#mobileproviders_grid .push-down.clearfix .nssg-paging .nssg-paging-count',
				'#mobileproviders_grid .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('#mobileproviders_grid grid div:first-child', nil)
				sleep 0.9
			end
			expect(@found_times).to be >= 2
		end
		it "Verify that all elements are still properly displayed" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "commandcenter - domains tab" do
	describe "AREA: CommandCenter - Domains tab - Grid general settings and Refresh button" do
		it "Navigate to the Domains tab (CommandCenter Admin)" do
			@ui.click('#header_nav_user')
			sleep 1
			@ui.click('#header_msp_link')
			sleep 1.5
			expect(@browser.url).to include('/#msp/dashboard')
			sleep 1
			@ui.click('#msp_tab_accounts')
			sleep 1
			expect(@browser.url).to include('/#msp/accounts')
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			domain_count = @ui.css('.tab-item-container .commonTitle span').text
			$eq = Hash[
				'.tab-item-container .commonTitle span' => "#{domain_count}"
			]
			$is_visible = [
				'.nssg-container',
				'.tab-item-container .nssg-paging-selector-container',
				'.tab-item-container .nssg-paging-count',
				'.tab-item-container .nssg-paging-controls',
				'.tab-item-container .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('.tab-item-container grid div:first-child', nil)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify that all elements are still properly displayed" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "commandcenter - users tab" do
	describe "AREA: CommandCenter - Users tab - Grid general settings and Refresh button" do
		it "Navigate to the Users tab (CommandCenter Admin)" do
			@ui.click('#header_nav_user')
			sleep 1
			@ui.click('#header_msp_link')
			sleep 1
			@ui.click('#msp_tab_users')
			sleep 0.5
			expect(@browser.url).to include('/#msp/users')
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			user_count = @ui.css('.tab-item-container .commonTitle span').text
			$eq = Hash[
				'.tab-item-container .commonTitle span' => "#{user_count}"
			]
			$is_visible = [
				'.tab-item-container .filter.greybox',
				'.nssg-container',
				'.tab-item-container .nssg-paging-selector-container',
				'.tab-item-container .nssg-paging-count',
				'.tab-item-container .nssg-paging-controls',
				'.tab-item-container .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('.tab-item-container grid div:first-child', nil)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify that all elements are still properly displayed" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "commandcenter - access points tab" do
	describe "AREA: CommandCenter - Access Points tab - Grid general settings and Refresh button" do
		it "Navigate to the Access Points tab (CommandCenter Admin)" do
			@ui.click('#header_nav_user')
			sleep 1
			@ui.click('#header_msp_link')
			sleep 1
			@ui.click('#msp_tab_arrays')
			sleep 0.5
			expect(@browser.url).to include('/#msp/arrays')
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			array_count = @ui.css('.tab-item-container .commonTitle span').text
			$eq = nil
			$eq = Hash[
				'.tab-item-container .commonTitle span' => "#{array_count}"
			]
			$is_visible = [
				'.nssg-container',
				'.tab-item-container .nssg-paging-selector-container',
				'.tab-item-container .nssg-paging-count',
				'.tab-item-container .nssg-paging-controls',
				'.tab-item-container .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('.tab-item-container .nssg-table tbody tr', true)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify that all elements are still properly displayed" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "backoffice - access points tab" do
	describe "AREA: BackOffice - Access Points tab - Grid general settings and Refresh button" do
		it "Navigate to the Access Points tab (BackOffice)" do
			@ui.click('#header_nav_user')
			sleep 1
			@ui.click('#header_backoffice_link')
			sleep 1
			@ui.click('#backoffice_tab_arrays')
			sleep 0.5
			expect(@browser.url).to include('/#backoffice/arrays')
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			$eq = Hash[
				'#backoffice_arrays .commonTitle span:nth-child(2)' => "Access Points",
				'#backoffice_arrays .commonSubtitle' => "Delete and re-assign Access Points"
			]
			$is_visible = [
				'#backoffice_arrays',
				'#backoffice_arrays .xc-search',
				'#backoffice_arrays .nssg-paging-selector-container',
				'#backoffice_arrays .nssg-paging-count',
				'#backoffice_arrays .nssg-paging-controls',
				'#backoffice_arrays .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 2
			(1..5).each do
				@found_times += click_the_refresh_grid_button('#backoffice_arrays .nssg-tobdy', true)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify that all elements are still properly displayed" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "backoffice - customers tab" do
	describe "AREA: BackOffice - Customers tab - Grid general settings and Refresh button" do
		it "Navigate to the Customers tab (BackOffice)" do
			@ui.click('#header_nav_user')
			sleep 1.5
			@ui.click('#header_backoffice_link')
			sleep 1.5
			@ui.click('#backoffice_tab_customers')
			sleep 1.5
			@ui.css('.xc-search').wait_until_present
			expect(@browser.url).to include('/#backoffice/customers')
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			$eq = Hash[
				'#backoffice-customers .commonTitle' => "Customers",
				'#backoffice-customers .commonSubtitle' => "Edit customers"
			]
			$is_visible = [
				'.nssg-container .nssg-table',
				'#backoffice-customers .xc-search',
				'#backoffice-customers .nssg-paging-selector-container',
				'#backoffice-customers .nssg-paging-count',
				'#backoffice-customers .nssg-paging-controls',
				'#backoffice-customers .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('#backoffice-customers grid div:first-child', nil)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify that all elements are still properly displayed" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "backoffice - customers tab - browsing tenant view - access points tab" do |tenant_name|
	describe "AREA: BackOffice - Customers tab - Browsing a Tenant (view) - Access Points tab - Grid general settings and Refresh button" do
		it "Navigate to the Customers tab - Browsing a Tenant (view) - Access Points tab (BackOffice)" do
			@ui.click('#header_nav_user')
			sleep 1
			@ui.click('#header_backoffice_link')
			sleep 1
			@ui.click('#backoffice_tab_customers')
			sleep 0.5
			expect(@browser.url).to include('/#backoffice/customers')
		end
		it "Press the #{tenant_name} hyperlink" do
			@ui.set_input_val(".xc-search input", tenant_name)
			sleep 3
			@ui.grid_click_on_specific_line("3", tenant_name, "a")
			sleep 2
			expect(@browser.url).to include('/#backoffice/customers/')
			expect(@browser.url).to include('/arrays')
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			$eq = Hash[
				'#backoffice_arrays .commonTitle span:nth-child(2)' => "Access Points"
			]
			$is_visible = [
				'.nssg-container .nssg-table',
				'#backoffice_arrays .xc-search',
				'#backoffice_arrays .nssg-paging-selector-container',
				'#backoffice_arrays .nssg-paging-count',
				'#backoffice_arrays .nssg-paging-controls',
				'#backoffice_arrays .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('#backoffice_arrays grid div:first-child', nil)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify proper page is displayed with all elements present" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "backoffice - customers tab - browsing tenant view - user accounts tab" do |tenant_name|
	describe "AREA: BackOffice - Customers tab - Browsing a Tenant (view) - User Accounts tab - Grid general settings and Refresh button" do
		it "Navigate to the Customers tab - Browsing a Tenant (view) - User Accounts tab (BackOffice)" do
			@ui.click('#header_nav_user')
			sleep 1
			@ui.click('#header_backoffice_link')
			sleep 1
			@ui.click('#backoffice_tab_customers')
			sleep 0.5
			expect(@browser.url).to include('/#backoffice/customers')
		end
		it "Press the #{tenant_name} hyperlink" do
			@ui.set_input_val(".xc-search input", tenant_name)
			sleep 3
			@ui.grid_click_on_specific_line("3", tenant_name, "a")
			sleep 2
			@ui.click('#customerDash_tab_users')
			expect(@browser.url).to include('/#backoffice/customers/')
			expect(@browser.url).to include('/users')
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			$eq = Hash[
				'#backoffice_customers_useraccounts .commonTitle' => "User Accounts",
				'#backoffice_customers_useraccounts .commonSubtitle' => "User Accounts"
			]
			$is_visible = [
				'#user_grid .nssg-paging-selector-container',
				'#user_grid .nssg-paging-count',
				'#user_grid .nssg-paging-controls',
				'#user_grid .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('#user_grid grid div:first-child', nil)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify proper page is displayed with all elements present" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end

shared_examples "profile - access points tab" do |profile_name, access_point_name|
	describe "AREA: #{profile_name} Profile - Access Points tab - Grid general settings and Refresh button" do
		it "Go to the profile named #{profile_name} - Access Points tab" do
			@ui.goto_profile(profile_name)
			@ui.click('#profile_tab_arrays')
			sleep 0.5
			expect(@browser.url).to include('/#profiles')
			expect(@browser.url).to include('/aps')
		end
		it "Add Access Points to the profile" do
			@ui.click('#profile_array_add_btn')
			sleep 0.5
			list = @ui.css('#add_arrays .lhs .select_list .ko_container.ui-sortable')
  			list.wait_until_present
   			list_length = list.lis.length
   			@ui.css(".lhs ul li:nth-child(#{list_length})").click
  			@ui.click('#arrays_add_modal_move_btn')
  			sleep 1
  			@ui.click('#add_arrays .rhs .select_list ul li:first-child')
   			sleep 1
   			@ui.click('#arrays_add_modal_addarrays_btn')
   			sleep 1
   			if @ui.css('#array_add_modal_closemodalbtn').exists?
   				if @ui.css('#array_add_modal_closemodalbtn').visible?
   					@ui.css('#array_add_modal_closemodalbtn').click
   				end
   			end
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			$eq = Hash[
				'#profile_arrays .commonTitle' => 'All Access Points',
				'#profile_arrays .commonSubtitle' => 'Manage your Access Points by editing them and assigning them to profiles.'
			]
			$is_visible = [
				'#profile_arrays_grid_cp',
				'#arrays_grid .pull-right .xc-search',
				'#arrays_grid .nssg-paging .nssg-paging-count',
				'#arrays_grid .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('#arrays_grid grid div:first-child', true)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify proper page is displayed with all elements present" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
	end
end
shared_examples "create 8 ssids" do |profile_name|
	describe "Create 8 SSIDs on the profile named #{profile_name}" do
		it "Go to the profile named #{profile_name}, on the SSIDs tab" do
            @ui.click('#header_mynetwork_link')
            sleep 2
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "Create 8 SSIDs" do
            ssid_no = 0
            while (ssid_no < 8) do
                @ui.click('#profile_ssid_addnew_btn')
                sleep 0.5
                ssid_string = ssid_no.to_s
                @ui.set_input_val('#profile_ssids_grid_ssidName_inline_edit_'+ ssid_string, "SSID no. " + ssid_string)
                sleep 0.5
                @ui.css('#profile_config_ssids_view .commonTitle').click
                ssid_no+=1
            end
        end
        it "Verify that the grid length is '8' rows" do
            @ui.get_ssids_grid_length
            expect($grid_length).to eq(8)
            sleep 0.6
            # @ui.click('#profile_config_save_btn')
            press_profile_save_config_no_schedule
        end
    end
end
shared_examples "access services - ssids tab" do |portal_name, portal_type|
	describe "AREA: '#{portal_name.upcase}' Access Service - SSIDs tab - Grid general settings and Refresh button" do
		it "Go to the Access Service named #{portal_name}" do
        	navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
        	#@ui.goto_portal(portal_name)
        	sleep 1
        	@ui.click('#guestportal_config_tab_ssids')
        end
		it "Add SSIDs to the Access Service" do
			@ui.click('#ssid_addnew_btn')
			sleep 0.5
			list = @ui.css('#add_ssids .lhs .select_list .ko_container.ui-sortable')
  			list.wait_until_present
   			list_length = list.lis.length

   	        while (list_length != 0) do
  		        if (@ui.css(".lhs ul li:nth-child(#{list_length})").text.include?("SSID no. "))
   		            sleep 1
  		            @ui.css(".lhs ul li:nth-child(#{list_length})").click
   		            sleep 1
   		            @ui.click('#ssids_add_modal_move_btn')
  		            if portal_type == "personal"
  		            	break
  		            end
  		        end
  		        list_length-=1
  		    end
  			sleep 1
  			@ui.click('#add_ssids .rhs .select_list ul li:first-child')
   			sleep 1
   			@ui.click('#ssids_add_modal_addssids_btn')
   			if portal_type == "onboarding"
   				@ui.click('#_jq_dlg_btn_1')
   			end
		end
		it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			case portal_type
				when "onboarding"
					innertab_title_string = "EasyPass Onboarding"
					innertab_subtitle_string = "BYOD users sign up to see the wireless network and register their devices."
				when "self_reg"
					innertab_title_string = "Self-Registration"
					innertab_subtitle_string = "Guests sign up to use the guest portal with an online form."
				when "google"
					innertab_title_string = "EasyPass Google"
					innertab_subtitle_string = "Users will log in using their google mail credentials."
				when "ambassador"
					innertab_title_string = "Guest Ambassador"
					innertab_subtitle_string = "Guest Ambassadors will register the guests."
				when "onetouch"
					innertab_title_string = "One-Click Access"
					innertab_subtitle_string = "Guests have open access but must agree to terms of use."
				when "personal"
					innertab_title_string = "EasyPass Personal Wi-Fi"
					innertab_subtitle_string = "Users will log in to create their own secure personal network."
				when "voucher"
					innertab_title_string = "EasyPass Voucher"
					innertab_subtitle_string = "Users will log in with a generated short term access code."
			end
			$eq = Hash[
				'#guestportal_config_ssids_view .commonTitle span' => 'SSIDs',
				'#guestportal_config_ssids_view .commonSubtitle' => 'Assign existing SSIDs to this guest portal from your Access Point profiles.',
				'#guestportal_config_ssids_view .innertab .title' => innertab_title_string,
				'#guestportal_config_ssids_view .innertab .subtitle' => innertab_subtitle_string
			]
			$is_visible = [
				'#guestportal_config_ssids_view .innertab .push-down.clearfix .nssg-paging .nssg-paging-selector-container',
				'#guestportal_config_ssids_view .innertab .push-down.clearfix .nssg-paging .nssg-paging-count',
				'#guestportal_config_ssids_view .innertab .nssg-refresh'
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('#guestportal_config_ssids_view .innertab grid div:first-child', nil)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify proper page is displayed with all elements present" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
			sleep 1
		end
		it "Press the 'Undo all' changes link " do
			@ui.click('#guestportal_undo_changes_btn')
		end
	end
end
shared_examples "access services verify refresh exists" do |portal_name, portal_type|
	describe "AREA: #{portal_name.upcase} Access Service - Second tab - Grid general features" do
		it "Go to the Access service named #{portal_name}" do
			navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
		end
		it "Go to the second tab" do
			@ui.css('#profile_tabs a:nth-child(2)').click
        	sleep 2
        	expect(@browser.url).to include('/#guestportals/')
		end
		it "Verify that the Refresh button exists" do
			expect(@ui.css('.nssg-refresh')).to be_present
		end
	end
end
shared_examples "access services guests/users/vouchers tab" do |portal_name, portal_type|
	describe "AREA: '#{portal_name.upcase}' Access Service - Guests/Users/Vouchers tab - Grid general settings and Refresh button" do
		it "Go to the Access Service named #{portal_name}" do
        	navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
        end
        it "Go to the 'Guests/Users/Vouchers' tab" do
        	if ['google','onetouch','personal'].include?(portal_type)
        		puts "The grid for the active users on the Access Service of type '#{portal_type}' is managed dynamically ... skipping !"
        	else
        		expect(@ui.css('#profile_tabs')).to be_visible
        		@ui.css('#profile_tabs a:nth-child(2)').click
        		sleep 2
        		expect(@browser.url).to include('/#guestportals/')
        		if portal_type == 'self_reg' or portal_type == 'ambassador'
        			expect(@browser.url).to include('/guests')
        		elsif portal_type == 'onboarding'
        			expect(@browser.url).to include('/users')
        		elsif portal_type == 'voucher'
        			expect(@browser.url).to include('/vouchers')
        		end
        	end
        end
        it "Add 5 new lines in the grid for 'Ambassador', 'Self Registration' and 'Onboarding' /// add 1000 new vouchers" do
        	@browser.execute_script('$("#suggestion_box").hide()')
          sleep 1
        	if portal_type == 'voucher'
        		@ui.click('#managevouchers_addnew_btn')
        		sleep 0.5
        		expect(@ui.css('#manageguests_vouchermodal')).to be_visible
        		@ui.set_input_val('#voucher_count','1000')
        		sleep 0.5
        		@ui.click('#manageguests_vouchermodal .buttons .button.orange')
        		sleep 4
        	else
        		(0..4).each do
        			create_user_or_guest(portal_type)
        		end
        	end
        end
        it "Set the paging display entries to '10'" do
			set_paging_view_per_grid("10")
		end
		it "Verify proper page is displayed with all elements present" do
			$is_visible = [
				'.manageguests_grid_container .push-down.clearfix .nssg-paging .nssg-paging-selector-container',
				'.manageguests_grid_container .push-down.clearfix .nssg-paging .nssg-paging-count',
				'.manageguests_grid_container .push-down.clearfix .nssg-paging .nssg-paging-controls',
				'.manageguests_grid_container .nssg-refresh'
			]
			case portal_type
				when "onboarding"
					subtitle_string = "Manage accounts for users accessing your BYOD wireless network."
				when "self_reg"
					subtitle_string = "Manage accounts for guests accessing your guest wireless network."
					$is_visible.push('.manageguests_grid_container #guestportal_guests_grid_cp')
					$is_visible.push('.manageguests_grid_container .push-down.clearfix .xc-search')
				when "ambassador"
					subtitle_string = "Manage accounts for guests accessing your guest wireless network."
					$is_visible.push('.manageguests_grid_container #guestportal_guests_grid_cp')
					$is_visible.push('.manageguests_grid_container .push-down.clearfix .xc-search')
				when "voucher"
					subtitle_string = 'Manage vouchers for users accessing your wireless network.'
			end
			$eq = Hash[
				'#guestportal_container .manageguests .top .commonTitle span' => 'EasyPass Portal',
				'#guestportal_container .manageguests .top .commonSubtitle' => subtitle_string
			]
			verify_page_contents($eq, $is_visible)
			$grid_length_refresh = $grid_length
		end
		it "Press the 'Refresh' button 5 times and verify that the grid has the class '.isLoading'" do
			@found_times = 0
			(1..5).each do
				@found_times += click_the_refresh_grid_button('.manageguests_grid_container grid div:first-child', nil)
				sleep 0.4
			end
			expect(@found_times).to be >= 2
		end
		it "Verify proper page is displayed with all elements present" do
			verify_page_contents($eq, $is_visible)
			expect($grid_length_refresh).to eq($grid_length)
		end
    end
end

shared_examples "delete profile" do |profile_name|
	describe "Delete the profile named #{profile_name}" do
		it "Go to the profile named #{profile_name} " do
			@ui.goto_profile(profile_name)
		end
		it "Open the 'Profile Menu Dropdown List' and select the 'Delete Profile' option" do
			@ui.click('#profile_menu_btn')
			sleep 0.7
			#@ui.click('#profile_delete_btn')
			@browser.a(:text => 'Delete Profile').click
		end
		it "Confirm the deletion prompt" do
			@ui.click('#_jq_dlg_btn_1')
			sleep 2
			expect(@browser.url).to include('/#profiles')
		end
	end
end
shared_examples "delete portal" do | portal_name|
	describe "Delete the Access Service named #{portal_name}" do
		it "Go to the portal named #{portal_name} " do
			navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,false)
		end
		it "Open the 'Portal Menu Dropdown List' and select the 'Delete Portal' option" do
			@ui.click('#profile_menu_btn')
			sleep 0.7
			@ui.click('#guestportal_delete_btn')
		end
		it "Confirm the deletion prompt" do
			@ui.click('#_jq_dlg_btn_1')
			sleep 2
			expect(@browser.url).to include('/#guestportals')
		end
	end
end

				#expect(@ui.css('#guestportal_guests_grid div').attribute_value('class')).to eq('.nssg-wrap.isLoading')
