require_relative "../../TS_Settings/local_lib/settings_lib.rb"

shared_examples "go to support tools" do
	describe "Open the user dropdown list and press the 'Support Tools' button" do
		it "Open the user dropdownlist" do
			@ui.click('#header_nav_user .user-icon')
			sleep 0.5
			expect(@ui.css('#header_nav_user .profile_nav')).to be_visible
			expect(@ui.css('#header_nav_user .profile_nav').attribute_value("class")).to include("active")
		end
		it "Press the 'Support Tools' button" do
			expect(@ui.css('#header_cnp_link')).to be_present
			@ui.click('#header_cnp_link')
		end
		it "Verify that the location is 'Support Tools'" do
			@ui.css('.globalTitle span:nth-child(1)').wait_until_present
			expect(@browser.url).to include("/#cnp/customers")
			expect(@ui.css('.globalTitle span:nth-child(1)').text).to eq("Support Tools")
		end
	end
end

shared_examples "customers general features" do
	describe "Verify the general features on the Customers tab" do
		it "Verify Customers tab features" do
			expect(@ui.css('.bo_tab .commonTitle').text).to eq("Customers")
			expect(@ui.css('.xc-search')).to be_visible
			expect(@ui.css('.xc-search .btn-search')).to be_visible
			expect(@ui.css('.nssg-table')).not_to exist
		end
	end
end


shared_examples "search for customer" do |customer_name, number_of_results, search_for_name|
	describe "Search for the customer named '#{customer_name}' and verify that the grid shows '#{number_of_results}' results" do
		it "Set the '#{customer_name}' value in the search input box" do
			@ui.set_input_val(".xc-search input", customer_name)
		end
		it "Wait 3 seconds and verify that the grid is displayed and the bubble count" do
			sleep 3
			expect(@ui.css('.nssg-table')).to be_present
			expect(@ui.css('.xc-search .bubble .count').text).to be >= number_of_results
		end
		it "Verify that the grid shows the proper amount of results and the needed tenant" do
			trs = @ui.css('.nssg-table .nssg-tbody').trs.length
			if number_of_results.to_i > 100
				expect(trs).to eq(100)
			else
				expect(trs).to eq(number_of_results.to_i)
			end
			if number_of_results == "0"
				expect(@ui.css('.noresults')).to be_present
				expect(@ui.css('.noresults').text).to eq("No results found")
			else
				if search_for_name == true
					if number_of_results.to_i > 1
						while trs > 0
							if @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{trs}) .name a").text == customer_name
								break
							end
							trs-=1
							if trs == 0
								expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{trs}) .name a").text).to eq(customer_name)
							end
						end
					else
						expect(@ui.css('.nssg-table .nssg-tbody tr:first-child .name a').text).to eq(customer_name)
					end
				end
			end
		end
	end
end

shared_examples "go to tab" do |tab_name|
	describe "Go to the tab named '#{tab_name}'" do
		it "Press the button for the tab '#{tab_name}' and verify that the user is properly taken to that tab" do
		case tab_name
			when "Customers"
				required_number = 1
				url_end = "customers"
			when "Access Points"
				required_number = 2
				url_end = "arrays"
			when "Support Users"
				required_number = 3
				url_end = "users"
			when "Orders"
				required_number = 4
				url_end = "orders"
		end
			@ui.click(".right-tab-menu a:nth-child(#{required_number})")
			sleep 3
			expect(@browser.url).to include("cnp/#{url_end}")
		end
	end
end

shared_examples "search for ap" do |ap_sn, empty_search, tenant_id, online, status, expiration_date|
	describe "Search for the AP named '#{ap_sn}' and verify that the grid shows the proper result" do
		it "Set the '#{ap_sn}' value in the search input box and press the 'Search' button" do
			@ui.set_input_val(".xc-search input", ap_sn)
			sleep 1
			@ui.click('.xc-search .btn-search')
			sleep 1
		end
		it "Verify that the grid is displayed and the bubble count" do
			expect(@ui.css('.nssg-table')).to be_present
			if empty_search == true
				expect(@ui.css('.xc-search .bubble .count').text).to eq("0")
			else
				expect(@ui.css('.xc-search .bubble .count').text).to eq("1")
			end
		end
		it "Verify that the grid shows the proper amount of results and the needed tenant ('#{ap_sn}', '#{tenant_id}', '#{online}', '#{status}' and '#{expiration_date}')" do
			if empty_search == true
				expect(@ui.css('.nssg-table .nssg-tbody').trs.length).to eq(0)
				expect(@ui.css('.noresults')).to be_present
				expect(@ui.css('.noresults').text).to eq("No results found")
			else
				expect(@ui.css('.nssg-table .nssg-tbody').trs.length).to eq(1)
				expect(@ui.css('.nssg-table .nssg-tbody tr:first-child .serialNumber .nssg-td-text').text).to eq(ap_sn)
				expect(@ui.css('.nssg-table .nssg-tbody tr:first-child .tenantId .nssg-td-text').text).to eq(tenant_id)
				expect(@ui.css('.nssg-table .nssg-tbody tr:first-child .onlineStatus .nssg-td-text span:nth-child(2)').text).to eq(online)
				expect(@ui.css('.nssg-table .nssg-tbody tr:first-child .activationStatus .nssg-td-text span:nth-child(2)').text).to eq(status)
				expect(@ui.css('.nssg-table .nssg-tbody tr:first-child .expirationDate .nssg-td-text').text).to eq(expiration_date)
			end
		end
	end
end

shared_examples "cancel search" do
	describe "Cancel the search" do
		it "Press the 'x' button and verify the bubble and grid are not displayed" do
			@ui.click('.xc-search .btn-clear')
			sleep 2
			expect(@ui.css('.nssg-table')).not_to be_present
			expect(@ui.css('.xc-search .bubble .count')).not_to be_visible
		end
	end
end

shared_examples "create user" do |first_name, last_name, email|
	describe "Create a new user for Support Tools: '#{email}'" do
		it "Set the view per page to 1000" do
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000")
		end
		it "Press the '+New User' button" do
			@ui.click('#cnp-users-new')
			sleep 2
			expect(@ui.css('.tabpanel_slideout').attribute_value("class")).to include("opened")
		end
		it "Set the first, last name and email values" do
			@ui.set_input_val('#usermodal_firstname',first_name)
			sleep 1
			@ui.set_input_val('#usermodal_lastname',last_name)
			sleep 1
			@ui.set_input_val('#usermodal_email',email)
		end
		it "Press the <SAVE> button and verify that the user is properly entered in the grid" do
			@ui.click('#user-slideout-save')
			sleep 2
			@ui.click(".nssg-refresh")
			sleep 3
			user_accounts_grid_actions("verify strings support tools", email, first_name, last_name, "", "")
		end
		it "Set the view per page to 10" do
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "10")
		end
	end
end

shared_examples "edit user" do |email, email_new, first_name, first_name_new, last_name, last_name_new|
	describe "Edit the user with the email '#{email}'" do
		it "Set the view per page to 1000 and find the user in the grid and open the slideout window" do
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000")
			sleep 1
			user_accounts_grid_actions("invoke support tools", email, "", "", "", "")
			sleep 2
			expect(@ui.css('.tabpanel_slideout').attribute_value("class")).to include("opened")
		end
		it "Change the first, last name and email values" do
			if first_name_new != ""
				@ui.set_input_val('#usermodal_firstname',first_name_new)
			end
			sleep 1
			if last_name_new != ""
				@ui.set_input_val('#usermodal_lastname',last_name_new)
			end
			sleep 1
			if email_new != ""
				@ui.set_input_val('#usermodal_email',email_new)
			end
		end
		it "Press the <SAVE> button and verify that the user is properly entered in the grid" do
			@ui.click('#user-slideout-save')
			sleep 2
			@ui.click(".nssg-refresh")
			sleep 3
			if email_new != ""
				user_accounts_grid_actions("verify strings support tools", email, first_name, last_name, "", "")
			else
				user_accounts_grid_actions("verify strings support tools", email_new, first_name, last_name, "", "")
			end
			sleep 1
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "10")
		end
	end
end

 shared_examples "delete user" do |email|
 	describe "Delete the user with the email '#{email}'" do
 		it "Set the view per page to 1000 and find the user in the grid and place a tick" do
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000")
			sleep 1
			user_accounts_grid_actions("check support tools", email, "", "", "", "")
			sleep 2
			expect(@ui.css('#cnp-users-delete-btn')).to be_present
		end
		it "Click the 'Delete' button and accept the confirmation prompt" do
			@ui.click('#cnp-users-delete-btn')
			sleep 0.5
			@ui.css('.dialogOverlay.confirm').wait_until_present
			sleep 0.5
			@ui.click('#_jq_dlg_btn_1')
			sleep 2
		end
		it "Refresh the grid and search for the user to verify it is not displayed anymore" do
			@ui.click(".nssg-refresh")
			sleep 2
			user_found = user_accounts_grid_actions("verify strings support tools", email, "", "", "", "")
			expect(user_found).to eq(false)
			sleep 0.5
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "10")
		end
 	end
 end

 shared_examples "users cleanup" do |email_string|
 	describe "Clean-up the Support Tools - Users area" do
 		it "Set the view per page to 1000 and find the total number of users in the grid that have the email value including '#{email_string}', and then delete them one by one" do
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000")
			sleep 1
			grid_positions = Array.new
			grid_length = @ui.css('.nssg-table .nssg-tbody').trs.length
			while grid_length > 0
				if @ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(3) div").text.include?(email_string)
					grid_positions.push grid_length
				end
				grid_length-=1
			end
			if grid_positions.length != 0
				grid_positions.each do |grid_position|
					@ui.click(".nssg-table tbody tr:nth-child(#{grid_position}) td:nth-child(2) .mac_chk_label")
					sleep 1
					expect(@ui.css('#cnp-users-delete-btn')).to be_present
					@ui.click('#cnp-users-delete-btn')
					sleep 0.5
					@ui.css('.dialogOverlay.confirm').wait_until_present
					sleep 0.5
					@ui.click('#_jq_dlg_btn_1')
					sleep 1
					if grid_position != 1
						@ui.css(".nssg-table tbody tr:nth-child(#{grid_position-1}) td:nth-child(2) .mac_chk_label").wait_until_present
					end
				end
			end
		end
		it "Refresh the grid and search for the email value including '#{email_string}' and verify no entries exist" do
			@ui.click(".nssg-refresh")
			sleep 2
			grid_positions = Array.new
			grid_length = @ui.css('.nssg-table .nssg-tbody').trs.length
			while grid_length > 0
				if @ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(3) div").text.include?(email_string)
					grid_positions.push grid_length
				end
				grid_length-=1
			end
			expect(grid_positions.length).to eq(0)
			sleep 0.5
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "10")
		end
 	end
 end

 shared_examples "verify orders grid" do
 	describe "Verify the Orders grid features" do
 		it "Verify grid general features (grid controls, header names, sorting posibility)" do
 			strings = [".nssg-paging-selector-container", ".nssg-paging-count", ".nssg-paging-controls", ".nssg-refresh"]
 			strings.each do |string|
 				expect(@ui.css(string)).to be_present
 			end
 			expect(@ui.css('#cnp-orders .commonTitle').text).to eq("Orders")
 			table_headers = Hash[1 => "Transaction ID", 2 => "Date", 3 => "Uploaded by", 4 => "Tenant Name", 5 => "Tenant ERP", 6 => "Technical Contact", 7 => "SKU", 8 => "Quantity"]
			(1..8).each do |i|
 				expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i}) .nssg-th-text").text).to eq(table_headers[i])
 			end
 			(2..5).each do |i|
 				expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i})").attribute_value("class")).to include("nssg-sortable")
 			end
 		end
 		it "Verify the grid view per page feature" do
 			abc = @ui.css('.nssg-paging-count').text
  			i = abc.index('of')
  			length = abc.length
  			number = abc[i + 3, abc.length]
  			number2 = number.to_i
 			["10", "50", "100", "250", "500", "1000"].each do |view|
 				@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", view)
 				sleep 4
 				if view == "1000" and number2 > 500 and number2 != 1000
 					expect(@ui.css('.nssg-table .nssg-tbody').trs.length).to be > 500
 				else
 					expect(@ui.css('.nssg-table .nssg-tbody').trs.length.to_s).to eq(view)
 				end
 			end
 		end
 	end
 end

 shared_examples "browse to tenant" do |tenant_name, brand|
 	describe "Drill into the 'Browsing Tenant' view for '#{tenant_name}'" do
 		it "Press the '#{tenant_name}' hyperlink" do
			@ui.grid_click_on_specific_line("2", tenant_name, "a")
			sleep 2
		end
		it "Ensure that the application is on the #{tenant_name} customer's dashboard" do
			expect(@ui.css('.globalTitle')).to exist
			expect(@ui.css('.globalTitle')).to be_visible
			expect(@ui.css('.globalTitle').text).to eq("Support Tools")
			expect(@browser.url).to include('#cnp/customers')
			expect(@browser.url).to include('/arrays')
		end
		it "Expect that the Browsing Tenant: value is #{tenant_name}" do
			expect(@ui.css('#main_container div div:nth-child(2) span:nth-child(2)').text).to eq(tenant_name)
		end
		it "Expect that the view contains two tabs: Access Points and User Accounts" do
			expect(@ui.css('.right-tab-menu a:first-child')).to exist
			expect(@ui.css('.right-tab-menu a:first-child')).to be_visible
			expect(@ui.css('.right-tab-menu a:first-child').text).to eq("Access Points")
			expect(@ui.css('.right-tab-menu a:nth-child(2)')).to exist
			expect(@ui.css('.right-tab-menu a:nth-child(2)')).to be_visible
			expect(@ui.css('.right-tab-menu a:nth-child(2)').text).to eq("User Accounts")
		end
		it "Verify that the tenant has the brand '#{brand}'" do
			expect(@ui.css('#main_container div div:nth-child(3) span:nth-child(2)').text).to eq(brand)
		end
		it "Verify that the navigation links are present" do
			expect(@ui.css('#main_container div a:nth-child(6)').text).to eq("Go back")
			expect(@ui.css('#main_container div a:nth-child(8)').text).to eq("Scope to Customer")
		end
		it "Verify the Access Points grid features" do
			table_headers = Hash[3 => "Serial Number", 4 => "Online", 5 => "Status", 6 => "Expiration Date"]
			(3..6).each do |i|
 				expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i}) .nssg-th-text").text).to eq(table_headers[i])
 				expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i})").attribute_value("class")).to include("nssg-sortable")
 			end
		end
		it "Go to the User Accounts tab and verify the grid features" do
			@ui.click('.right-tab-menu a:nth-child(2)')
			sleep 1
			expect(@browser.url).to include('#cnp/customers')
			expect(@browser.url).to include('/users')
			table_headers = Hash[3 => "Email", 4 => "First Name", 5 => "Last Name", 6 => "Description", 7 => "Privileges"]
			(3..7).each do |i|
 				expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i}) .nssg-th-text").text).to eq(table_headers[i])
 				if i < 6
 					expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i})").attribute_value("class")).to include("nssg-sortable")
 				end
 			end
		end
	end
end

shared_examples "browsing to tenant add user" do |tenant_name, first_name, last_name, email, additional_details, role|
	describe "Add the user '#{email}' while browsing to the tenant '#{tenant_name}'" do
		it "Ensure you are on the Users tab" do
			@ui.click('.right-tab-menu a:nth-child(2)')
			sleep 1
			expect(@browser.url).to include('#cnp/customers')
			expect(@browser.url).to include('/users')
		end
		it "Add the user with the following values: first_name = '#{first_name}' /// last_name = '#{last_name}' /// email = '#{email}' /// ROLE = '#{role}'" do
	        @browser.execute_script('$("#suggestion_box").hide()')
			sleep 1
	        @ui.click('#cnp-users-new')
	        sleep 1
	        @ui.set_input_val('#usermodal_firstname',first_name)
	        sleep 0.5
	        @ui.set_input_val('#usermodal_lastname',last_name)
	        sleep 0.5
	        @ui.set_input_val('#usermodal_email',email)
	        sleep 0.5
	        @ui.set_input_val('#usermodal_details', additional_details)
	        sleep 0.5
		    @ui.set_dropdown_entry_by_path(".ko_slideout_content .tab_contents div:nth-child(6) .ko_dropdownlist", role)
	    end
	    it "Save the user" do
	        @ui.click('#user-slideout-save')
	        sleep 3
	        expect(@ui.css('.tabpanel_slideout.left.opened')).not_to exist
	    end
	    #it "Verify that the user is properly created and has the values: '#{first_name}' + '#{last_name}' + '#{email}' + '#{role}'" do
	    #    user_accounts_grid_actions("verify strings support tools", email, first_name, last_name, additional_details, role)
	    #end
	end
end

shared_examples "scope to customer from support" do |customer_name, location|
	describe "Scope to the customer named '#{customer_name}' from the location '#{location}'" do
		if location == "Customers tab"
			it "Tick the tenant line and press the 'SCOPE' button" do
				@ui.click(".nssg-table tbody tr:first-child td:first-child .mac_chk_label")
				sleep 1
				expect(@ui.css('#cnp-customers-scope')).to be_present
				sleep 1
				@ui.css("#cnp-customers-scope").click				
			end
		elsif location == "Browsing tenant area"
			it "Press the 'Scope to Client' link" do
				expect(@ui.css('.right-tab-menu a:nth-child(2)')).to be_present
				@browser.element(:link_text, 'Scope to Customer').click
			end
		end
		it "Verify that the user scoped to the customer" do
			expect(@ui.css('#tenant_scope_options')).to be_present
			expect(@ui.css('#tenant_scope_options a .text').text).to eq(customer_name)
		end
	end
end