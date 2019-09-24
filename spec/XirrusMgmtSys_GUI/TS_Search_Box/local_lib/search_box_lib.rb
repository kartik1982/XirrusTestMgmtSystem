require_relative "../../TS_Portal/local_lib/portal_lib.rb"

def find_proper_search_box
	@ui.get(:elements , {css: ".xc-search"}).each { |element|
		if element.present?
			return element
		end
	}
end

def verify_search_box(bool)
	#@ui.css('.xc-search').hover
	sleep 0.5
	if bool == true
		search_box_element = find_proper_search_box
		search_box_element.wait_until_present
		expect(search_box_element).to be_visible
		expect(search_box_element.element(css: ' input')).to be_visible
		expect(search_box_element.element(css: ' input').attribute_value("type")).to eq("text")
		expect(search_box_element.element(css: ' .btn-search')).to be_visible
		expect(search_box_element.element(css: ' .btn-clear')).not_to be_visible
		snippet = "var searchParent = $('.xc-search:visible').closest('.clearfix.push-right');
		if (searchParent.length === 0) {
			return $('.xc-search:visible').parent().css('margin-right');
		}
		else {
			return searchParent.css('margin-right');
		}"
		margin_right_size = @browser.execute_script(snippet)
		expect(margin_right_size).to eq("10px")
	else
		expect(@ui.css('.xc-search')).not_to be_visible
	end
end

def search_for_a_certain_string_new(search_object, mandatory_found)
	grid_length_before = @ui.css('.nssg-table').trs.length
	search_box_element = find_proper_search_box
	search_box_element.hover
	sleep 0.5
	search_box_element.element(css: ' input').send_keys search_object
	if @browser.url.include?('/#backoffice/customers') and @browser.url.include?('/arrays')
		# sleep 1
		# search_box_element.element(css: ' .btn-search').click
	end
	sleep 6
	grid_length_after = @ui.css('.nssg-table').trs.length - 1
	expect(grid_length_after).not_to eq(grid_length_before)
	expect(search_box_element.element(css: ' .btn-search')).not_to be_visible
	expect(search_box_element.element(css: ' .btn-clear')).to be_visible
	if !@browser.url.include?('/#backoffice/customers')
		expect(search_box_element.element(css: ' .bubble')).to be_visible
	end
	expect(search_box_element.element(css: ' .bubble .count').text).to eq(grid_length_after.to_s)
	if grid_length_after == 0
		expect(@ui.css('.noresults')).to be_visible
	end
	if mandatory_found == true
		expect(@ui.css('.noresults')).not_to be_visible
	end
end

################# GO TO LOCATIONS #################

shared_examples "go to support management customers tab" do
	it "Go to Support Management => Customers tab" do
		@ui.click('#header_nav_user')
		sleep 1
		@ui.click('#header_backoffice_link')
		sleep 2.5
		@ui.click('#backoffice_tab_firmware')
    sleep 1
		expect(@browser.url).to include('/#backoffice/firmware')
		@ui.click('#backoffice_tab_customers')
		sleep 2
		expect(@browser.url).to include('/#backoffice/customers')
	end
	it "Set the view per page to 500" do
		@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "500")
	end
end

shared_examples "open a certain customer" do |customer_name|
	it "Search for the Customer named '#{customer_name}'" do
		expect(@browser.url).to include('/#backoffice/customers')
		@ui.css(".xc-search").wait_until_present
		expect(@ui.css('.xc-search')).to be_visible
		search_for_a_certain_string_new(customer_name, false)
		sleep 1.5
		@ui.grid_click_on_specific_line(3, customer_name, "a")
	end
	it "Verify that the proper customer (named '#{customer_name}') is opened and that the user is on the Access Points tab" do
		expect(@ui.css('#customerDash_view')).to be_visible
		expect(@ui.css('#customerDash_view div:nth-child(2) span:nth-child(2)').text).to eq(customer_name)
		expect(@browser.url).to include('/#backoffice/customers/')
		expect(@browser.url).to include('/arrays')
	end
end

shared_examples "open a certain profile" do |profile_name|
	it "Open the profile named '#{profile_name}' " do
		@ui.goto_profile profile_name
	end
end

shared_examples "go to the access points tab" do |profile_name|
	it "Verify that you are on the profile named '#{profile_name}' and go to the Access Points tab" do
		expect(@ui.css('#profile_name').text).to eq(profile_name)
		@ui.click('#profile_tab_arrays')
		sleep 1.5
		expect(@browser.url).to include("/aps")
	end
end

shared_examples "add several access points to the profile" do |how_many|
	it "Press the 'Add Access Points' button" do
		expect(@browser.url).to include('/aps')
		@ui.click('#profile_array_add_btn')
		sleep 1
		expect(@ui.css('#array_add_modal')).to be_visible
	end
	it "Add the first '#{how_many}' arrays to the profile" do
		(1..how_many).each do
			@ui.click("#add_arrays .lhs .select_list ul li:nth-child(1)")
			sleep 0.7
			@ui.click('#arrays_add_modal_move_btn')
			sleep 0.7
		end
		expect(@ui.css('#add_arrays .rhs .select_list ul').lis.length).to eq(how_many)
		sleep 0.5
		@ui.click('#arrays_add_modal_addarrays_btn')
	end
	it "Verify that the All Access Points grid contains '#{how_many}' entries" do
		expect(@ui.css('.nssg-table tbody').trs.length).to eq(how_many)
	end
end

shared_examples "go to the clients tab" do |profile_name|
	it "Verify that you are on the profile named '#{profile_name}' and go to the Clients tab" do
		expect(@ui.css('#profile_name').text).to eq(profile_name)
		@ui.click('#profile_tab_clients')
		sleep 1.5
		expect(@browser.url).to include("/clients")
	end
end

shared_examples "go to support management access points tab" do
	it "Go to Support Management => Access Points tab" do
		@ui.click('#header_nav_user')
		sleep 1
		@ui.click('#header_backoffice_link')
		sleep 2.5
		@ui.click('#backoffice_tab_firmware')
		sleep 1
		expect(@browser.url).to include('/#backoffice/firmware')
		@ui.click('#backoffice_tab_arrays')
		sleep 2
		expect(@browser.url).to include('/#backoffice/arrays')
	end
end

shared_examples "go to my network clients tab" do
	it "Go to My Network => Clients tab" do
		@ui.click('#header_mynetwork_link')
		sleep 1.5
		@ui.click('#mynetwork_tab_clients')
		sleep 1.5
		expect(@browser.url).to include('/#mynetwork/clients')
	end
	it "Set the view type to 'All Clients' and 'All Time'" do
		@ui.set_dropdown_entry('clients_state', "All Clients")
		sleep 1
		@ui.set_dropdown_entry('clients_span', "All time")
	end
end

shared_examples "go to my network access points tab" do
	it "Go to My Network ~ Access Points tab" do
		@ui.click('#header_mynetwork_link')
		sleep 1.5
		@ui.click('#mynetwork_tab_arrays')
		sleep 1.5
		expect(@browser.url).to include('/#mynetwork/aps')
	end
end

################# VERIFY SEARCH METHODS #################

shared_examples "verify search box tooltip" do |tooltip_message|
	describe "Verify that when drilling into the search input box the application displays the correct tooltip message" do
		it "Verify that the tooltip message is '#{tooltip_message}'" do
			@ui.click('.commonTitle span') and sleep 1
			search_box_element = find_proper_search_box
			search_box_element.wait_until_present
			expect(search_box_element).to be_visible
			expect(search_box_element.element(css: ' input')).to be_visible
			search_box_element.element(css: ' input').click
			@ui.css('.ko_tooltip').wait_until_present
			expect(@ui.css('.ko_tooltip .ko_tooltip_content').text).to eq(tooltip_message)
			search_box_element.element(css: ' .btn-search').click
			@ui.css('.ko_tooltip').wait_while_present
		end
	end
end

shared_examples "verify the search box exists or not" do
	it "Verify that if the grid is empty the search box isn't displayed or if the grid has items then the search box is displayed" do
		grid_length = @ui.css('.nssg-table').trs.length
		if grid_length == 1
			if @browser.url.include?('/clients')
				verify_search_box(true)
			else
				verify_search_box(false)
			end
		else
			verify_search_box(true)
		end
	end
end

shared_examples "verify the search box with or without results to display and cancel search using x" do |search_object, mandatory_found|
	it "Search for the string '#{search_object}' and verify that it is properly displayed with or without results" do
		search_for_a_certain_string_new(search_object, mandatory_found)
	end
	it "Cancel the search using the 'x' button and verify that the search box is properly displayed" do
		search_box_element = find_proper_search_box
		search_box_element.element(css: ' .btn-clear').click
		sleep 0.5
		if @browser.url.include?("/google") or @browser.url.include?("/azure")
			verify_search_box(false)
		else
			verify_search_box(true)
		end
	end
end

shared_examples "verify the search box with or without results to display and use backspace key" do |search_object, mandatory_found|
	it "Search for the string '#{search_object}' and verify that it is properly displayed with or without results" do
		search_for_a_certain_string_new(search_object, mandatory_found)
	end
	it "Cancel the search using the 'BACKSPACE' key and verify that the search box is properly displayed" do
		(0..search_object.length+2).each do
			@browser.send_keys :backspace
			@browser.send_keys :delete
			sleep 0.3
		end
		sleep 0.5
		verify_search_box(true)
	end
end

shared_examples "go to portal guests tab" do |portal_name|
	describe "Go to the Guests tab of a portal" do
		it "Go to the portal named #{portal_name} and then to the Guests tab" do
			navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,false)
		    sleep 2
		    @ui.click('#general_show_advanced')
		    sleep 2
		    @ui.click('#profile_tabs a:nth-child(2)')
		end
	end
end

################# UNIFIED METHOD #################

shared_examples "verify search" do |search_object_1, search_object_2, mandatory_found, skip_backspace|
	it_behaves_like "verify the search box exists or not"
	it_behaves_like "verify the search box with or without results to display and cancel search using x", search_object_1, mandatory_found
	it_behaves_like "verify the search box with or without results to display and cancel search using x", search_object_2, mandatory_found
	if skip_backspace != true
		it_behaves_like "verify the search box with or without results to display and use backspace key", search_object_1, mandatory_found
		it_behaves_like "verify the search box with or without results to display and use backspace key", search_object_2, mandatory_found
	end
end

shared_examples "verify search empty" do
	it_behaves_like "verify the search box exists or not"
end

shared_examples "open profile go to access points tab and add aps" do |profile_name, how_many|
	it_behaves_like "open a certain profile", profile_name
	it_behaves_like "go to the access points tab", profile_name
	it_behaves_like "add several access points to the profile", how_many
end

shared_examples "open profile and go to the access points tab" do |profile_name|
	it_behaves_like "open a certain profile", profile_name
	it_behaves_like "go to the access points tab", profile_name
end

shared_examples "open profile and go to clients tab" do |profile_name|
	it_behaves_like "open a certain profile", profile_name
	it_behaves_like "go to the clients tab", profile_name
end