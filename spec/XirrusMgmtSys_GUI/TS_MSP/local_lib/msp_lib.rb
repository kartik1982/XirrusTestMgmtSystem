require_relative "../../TS_Portal/local_lib/portal_lib.rb"
# require_relative "../mynetwork/access_points_tab/groups/groups_examples.rb"
# require_relative "../mynetwork/switches_tab/switch_examples.rb"

def verify_value_on_grid_cell(which_column, name, a_or_div, which_column2, a_or_div2, string)
    @ui.click('.nssg-container .nssg-thead tr th:nth-child(3)')
    #expect($verify_text_entry).to eq(string)
    sleep 2
    puts @ui.grid_verify_strig_value_on_specific_line(which_column, name, a_or_div, which_column2, a_or_div2, string)
    if string.class == Array
        string.each do |array_entry|
            expect(@ui.grid_verify_strig_value_on_specific_line(which_column, name, a_or_div, which_column2, a_or_div2, string)).to include(array_entry)
        end
    else
        expect(@ui.grid_verify_strig_value_on_specific_line(which_column, name, a_or_div, which_column2, a_or_div2, string)).to eq(string)
    end
end

def verify_existing_columns_names(column_names, column_number_numeric)
    column_number = column_number_numeric
    puts column_names
    column_names.each { |column_name|
        if column_name == 'Check Box'
            expect(@ui.css(".nssg-container thead tr th:nth-child(#{column_number}) input")).to exist
            expect(@ui.css(".nssg-container thead tr th:nth-child(#{column_number}) .mac_chk_label")).to exist
        elsif column_name == 'Does Not Exist'
            if @ui.css(".nssg-container thead tr th:nth-child(#{column_number})").exists?
                expect(@ui.css(".nssg-container thead tr th:nth-child(#{column_number})").attribute_value("class")).to include("gutter")
            else
                expect(@ui.css(".nssg-container thead tr th:nth-child(#{column_number})")).not_to exist
            end
        else
            expect(@ui.css(".nssg-container thead tr th:nth-child(#{column_number}) div:nth-child(2)").text).to eq(column_name)
        end
        column_number+=1
    }
end

def verify_the_deploy_to_domain_modal_contents(profiles_portals, pname)
    if profiles_portals == "Profiles"
        profile_deploy_modal = @ui.css('#profiles_profiledeploy')
        expect(profile_deploy_modal).to be_visible
        expect(profile_deploy_modal.attribute_value("class")).to eq("modal ui-draggable")
    elsif profiles_portals == "Portals"
        profile_deploy_modal = @ui.css('.guestportals-deploy')
        expect(profile_deploy_modal).to exist
        expect(profile_deploy_modal.element(:css => "xc-modal-container").attribute_value("class")).to eq("ui-draggable")
   elsif profiles_portals == "port_templates"
        profile_deploy_modal = @ui.css('#switch_port_template_deploy_modal')
        expect(profile_deploy_modal).to be_visible
    end
    sleep 0.5
    if profiles_portals == "Profiles"
        expect(@ui.css('#profiles_profiledeploy .title_wrap .commonTitle').text).to eq('Deploy to Domain')
        expect(@ui.css('#profiles_profiledeploy .content .profile_deploy_description').text).to eq("Select a domain for your profile:")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(2) .profile_name_label').text).to eq("Profile Name *:")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(2) .profile_name_input')).to be_visible
        expect(@ui.get(:text_field, {css: "#profiles_profiledeploy .content div:nth-child(2) .profile_name_input"}).value).to eq(pname)
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(2) .profile_name_input').attribute_value("type")).to eq("text")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(2) .profile_name_input').attribute_value("maxlength")).to eq("255")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(2) .profile_name_input').attribute_value("placeholder")).to eq("required")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(3) .profile_location_label').text).to eq("Domain:")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(3) .profile_location_input').attribute_value("class")).to eq("ko_dropdownlist profile_location_input white")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(3) .profile_location_input a').attribute_value("class")).to eq("ko_dropdownlist_button")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(4) div:first-child').text).to eq("Set as Default:")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(4) div:nth-child(2)')).to be_visible
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(4) div:nth-child(2)').attribute_value("class")).to eq("switch")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(4) div:nth-child(2) input').attribute_value("class")).to eq("switch_checkbox")
        expect(@ui.get(:checkbox, {css: "#profiles_profiledeploy .content div:nth-child(4) div:nth-child(2) input"}).set?).to eq(false)
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(4) div:nth-child(2) label').attribute_value("class")).to eq("switch_label")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(4) div:nth-child(2) label .left').text).to eq("Yes")
        expect(@ui.css('#profiles_profiledeploy .content div:nth-child(4) div:nth-child(2) label .right').text).to eq("No")
        expect(@ui.css('#profiles_profiledeploy .content .buttons #newprofile_cancel')).to be_visible
        expect(@ui.css('#profiles_profiledeploy .content .buttons #newprofile_cancel').text).to eq("Cancel")
        expect(@ui.css('#profiles_profiledeploy .content .buttons #newprofile_cancel').attribute_value("class")).to eq("button")
        expect(@ui.css('#profiles_profiledeploy .content .buttons .button.orange')).to be_visible
        expect(@ui.css('#profiles_profiledeploy .content .buttons .button.orange').text).to eq("DEPLOY")
        expect(@ui.css('#profiles_profiledeploy #profiles_profiledeploy_closemodalbtn')).to be_visible
        expect(@ui.css('#profiles_profiledeploy #profiles_profiledeploy_closemodalbtn').attribute_value("class")).to eq("modal-close")
    elsif profiles_portals == "Portals"
        expect(@ui.css('.guestportals-deploy xc-modal-title').text).to eq("Deploy to Domain")
        expect(@ui.css('.guestportals-deploy .xc-modal-close')).to be_present
        expect(@ui.css('.guestportals-deploy .content .description').text).to eq("Select a domain for your portal:")
        expect(@ui.css('.guestportals-deploy .content .portalname .portalname-label').text).to eq("Portal Name *:")
        expect(@ui.css('#guestportals-deploy-portalname-input').attribute_value("type")).to eq("text")
        expect(@ui.get(:input, {css: '#guestportals-deploy-portalname-input'}).value).to eq(pname)
        expect(@ui.css('#guestportals-deploy-portalname-input').attribute_value("placeholder")).to eq("required")
        expect(@ui.css('.guestportals-deploy .content .domain .domain-label').text).to eq("Domain:")
        expect(@ui.css('.guestportals-deploy .content .domain .deploy-domain-list')).to be_present
        expect(@ui.css('#guestportals-deploy-cancel')).to be_present
        expect(@ui.css('#guestportals-deploy-submit')).to be_present
    end
end

def verify_that_a_tile_is_present(profile_portals, searched_name)
    if profile_portals == "Profiles"
        titles = @ui.get(:elements, {css: "#profiles_list .ui-sortable .tile a span:nth-child(1)"})
    elsif profile_portals == "Portals"
        titles =  @ui.get(:elements, {css: "#guestportals_list .ui-sortable .tile a span:nth-child(1)"})
    elsif profile_portals == "port_templates"
        titles =  @ui.get(:elements, {css: "#switch_port_templates ul li a .title"})
    elsif profile_portals == "switch_templates"
        titles =  @ui.get(:elements, {css: "#switch_templates ul li a .switchtemplate_name_heading_Value"})
    end
    
    titles.each { |title|
      if title.text == searched_name
          expect(title.text).to eq(searched_name)
          return true
      end
    }
    return false
end
def press_deploy_button_for_namespace_before_after(template_type, searched_name)
  if template_type == "switch_templates"
    titles =  @ui.get(:elements, {css: "#switch_templates ul li a .switchtemplate_name_heading_Value"})
    deploy_icons = @ui.get(:elements, {css: "#switch_templates ul li .icon-copy3"})
    titles.each_with_index do |title, index|
      if title.text == searched_name
       css_path= "#switch_templates ul li:nth-child(#{index+1}) .icon-copy3"
       script = "$(\"#{css_path}\").click()"      
       @browser.execute_script(script)
       sleep 1
      end      
    end
  else
    puts "if switch port get implemnted same need to update function"
  end
  
end
def hover_over_tile_and_press_deploy_button(profile_portals, searched_name)
  deployindex=0
    if profile_portals == "Profiles"
        titles = @ui.get(:elements, {css: "#profiles_list .ui-sortable .tile a span:nth-child(1)"})
        deploy_icons = @ui.get(:elements, {css: "#profiles_list .ui-sortable .tile div:first-child div .deployIcon"})
    elsif profile_portals == "Portals"
        titles =  @ui.get(:elements, {css: "#guestportals_list .ui-sortable .tile a span:nth-child(1)"})
        deploy_icons = @ui.get(:elements, {css: "#guestportals_list .ui-sortable .tile div:first-child div .deployIcon"})
    elsif profile_portals == "port_templates"
        titles =  @ui.get(:elements, {css: "#switch_port_templates ul li a .title"})
        deploy_icons = @ui.get(:elements, {css: "#switch_port_templates ul li .overlay .icon.deployIcon"})
    elsif profile_portals == "switch_templates"
        titles =  @ui.get(:elements, {css: "#switch_templates ul li a .switchtemplate_name_heading_Value"})
        deploy_icons = @ui.get(:elements, {css: "#switch_templates ul li .icon-copy3"})
    end
    puts titles.count
    titles.each { |title|
      deployindex +=1
      if title.text == searched_name
        title.hover
        sleep 0.5
        break
      end
    }
puts deploy_icons.count
    deploy_icons.each { |deploy_icon|
      if deploy_icons.length != 1
        puts "lets do something"
        deploy_icons[deployindex-1].click
        break
      elsif deploy_icon.visible?
        deploy_icon.click
        sleep 0.5
        break
      end
    }
end

def hover_over_tile_and_verify_deploy_button_hidden(profile_portals, searched_name)
    if profile_portals == "Profiles"
        titles = @ui.get(:elements, {css: "#profiles_list .ui-sortable .tile a span:nth-child(1)"})
    elsif profile_portals == "Portals"
        titles =  @ui.get(:elements, {css: "#guestportals_list .ui-sortable .tile a span:nth-child(1)"})
    end
    titles.each { |title|
      if title.text == searched_name
        title.hover
        sleep 0.5
        expect(title.parent.parent.element(:css => '.overlay .content .deployIcon').attribute_value("style")).to eq('display: none;')
        break
      end
    }
end

def press_the_save_button
    it "Press the <SAVE> button" do
        expect(@ui.css('#accountdetails_save')).to be_present
        @ui.click("#accountdetails_save")
        sleep 0.5
        @ui.css('.ko_slideout_content').wait_while_present
        sleep 1
        expect(@ui.css('.ko_slideout_content')).not_to be_visible
    end
end

def verify_the_domain_name_and_description(domain_name, domain_description)
    it "Verify that the domain name and description are properly displayed" do
        expect(@ui.css('.ko_slideout_content')).to exist
        dn = @ui.id('edit_name')
        dn.wait_until_present
        expect(dn.attribute_value("maxlength")).to eq("255")
        expect(@ui.get(:input, {css: '#edit_name'}).value).to eq(domain_name)
        sleep 1
        dd = @ui.id('edit_desc')
        dd.wait_until_present
        expect(dd.attribute_value("maxlength")).to eq("255")
        expect(@ui.get(:textarea, {css: '#edit_desc'}).value).to eq(domain_description)
        sleep 1
    end
end

shared_examples "verify tenant scoping icons" do |tenant| #Changed on 31/05/2017 - due to US 4935
    describe "Verify that the tenant scoping dropdown items have the proper icons" do
        it "Verify that the tenant scope dropdown parent entry has the proper icon" do
            @ui.click('#tenant_scope_options .arrow')
            sleep 1
            expect(@ui.css('.blue .ko_dropdownlist_list_wrapper .ko_dropdownlist_list_scroller ul .dd-parent')).to be_visible #- due to US 4935
            #expect(@ui.css('.blue .ko_dropdownlist_list_wrapper .ko_dropdownlist_list_scroller ul .dd-none:first-child')).to be_visible
        end
        it "Verify that the tenant scope dropdown child entry has the proper icon" do
            sleep 1
            expect(@ui.css('.blue .ko_dropdownlist_list_wrapper .ko_dropdownlist_list_scroller ul .dd-child')).to be_visible #- due to US 4935
            #expect(@ui.css('.blue .ko_dropdownlist_list_wrapper .ko_dropdownlist_list_scroller ul .dd-none:nth-child(2)')).to be_visible
            sleep 1
            @ui.css('.blue .ko_dropdownlist_list_wrapper .ko_dropdownlist_list_scroller ul .dd-parent').click #- due to US 4935
            #@ui.css('.blue .ko_dropdownlist_list_wrapper .ko_dropdownlist_list_scroller ul .dd-none:first-child').click
            sleep 1
            @ui.click('#main_container .globalTitle')
        end
        it "Ensure that the selected tenant is #{tenant}" do
            sleep 1
            expect(@ui.css('#tenant_scope_options .ko_dropdownlist_button .text').attribute_value("title")).to include(tenant)
        end
    end
end

shared_examples "go to commandcenter" do
    describe "Go to the CommandCenter area" do
        it "Go to CommandCenter Admin" do
            builder_url = /https:\/\/xcs-test0[0-9].cloud.xirrus.com\/#msp\//
            proper_urls = [/#{builder_url}accounts/, /#{builder_url}dashboard/, /#{builder_url}users/, /#{builder_url}arrays/]
            if !proper_urls.include?(@browser.url)
                @ui.click('#header_nav_user')
                sleep 1
                @ui.click('#header_msp_link')
                sleep 1
                unless !proper_urls.include?(@browser.url)
                    sleep 5
                end
            end
        end
    end
end

shared_examples "go to specific tab" do |tab|
    describe "Go to the tab named '#{tab}' from Command Center Admin" do
        it "Press the tab menu button, verify that the proper location is displayed and that no errors are received" do
            case tab
                when "Dashboard"
                    tab_id = '#msp_tab_dashboard'
                    url_string = '/#msp/dashboard'
                when "Domains"
                    tab_id = '#msp_tab_accounts'
                    url_string = '/#msp/accounts'
                when "Users"
                    tab_id = '#msp_tab_users'
                    url_string = '/#msp/users'
                when "Access Points"
                    tab_id = '#msp_tab_arrays'
                    url_string = '/#msp/arrays'
            end
            @ui.click(tab_id)
            sleep 3
            expect(@browser.url).to include(url_string)
        end
    end
end

#This snippet will open the profile dropdown list and select the CommandCenter entry
shared_examples "go to CommandCenter and verify basic requirements" do
  describe "go to CommandCenter and verify basic requirements" do
    it "Go to CommandCenter Admin" do
        if (!@browser.url.end_with? "/msp/accounts")
            @ui.click('#header_nav_user')
            sleep 1
            @ui.click('#header_msp_link')
            sleep 1
        end
        puts "The application is already on the CommandCenter Admin tab"
        sleep 1
    end
    it "Verify that there are four tabs available: Dashboard, Domains, Users & Access Points" do
        expect(@ui.css('#msp_tab_dashboard span').text).to eq('Dashboard')
        expect(@ui.css('#msp_tab_accounts').text).to eq('Domains')
        expect(@ui.css('#msp_tab_users').text).to eq('Users')
        expect(@ui.css('#msp_tab_arrays').text).to eq('Access Points')
    end
    it "Verify that the Domains tab grid has the following columns: 'Domain Name', 'AP Count' and 'User(s)'" do
        @ui.click('#msp_tab_accounts')
        sleep 2
        column_names = ["Domain Name","AP Count","User(s)","Does Not Exist"]
        verify_existing_columns_names(column_names, 2)
    end
    it "Go to the Access Points tab and verify that the grid has the columns: 'Check Box', 'MAC Address', 'Serial Number', 'Model', 'Domain', 'Expiration Date' and 'Administrative Status'" do
        @ui.click('#msp_tab_arrays')
        sleep 2
        expect(@browser.url).to include('/#msp/arrays')
        sleep 0.5
        column_names = ["Check Box","MAC Address","Serial Number","Model","Domain","Expiration Date","Administrative Status","Does Not Exist"]
        verify_existing_columns_names(column_names, 2)
    end
    it "Go to the Users tab and verify the title of the tab has the string 'Users'" do
        @ui.click('#msp_tab_users')
        sleep 1
        abc = @ui.css('.tabs_container .tab-item-container .commonTitle span').text
        expect(abc.to_s).to include("Users")
    end
    it "Verify that the Users grid has the columns: 'Name', 'Email' and 'Domain(s)'" do
        column_names = ["Name","Email","Domain(s)","Does Not Exist"]
        verify_existing_columns_names(column_names, 3)
    end
    it "Verify that the '+ New' button contains the string 'User'" do
        expect(@ui.css('#msp-users-new').text).to eq("+ NEW USER")
    end
    it "Verify that the slideout description contains the string 'User'" do
        @ui.click('#msp-users-new')
        sleep 1
        expect(@ui.css('.ko_slideout_content .slideout_desc').text).to eq("Edit/View the User details")
        @ui.click('#clidetails_close_btn')
    end
    it "Go to the Access Points tab" do
        @ui.click('#msp_tab_arrays')
    end
    it "Verify that all columns have the sort feature (EXCEPT FOR MAC ADDRESS???)" do
        mac_address_column = @ui.css('.nssg-table .nssg-thead tr th:nth-child(3)')
        for i in 4..7
            other_columns = @ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i})")
            expect(other_columns.attribute_value("class")).to include("nssg-th")
            expect(other_columns.attribute_value("class")).to include("nssg-th-text")
            expect(other_columns.attribute_value("class")).to include("nssg-sortable")
        end
        expect(mac_address_column.attribute_value("class")).to include("nssg-th nssg-th-text")
        expect(mac_address_column.attribute_value("class")).not_to include("nssg-sortable")
    end
    it "Go back to the Domains tab" do
        sleep 1
        @ui.click('#msp_tab_accounts')
    end
  end
end

shared_examples "verify access points search" do |model_number|
    describe "Verify that the user can search for entries on the Access Points tab" do
        it "Go to the Access Points tab" do
            @ui.click('#msp_tab_arrays')
            sleep 2
            expect(@browser.url).to include('/#msp/arrays')
        end
        it "Verify that the search box is properly displayed and verify the placeholder text is 'Search for Serial Number or Model'" do
            expect(@ui.css('.xc-search')).to exist
            expect(@ui.css('.xc-search input')).to be_visible
            expect(@ui.css('.xc-search input').attribute_value("placeholder")).to eq("Search for Serial Number or Model")
            expect(@ui.css('.xc-search .btn-search')).to be_visible
        end
        it "Set the paging view to 1000 entries per page" do
            @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000")
        end
        it "Press the 'Search' button 5 times with the search box empty and verify that the grid responds accordingly" do
            length = @ui.css('.nssg-table tbody tr:nth-child(2) td:nth-child(4) .nssg-td-text').text
            (1..5).each do
                @ui.click('.xc-search input')
                sleep 0.5
                @ui.click('.xc-search .btn-search')
            end
            expect(@ui.css('.nssg-table tbody tr:nth-child(2) td:nth-child(4) .nssg-td-text').text).to eq(length)
        end
        it "Get the SN of the array from the second line of the grid and search using it, then verify only 1 result is displayed in the grid and in the bubble" do
            @@searched_serial = @ui.css('.nssg-table tbody tr:nth-child(2) td:nth-child(4) .nssg-td-text').text
            sleep 0.5
            @ui.set_input_val('.xc-search input', @@searched_serial)
            sleep 3
            expect(@ui.css('.nssg-table tbody').trs.length).to eq(1)
            expect(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(4) .nssg-td-text').text).to eq(@@searched_serial)
            expect(@ui.css('.xc-search .bubble .count').text.to_i).to eq(1)
        end
        it "Remove the search criteria and verify that the bubble is not displayed, the first entry is not the one searched for and that the grid length is not 1" do
            @ui.click('.xc-search .btn-clear')
            sleep 3
            expect(@ui.css('.nssg-table tbody').trs.length).not_to eq(1)
            expect(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(4) .nssg-td-text').text).not_to eq(@@searched_serial)
            expect(@ui.css('.xc-search .bubble .count')).not_to be_visible
        end
        it "Get the count of APs of '#{model_number}', search for the model number entries and verify that the grid and bubble properly show the number of entries" do
            @@i = 0
            grid_length = @ui.css('.nssg-table tbody').trs.length
            while grid_length != 0
                if @ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(5) .nssg-td-text").text == model_number
                    @@i+=1
                end
                grid_length-=1
            end
            sleep 0.5
            @ui.set_input_val('.xc-search input', model_number)
            sleep 3
            expect(@ui.css('.nssg-table tbody').trs.length).to eq(@@i)
            expect(@ui.css('.xc-search .bubble .count').text.to_i).to eq(@@i)
        end
        it "Remove the search criteria and verify that the bubble is not displayed, and the list length is greater or equal to the model entries searched before" do
            @ui.click('.xc-search .btn-clear')
            sleep 2
            expect(@ui.css('.nssg-table tbody').trs.length).to be >= @@i
            expect(@ui.css('.xc-search .bubble .count')).not_to be_visible
        end
        it "Set the paging view to 10 entries per page" do
            @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "10")
        end
        it "Get the Domain value from the first line and use it as a search criteria, verify that no entry is displayed" do
            searched_domain = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(6) .nssg-td-text').text
            sleep 0.5
            @ui.set_input_val('.xc-search input', searched_domain)
            sleep 3
            if @ui.css('.nssg-table').theads.length > 1
                expect(@ui.css('.nssg-table thead:nth-child(2)').trs.length).to eq(1)
            else
                expect(@ui.css('.nssg-table thead').trs.length).to eq(1)
            end
            expect(@ui.css('.nssg-table tbody tr')).not_to exist
            expect(@ui.css('.noresults').text).to eq("No results found")
            expect(@ui.css('.xc-search .bubble .count').text.to_i).to eq(0)
        end
        it "Remove the search criteria and verify that the bubble is not displayed, and the list length is not 0" do
            @ui.click('.xc-search .btn-clear')
            sleep 2
            expect(@ui.css('.nssg-table tbody').trs.length).to be >= 0
            expect(@ui.css('.xc-search .bubble .count')).not_to be_visible
        end
        it "Get the MAC value from the first line and use it as a search criteria, verify that no entry is displayed" do
            searched_domain = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) .nssg-td-text').text
            sleep 0.5
            @ui.set_input_val('.xc-search input', searched_domain)
            sleep 3
            if @ui.css('.nssg-table').theads.length > 1
                expect(@ui.css('.nssg-table thead:nth-child(2)').trs.length).to eq(1)
            else
                expect(@ui.css('.nssg-table thead').trs.length).to eq(1)
            end
            expect(@ui.css('.nssg-table tbody tr')).not_to exist
            expect(@ui.css('.noresults').text).to eq("No results found")
            expect(@ui.css('.xc-search .bubble .count').text.to_i).to eq(0)
        end
        it "Remove the search criteria and verify that the bubble is not displayed, and the list length is not 0" do
            @ui.click('.xc-search .btn-clear')
            sleep 2
            expect(@ui.css('.nssg-table tbody').trs.length).to be >= 0
            expect(@ui.css('.xc-search .bubble .count')).not_to be_visible
        end
        it "Drill into the search input box and verify the tooltip message" do
            @ui.click('.xc-search input')
            sleep 1
            expect(@ui.css('.ko_tooltip.ko_tooltip_content_text.ko_tooltip_has_arrow .ko_tooltip_content').text).to eq("Search for Serial Number or Model.\nEnter at least 3 characters.")
        end
    end
end

# US 5130 - CC | Add mode information about APs in the AP grid
shared_examples "verify the ap slideout" do |ap_sn, ap_mac, ap_model, domain_name, ap_hostname, profile_name, location, tag|
    describe "Verify the components of the AP slideout container" do
        it "Go to the Access Points tab" do
            @ui.click('#msp_tab_arrays')
            sleep 2
            expect(@browser.url).to include('/#msp/arrays')
        end
        it "Set the paging view to 10 entries per page" do
            @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "10")
        end
        it "Open the slideout container for the'#{ap_sn}'' AP" do
            @browser.execute_script('$("#suggestion_box").hide()')
            @path_of_line = @ui.find_array_depending_on_included_strings_then_return_path(ap_sn, 4, "div")
            sleep 1
            tick_box = @path_of_line.sub("td:nth-child(4) div", "td:nth-child(2) .mac_chk_label")
            @ui.click(tick_box)
            actions_container_invoke = @path_of_line.sub("td:nth-child(4) div", "td:nth-child(1) .nssg-action-invoke")
            @ui.click(actions_container_invoke)
            sleep 0.4
        end
        it "Verify the slideout container's content" do
            css_contructor = '.array_details.opened .ko_slideout_content'
            expect(@ui.css(css_contructor)).to be_present
            expect(@ui.css(css_contructor + " .slideout_title .title").text).to eq(ap_sn)
            expect(@ui.css(css_contructor + " .slideout_desc").text).to eq("Edit/View Access Point Details")
            expect(@ui.css(css_contructor + " .top .sectiontitle").text).to eq("General")
            css_contructor = css_contructor + " .tab_contents .info_block"
            log ""
            values_hash = Hash[1 => ["MAC Address:", ap_mac], 2 => ["Serial Number:", ap_sn], 3 => ["Model:", ap_model], 4 => ["Domain:", domain_name], 5 => ["Profile:", profile_name], 6 => ["Location:", location], 7 => ["Hostname:", ap_hostname], 8 => ["Tags:", tag]]
            values_hash.each do |key, value|
                log css_contructor + " div:nth-child(#{key}) .field_label"
                expect(@ui.css(css_contructor + " div:nth-child(#{key}) .field_label").text).to eq(value[0])
                if key == 4
                    expect(@ui.get(:input , {css: css_contructor + " div:nth-child(#{key}) .account_input"}).value).to eq(value[1])
                elsif key == 8
                    expect(@ui.css(css_contructor + " div:nth-child(#{key}) .tagControlContainer .tag .text").text).to eq(value[1])
                else
                    expect(@ui.css(css_contructor + " div:nth-child(#{key}) .info_field").text).to eq(value[1])
                end
            end
        end
        it "Close the slideout container" do
            log ""
            @ui.click('#apdetails_close_btn')
            sleep 1
            expect(@ui.css('#apdetails_close_btn')).not_to be_visible
        end
    end
end

#This snippet will create a domain with the name value and description set by the user
shared_examples "create Domain" do |domain_name|
  describe "create Domain" do
    it "Create Domain with the name : #{domain_name}" do
   		@browser.execute_script('$("#suggestion_box").hide()')
        sleep 2
        @ui.click('#msp_tab_accounts')
        sleep 2
   		@ui.click('#msp-newacct-btn')
        sleep 1
   		@ui.set_input_val('#edit_name', domain_name)
        sleep 1
        @ui.set_textarea_val('#edit_desc', domain_name + " - DESCRIPTION TEXT")
        sleep 1
        @ui.click('#accountdetails_save')
        sleep 5
        @browser.refresh
        sleep 5
    end
    it "Verify that the entry #{domain_name} appears in the grid" do

        expect(@ui.grid_verify_strig_value_on_specific_line("2", domain_name, "div", "2", "div", domain_name)).to eq(domain_name)
    end
  end
end

shared_examples "create domain quick" do |domain_name|
    describe "Create a domain quickly" do
        it "Create the Domain with the name '#{domain_name}'" do
            @ui.click('#msp_tab_accounts')
            sleep 1
            @ui.click('#msp-newacct-btn')
            sleep 0.5
            @ui.set_input_val('#edit_name', domain_name)
            sleep 0.5
            @ui.set_textarea_val('#edit_desc', domain_name + " - DESCRIPTION TEXT")
            sleep 0.5
            @ui.click('#accountdetails_save')
            sleep 1
            if @ui.css('.isLoading').exists? == true
                unless @ui.css('.isLoading').exists? == false
                    sleep 0.5
                    puts "sleep"
                end
            end
            @ui.click('.nssg-refresh')
            sleep 1
        end
    end
end

shared_examples "edit a specific domain in the grid" do |domain_name, new_domain_name, new_domain_description|
  describe "Search for a specific domain in the grid" do
    it "Search for a domain with the name of : #{domain_name} and open to edit it" do
        @browser.execute_script('$("#suggestion_box").hide()')
        sleep 1
        @ui.click('#msp_tab_accounts')
        sleep 1
        @ui.grid_action_on_specific_line("2", "div", domain_name, "invoke")
    end
    verify_the_domain_name_and_description(domain_name, domain_name + " - DESCRIPTION TEXT")
    if new_domain_name != nil
        it "Edit the name of the domain" do
            expect(@ui.css('.ko_slideout_content')).to be_present
            expect(@ui.css('#edit_name')).to exist
            sleep 1
            @ui.set_input_val("#edit_name", new_domain_name)
            sleep 1
        end
    end
    if new_domain_description != nil
        it "Edit the description of the domain" do
            expect(@ui.css('.ko_slideout_content')).to be_present
            expect(@ui.css('#edit_desc')).to exist
            sleep 1
            @ui.set_textarea_val("#edit_desc", new_domain_description)
            sleep 1
        end
    end
    press_the_save_button
    it "Reopen the domain" do
        if new_domain_name != nil
            @ui.grid_action_on_specific_line("2", "div", new_domain_name, "invoke")
        else
            @ui.grid_action_on_specific_line("2", "div", domain_name, "invoke")
        end
    end
    if new_domain_name != nil
        if new_domain_description != nil
            verify_the_domain_name_and_description(new_domain_name, new_domain_description)
        else
            verify_the_domain_name_and_description(new_domain_name, domain_name + " - DESCRIPTION TEXT")
        end
    elsif new_domain_description != nil
        verify_the_domain_name_and_description(domain_name, new_domain_description)
    else
        verify_the_domain_name_and_description(domain_name, domain_name + " - DESCRIPTION TEXT")
    end
  end
end

shared_examples "verify loading not present" do
    describe "Verify that the 'Loading' prompt is not displayed" do
        it "Focus on the 'Loading' prompt (if it exists) and validate that it isn't present more than 5 seconds" do
            if @ui.css('.loading').exists?
                if @ui.css('.loading').visible?
                    sleep 5
                end
            end
            expect(@ui.css('.loading')).not_to exist
        end
    end
end

#This snippet will go to the user named domain and delete it
shared_examples "delete Domain" do |domain_name|
  describe "delete Domain" do
    it "Delete Domain with the name : #{domain_name}" do
    	@browser.execute_script('$("#suggestion_box").hide()')
        sleep 1
        @ui.click('#msp_tab_accounts')
        sleep 1
        if domain_name.class == Array
            to_delete_domain = @ui.find_array_depending_on_included_strings_then_return_path(domain_name[0], domain_name[1], domain_name[2]) and sleep 1
            @ui.css(to_delete_domain).hover and sleep 1
            to_delete_domain = to_delete_domain[0...to_delete_domain.index("td:nth-child(")+13] << "1) .nssg-action-delete"
            @ui.click(to_delete_domain)
        else
            @ui.grid_action_on_specific_line("2", "div", domain_name, "delete")
        end
        sleep 1
        @ui.click('#_jq_dlg_btn_1')
        sleep 1
    end
  end
end

#This snippet will create and Administrator with the First Name, Last Name and Email values set by the user
shared_examples "create Administrator from administrator tab" do |first_name, last_name, email, domain_name|
	describe "create Administrator from administrator tab" do
		it "Go to the Administrators tab" do
			@browser.execute_script('$("#suggestion_box").hide()')
            @ui.click('#msp_tab_users')
        	sleep 1
        	@ui.click('#msp-users-new')
        	sleep 1
            @ui.click('#accountdetails_tab_general')
        end
        it "Set the following values: #{first_name} + #{last_name} + #{email}" do
        	sleep 1
            #@ui.set_input_val('.tab_contents .slideout-overlay-form .inner div:nth-child(3)',first_name)
            @ui.set_input_val('#msp-users-firstname', first_name)
            #@ui.set_input_val('.ko_slideout_container .tab_contents .xc-field:first-child > input', first_name)
        	sleep 1
        	@ui.set_input_val('#msp-users-lastname',last_name)
            #@ui.set_input_val('.ko_slideout_container .tab_contents .xc-field:nth-child(2) > input', last_name)
        	sleep 1
        	@ui.set_input_val('#msp-users-email',email)
            #@ui.set_input_val('.ko_slideout_container .tab_contents .xc-field:nth-child(3) > input', email)
        end
        it "Go to the Domains tab and add to the domain: #{domain_name}" do
           @ui.click('#accountdetails_tab_accounts')
           sleep 1
           @ui.click('#msp-users-addtoaccount')
           sleep 1
           @ui.set_dropdown_entry('msp-users-accounts', domain_name)
           sleep 1
           @ui.click('#msp-users-addaccount')
        end
        it "Save the user" do
            sleep 1
            @ui.click('#msp-users-save')
            sleep 3
        end
        it "Search for administrator named #{first_name} #{last_name} and open it for editing" do
            abc = @ui.css('.nssg-paging-count').text

            i = abc.index('of')
            length = abc.length
            number = abc[i + 3, abc.length]
            number2 = number.to_i

            while (number2 != 0) do
                if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(4)").text == email)
                    sleep 1
                    @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3)").hover
                    sleep 1
                    @ui.css(".nssg-table tbody tr:nth-child(#{number2}) .nssg-actions-container .nssg-action-invoke").click
                    sleep 1
                end
                number2-=1
            end
        end
        it "Verify that the administrator's email, first and last name are properly displayed" do
            expect(@ui.css('.ko_slideout_content')).to exist
            sleep 1
            fn = @ui.id('msp-users-firstname')
            fn.wait_until_present
            expect(fn.attribute_value("maxlength")).to eq("100")
            expect(@ui.get(:input, {id: 'msp-users-firstname'}).value).to eq(first_name)

            sleep 1
            ln = @ui.id('msp-users-lastname')
            ln.wait_until_present
            expect(ln.attribute_value("maxlength")).to eq("100")
            puts last_name
            expect(@ui.get(:input, {id: 'msp-users-lastname'}).value).to eq(last_name)

            sleep 1
            eml = @ui.id('msp-users-email')
            eml.wait_until_present
            expect(eml.attribute_value("maxlength")).to eq("255")
            expect(@ui.get(:input, {id: 'msp-users-email'}).value).to eq(email)
            sleep 2

            @ui.click('#clidetails_close_btn')
            sleep 2
        end
    end
end

def slideout_container_grid_actions(what_action, domain_name, role)
    grid_css_string = ".ko_slideout_content .tab_contents grid .nssg-table .nssg-tbody"
    grid_length = @ui.css(grid_css_string).trs.length
    puts grid_length
    a = 1 and @found = false
    while a <= grid_length
        puts a
        puts @ui.css(grid_css_string + " tr:nth-child(#{a}) .name div").text
        if @ui.css(grid_css_string + " tr:nth-child(#{a}) .name div").text == domain_name
            @found = true
            @ui.css(grid_css_string + " tr:nth-child(#{a}) .name div").hover and sleep 1
            case what_action
                when "Invoke"
                    @ui.click(grid_css_string + " tr:nth-child(#{a}) .nssg-td-actions .nssg-action-invoke") and sleep 1
                    @ui.set_dropdown_entry('msp-users-roles', role) and sleep 1
                    @ui.click('#msp-users-addaccount') and sleep 1
                    ### WORK IN PROGRESS - TO ADD SPECIFIC ACTIONS CASE "INVOKE"
                    break
                when "Delete"
                    @ui.click(grid_css_string + " tr:nth-child(#{a}) .nssg-td-actions .nssg-action-delete") and sleep 1
                    @ui.css('.confirm .confirm').wait_until_present
                    @ui.click('#_jq_dlg_btn_1') and sleep 2
                    break
                when "Verify"
                    expect(@ui.css(grid_css_string + " tr:nth-child(#{a}) .name div").text).to eq(domain_name)
                    expect(@ui.css(grid_css_string + " tr:nth-child(#{a}) .roles div").text).to eq(role)
                    break
            end
        end
        a+=1
    end
    expect(@found).not_to eq(false)
end

shared_examples "edit administrator from administrators tab"  do |email, action, domain_name, role|
    describe "Edit Administrator from administrator tab" do
        it "Find and open the administrator with the email '#{email}'" do
            @ui.grid_action_on_specific_line("4", "div", email, "invoke") and sleep 2
            expect(@ui.css(".ko_slideout_container .ko_slideout_content")).to be_present
        end
        it "Go to the Account details tab" do
            @ui.click('#accountdetails_tab_accounts') and sleep 2
            expect(@ui.css('.ko_slideout_content .tab_contents grid')).to be_present
        end
        if action == "Add to Account"
            it "Add the administrator to the domain '#{domain_name}' with the role '#{role}'" do
                @ui.click('#msp-users-addtoaccount') and sleep 1
                @ui.set_dropdown_entry('msp-users-accounts', domain_name) and sleep 1
                @ui.set_dropdown_entry('msp-users-roles', role) and sleep 1
                @ui.click('#msp-users-addaccount') and sleep 3
                if @ui.css('.confirm .confirm').exists? and @ui.css('.confirm .title span').text == "Top Level Domain"
                    @ui.click('#_jq_dlg_btn_1') and sleep 1
                end
            end
            it "Verify the administrator is properly added to the domain with the proper role assigned" do
                slideout_container_grid_actions("Verify", domain_name, role)
            end
        else
            it "Set the administrator to have the role '#{role}' on the domain '#{domain_name}'" do
                slideout_container_grid_actions(action, domain_name, role)
            end
            ### WORK IN PROGRESS - TO ADD SPECIFIC ACTIONS CASE "INVOKE"
        end
        it "Press the <SAVE> button" do
            @browser.execute_script('$("#suggestion_box").hide()')
            @ui.click('#msp-users-save') and sleep 1
            @ui.css('.ko_slideout_container').wait_while_present
        end
    end
end

shared_examples "create Administrator from domain slide-out" do |first_name, last_name, email, domain_name, role|
    describe "create Administrator from domain slide-out" do
        it "Go to the Domain tab and open the #{domain_name} domain" do
            @ui.click('#msp_tab_accounts')
            @browser.execute_script('$("#suggestion_box").hide()')
            sleep 2
            abc = @ui.css('.nssg-paging-count').text

            i = abc.index('of')
            length = abc.length
            number = abc[i + 3, abc.length]
            number2 = number.to_i

            while (number2 != 0) do
                if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(2)").text == domain_name)
                    sleep 1
                    @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(2)").hover
                    sleep 1
                    @ui.css(".nssg-table tbody tr:nth-child(#{number2}) .nssg-actions-container .nssg-action-invoke").click
                    sleep 1
                end
                number2-=1
            end
        end
        it "Go to the administrators tab on the slide-out window" do
            sleep 1
            @ui.click('#accountdetails_tab_clients')
            sleep 1
        end
        it "Set the following values: #{first_name} + #{last_name} + #{email} and create a new Administrator on #{domain_name} having the role #{role}" do
            sleep 1
            @ui.click('#accountdetails_new_admin')
            sleep 1
            @ui.click('.slideout-overlay-form .inner .clearfix .orange')
            expect(@browser.url).to include("/#msp/accounts")
            sleep 1
            @ui.set_input_val('#msp-users-firstname',first_name)
            #@ui.set_input_val('.ko_slideout_container .tab_contents .xc-field:first-child > input', first_name)
            sleep 1
            @ui.set_input_val('#msp-users-lastname',last_name)
            #@ui.set_input_val('.ko_slideout_container .tab_contents .xc-field:nth-child(2) > input', last_name)
            sleep 1
            @ui.set_input_val('#msp-users-email',email)
            #@ui.set_input_val('.ko_slideout_container .tab_contents .xc-field:nth-child(3) > input', email)
            sleep 1
            @ui.set_dropdown_entry('msp-users-roles',role)
            sleep 1
            @ui.click('#msp-users-addaccount')
            sleep 1
            number = 1
            bool = false
            while (bool != true) do
                if (@ui.css(".ko_slideout_container .tab_contents .nssg-table tbody tr:nth-child(#{number}) td:nth-child(3)").text == email)
                    sleep 1
                    bool = true
                    expect(@ui.css(".ko_slideout_container .tab_contents .nssg-table tbody tr:nth-child(#{number}) td:nth-child(2)").text).to eq(first_name + " " + last_name)
                    expect(@ui.css(".ko_slideout_container .tab_contents .nssg-table tbody tr:nth-child(#{number}) td:nth-child(3)").text).to eq(email)
                    expect(@ui.css(".ko_slideout_container .tab_contents .nssg-table tbody tr:nth-child(#{number}) td:nth-child(4)").text).to eq(role)
                end
                number+=1
            end
            sleep 1
            if @ui.id('confirmButtons').exists?
                @ui.click('#_jq_dlg_btn_1')
            end
        end
        it "Save the user" do
            sleep 1
            @ui.click('#accountdetails_save')
            sleep 2
            if @ui.css('.loading').exists?
                @ui.css('.loading').wait_while_present
            end
        end
        it "Open the Administrator and verify the domain as #{domain_name} and role as #{role}" do
            @ui.click('#msp_tab_users')
            sleep 2
            @ui.grid_action_on_specific_line("4", "div", email, "invoke")
            sleep 1
            @ui.click('#accountdetails_tab_general')
            @ui.click('#accountdetails_tab_accounts')
            expect(@ui.css(".tab_contents .nssg-table tbody tr:nth-child(1) td:nth-child(1)").text == domain_name)
            expect(@ui.css(".tab_contents .nssg-table tbody tr:nth-child(1) td:nth-child(2)").text == role)
            sleep 1
            @ui.click('#clidetails_close_btn')
        end
    end
end

shared_examples "verify that administrators and roles are correct on the domain slideout" do |domain_name, email, full_name, role| #how_many_admins
    describe "Verify that administrators and roles are correct on the domain slideout" do
        it "Open the slideout window for the domain named #{domain_name}" do
            @ui.click('#msp_tab_accounts')
            sleep 2
            @browser.refresh
            sleep 4
            @browser.execute_script('$("#suggestion_box").hide()')
            sleep 3
            @ui.css('.nssg-paging-count').wait_until_present
            abc = @ui.css('.nssg-paging-count').text

            i = abc.index('of')
            length = abc.length
            number = abc[i + 3, abc.length]
            number2 = number.to_i

            while (number2 != 0) do
                if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(2)").text == domain_name)
                    sleep 1
                    @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(2)").hover
                    sleep 1
                    @ui.css(".nssg-table tbody tr:nth-child(#{number2}) .nssg-actions-container .nssg-action-invoke").click
                    sleep 1
                end
                number2-=1
            end
        end
        it "Go to the administrators tab" do
            sleep 1
            @ui.click('#accountdetails_tab_clients')
            sleep 1
        end
        it "Verify that the grid contains the proper administrator name and proper role" do
            number_row = 1
            bool = false
            while (bool != true) do
                if (@ui.css(".ko_slideout_container .tab_contents .nssg-table tbody tr:nth-child(#{number_row}) td:nth-child(3)").text == email)
                    sleep 1
                    bool = true
                    expect(@ui.css(".ko_slideout_container .tab_contents .nssg-table tbody tr:nth-child(#{number_row}) td:nth-child(2)").text).to eq(full_name)
                    expect(@ui.css(".ko_slideout_container .tab_contents .nssg-table tbody tr:nth-child(#{number_row}) td:nth-child(3)").text).to eq(email)
                    expect(@ui.css(".ko_slideout_container .tab_contents .nssg-table tbody tr:nth-child(#{number_row}) td:nth-child(4)").text).to eq(role)
                end
                number_row+=1
            end

            #while (how_many_admins != 0) do
            #    if (@ui.css(".tab_contents .nssg-table tbody tr:nth-child(#{how_many_admins}) td:nth-child(1)").text == full_name_1)
            #        expect(@ui.css(".tab_contents .nssg-table tbody tr:nth-child(#{how_many_admins}) td:nth-child(2)").text).to eq(role_1)
            #    end
            #    if (@ui.css(".tab_contents .nssg-table tbody tr:nth-child(#{how_many_admins}) td:nth-child(1)").text == full_name_2)
            #        expect(@ui.css(".tab_contents .nssg-table tbody tr:nth-child(#{how_many_admins}) td:nth-child(2)").text).to eq(role_2)
            #    end
            #    how_many_admins-=1
            #    sleep 1
            #end
        end
    end
end

shared_examples "delete a certain Administrator" do |what_admin_should_be_deleted|
  describe "delete a certain Administrator" do
    it "Delete a certain Administrator named: #{what_admin_should_be_deleted}" do
        @ui.click('#msp_tab_accounts')
        sleep 1.5
        @browser.refresh
        sleep 3
        @browser.execute_script('$("#suggestion_box").hide()')
        sleep 1
        @ui.click('#msp_tab_users')
        sleep 1
        @ui.grid_action_on_specific_line("3", "div span:nth-child(2)", what_admin_should_be_deleted, "delete")
        sleep 1
        @ui.click('#_jq_dlg_btn_1')
    end
  end
end

#This code will
shared_examples "assign and Unassign an Array to a domain" do |array_mac, array_sn, domain_name|
    describe "edit Array" do
#        it "Assign an AP to the domain named ''#{domain_name}''" do
#            @browser.execute_script('$("#suggestion_box").hide()')
#            sleep 0.4
#            @ui.click('#msp_tab_arrays')
#            sleep 1
#            @ui.click('.tab-item-container')
#            $what_array_sn_will_be_used = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(4) div").text
#            sleep 0.4
#            @ui.grid_action_on_specific_line(4, "div", array_sn, "tick")
#            sleep 0.4
#            #@ui.click('#msp-aps-assign')
#            @ui.click('#mynetwork_arrays_moveto_btn')
#            sleep 0.4
#            @ui.set_input_val('#msp_filter_tags_input', domain_name)
#            sleep 0.4
#            @ui.css('#msp-aps-assign .drop_menu_nav .items a:first-child').hover
#            sleep 0.4
#            @ui.click('#msp-aps-assign .drop_menu_nav .items a:first-child')
#            sleep 0.4
#            @ui.click('#_jq_dlg_btn_1')
#            sleep 1
#            @ui.click('.slideout_collapse_icon')
#        end
#        it "Expect the Domain name in the grid to match the value ''#{domain_name}''" do
#            @ui.click('.nssg-paging .nssg-refresh')
#            sleep 1
#            verify_value_on_grid_cell(4, array_sn, "div", 6, "div", domain_name)
#        end
#
#        it "Unassign the AP using the grid unassign context button" do
#            @ui.click('#msp_tab_users')
#            sleep 0.4
#            @ui.click('#msp_tab_arrays')
#            sleep 0.4
#            @ui.grid_action_on_specific_line(4, "div", array_sn, "unassign")
#            sleep 0.4
#            @ui.click('#_jq_dlg_btn_1')
#        end

        it "Go to the Domains tab and open the ''#{domain_name}'' domain" do
            @ui.click('#msp_tab_accounts')
            sleep 2
            @ui.grid_action_on_specific_line(2, "div span:nth-child(2)", domain_name, "invoke")
        end

        it "Go to the AP tab on the slideout window and press the '+Assign New' button" do
            sleep 0.4
            @ui.click('#accountdetails_tab_aps')
            sleep 0.4
            @ui.click('#accountdetails_new_ap')
            expect(@browser.url).to include("/#msp/accounts")
        end

        it "Reassign the same AP to the domain named ''#{domain_name}''" do
            @browser.execute_script('$("#suggestion_box").hide()')
            sleep 1
            @ui.set_input_val('#msp-accounts-details-assignnewap-search-input', array_sn)
            sleep 0.4
            list_lenght =  @ui.css('.ko_slideout_content .msp-accounts-details-assignnewap .dual_selector .lhs.greybox .select_list .ko_container').lis.length
            while list_lenght > 0
                if @ui.css(".ko_slideout_content .msp-accounts-details-assignnewap .dual_selector .lhs.greybox .select_list .ko_container li:nth-child(#{list_lenght}) span:first-child").text == array_sn
                    @ui.css(".ko_slideout_content .msp-accounts-details-assignnewap .dual_selector .lhs.greybox .select_list .ko_container li:nth-child(#{list_lenght})").click
                    break
                end
                list_lenght -= 1
            end
            sleep 2
            @ui.click('#msp-accounts-details-assignnewap-moveall-btn')
            sleep 0.4
            @ui.click('#msp-accounts-details-assignnewap-apply-btn')
            sleep 0.4
            @ui.click('#accountdetails_save')
        end

        it "Verify that the grid shows the proper AP" do
            @ui.grid_action_on_specific_line(2, "div span:nth-child(2)", domain_name, "invoke")
            sleep 0.4
            @ui.click('#accountdetails_tab_aps')
            sleep 0.4
            expect(@ui.css(".tab_contents grid .nssg-table tbody tr:nth-child(1) td:nth-child(2)").text).to eq(array_sn)
        end

        it "Unassign the AP using the 'Unassign' button above the grid" do
            @ui.click('#msp_tab_arrays')
            sleep 0.4
            @browser.refresh
            #@browser.execute_script('$("#suggestion_box").hide()')
            sleep 1
            @ui.grid_action_on_specific_line(4, "div", array_sn, "tick")
            sleep 0.4
            @ui.click('#msp_arrays_unassign')
            sleep 0.4
            @ui.click('#_jq_dlg_btn_1')
        end

        it "Go to the Domains tab and open the ''#{domain_name}'' domain" do
            @ui.click('#msp_tab_accounts')
            sleep 2
            @ui.grid_action_on_specific_line(2, "div span:nth-child(2)", domain_name, "invoke")
        end

        it "Go to the AP tab on the slideout window and press the '+Assign New' button" do
            @ui.click('#accountdetails_tab_aps')
            sleep 0.4
            @ui.click('#accountdetails_new_ap')
            sleep 2
            expect(@browser.url).to include("/#msp/accounts")
        end

        it "Reassign the AP to the domain named ''#{domain_name}''" do
            @browser.execute_script('$("#suggestion_box").hide()')
            sleep 1
            @ui.set_input_val('#msp-accounts-details-assignnewap-search-input', array_sn)
            sleep 0.4
            list_lenght =  @ui.css('.ko_slideout_content .msp-accounts-details-assignnewap .dual_selector .lhs.greybox .select_list .ko_container').lis.length
            while list_lenght > 0
                if @ui.css(".ko_slideout_content .msp-accounts-details-assignnewap .dual_selector .lhs.greybox .select_list .ko_container li:nth-child(#{list_lenght}) span:first-child").text == $what_array_sn_will_be_used
                    @ui.css(".ko_slideout_content .msp-accounts-details-assignnewap .dual_selector .lhs.greybox .select_list .ko_container li:nth-child(#{list_lenght})").click
                    break
                end
                list_lenght -= 1
            end
            sleep 0.4
            @ui.click('#msp-accounts-details-assignnewap-moveall-btn')
            sleep 0.4
            @ui.click('#msp-accounts-details-assignnewap-apply-btn')
            sleep 0.4
            @ui.click('#accountdetails_save')
        end

        it "Verify that the ''#{domain_name}'' domain cannot be deleted while the AP is allocated + also verify the correct error message" do
            @ui.grid_action_on_specific_line(2, "div span:nth-child(2)", domain_name, "delete")
            @ui.click('#_jq_dlg_btn_1')
            sleep 0.4
            expect(@ui.css('.temperror')).to be_visible
            expect(@ui.css('.temperror .msgbody').text).to eq('Please unassign any APs associated to the domain before deletion.')
        end

        it "Open the ''#{domain_name}'' domain" do
            @ui.grid_action_on_specific_line(2, "div span:nth-child(2)", domain_name, "invoke")
        end

        it "Unassign the AP using the AP tab grid on the domain scroll out" do
            @ui.click('#accountdetails_tab_aps')
            sleep 0.4
            @ui.css(".ko_slideout_container .tab_contents .nssg-table tbody tr:nth-child(1) td:nth-child(1) .mac_chk_label").click
            sleep 0.4
            @ui.click('#msp-accountdetails-arrays-remove-btn')
            sleep 0.4
            @ui.click('#accountdetails_save')
        end

        it "Verify that the ''#{domain_name}'' domain has an AP count of '0'" do
            verify_value_on_grid_cell(2, domain_name, "div span:nth-child(2)", 3, "div", '0')
        end
    end
end

def go_trough_the_array_list_and_perform_a_certain_action(what_action, special_action, parameter_to_verify)
    abc = @ui.css('.nssg-paging-count').text
    i = abc.index('of')
    length = abc.length
    number = abc[i + 3, abc.length]
    number2 = number.to_i
    while (number2 != 0) do
        case what_action
            when "verify"
                if !@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(6)").text.include?("SELF-OWNED")
                    if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(6)").text) == parameter_to_verify
                        expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(6)").text).to eq(parameter_to_verify)
                    end
                end
            when "untick msp managed aps"
                if !@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:first-child .nssg-action-unassign").exists?
                    # if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:first-child .nssg-action-unassign").attribute_value("class")).include? parameter_to_verify
                        @ui.click(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(2) input + .mac_chk_label")
                    # end
                end
            when "untick non msp managed aps"
                if @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:first-child .nssg-action-unassign").exists?
                    # if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:first-child .nssg-action-unassign").attribute_value("class")).include? parameter_to_verify
                        @ui.click(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(2) input + .mac_chk_label")
                    # end
                end
            end
        sleep 1
        number2-=1
    end
end
shared_examples "assign and Unassign several Switches to a domain" do |domain_name, what_part|
    describe "assign and Unassign several switches to a domain" do
        it "Go to the Switches tab" do
            @browser.execute_script('$("#suggestion_box").hide()')
            sleep 1
            @ui.click('#msp_tab_switches')
            sleep 5
            @ui.css('.tab-item-container .commonTitle span').wait_until_present
            @ui.click('.tab-item-container .commonTitle span')
            sleep 1
        end
        it "Set the view mode to '100' entries per page" do
            @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "100")
        end
        if what_part == "Assign" or what_part == "Both"
            it "Assign all available Switches to the #{domain_name} domain" do
                @ui.css(".nssg-table thead tr:nth-child(1) th:nth-child(2) .mac_chk_label").click
                sleep 1
                go_trough_the_array_list_and_perform_a_certain_action("untick non msp managed aps", nil, "disabled")
                sleep 1
                @ui.click('#msp_switches_assign')
                sleep 1
                @ui.css('#msp_switches_assign .move_to_nav .items a:last-child').hover
                @ui.css('#msp_switches_assign .move_to_nav .items a:last-child').click
                sleep 1
                @ui.click('#_jq_dlg_btn_1')
            end
            it "Verify that all switches show the domain name as #{domain_name}" do
                go_trough_the_array_list_and_perform_a_certain_action("verify", nil, domain_name)
                @browser.refresh
            end
        end
        if what_part == "Unassign" or what_part == "Both"
            it "Unassign all available switches to the #{domain_name} domain" do
                @ui.css(".nssg-table thead tr:nth-child(1) th:nth-child(2) .mac_chk_label").click
                sleep 1
                go_trough_the_array_list_and_perform_a_certain_action("untick non msp managed aps", nil, "disabled")
                sleep 1
                @ui.click('#msp_switches_unassign')
                sleep 1
                @ui.click('#_jq_dlg_btn_1')
            end
            it "Verify that all switches's show the domain name as 'Unassigned'" do
                go_trough_the_array_list_and_perform_a_certain_action("verify", nil, "Unassigned")
            end
            it "Assign only one Switch to the #{domain_name} domain" do
                @ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(2) .mac_chk_label").click
                sleep 1
                @ui.click('#msp_switches_assign')
                sleep 1
                @ui.css('#msp_switches_assign .move_to_nav .items a:last-child').hover
                @ui.css('#msp_switches_assign .move_to_nav .items a:last-child').click
                sleep 1
                @ui.click('#_jq_dlg_btn_1')
                sleep 2
                @browser.refresh
            end
            it "Select all entries in the grid" do
                @ui.css(".nssg-table thead tr:nth-child(1) th:nth-child(2) .mac_chk_label").click
                sleep 1
            end
            it "Ensure that the assign button is visible but grayed out and that the unassign button is visible and works" do
                expect(@ui.css('#msp_switches_unassign')).to be_visible
                expect(@ui.css('#msp_switches_assign')).to be_visible
                sleep 1
                @ui.css('#msp_switches_assign').hover
                sleep 1
                # expect(@ui.css('.ko_tooltip_active')).to be_visible
                # sleep 1
                @ui.click('#msp_switches_assign')
                expect(@ui.css('.move_to_nav')).not_to be_visible
                sleep 1
                @ui.click('#msp_switches_unassign')
                sleep 1
                @ui.click('#_jq_dlg_btn_1')
            end
            it "Verify that all Switches show the domain name as 'Unassigned'" do
                go_trough_the_array_list_and_perform_a_certain_action("verify", nil, "Unassigned")
            end
            it "Set the view mode to '10' entries per page" do
                @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "10")
            end
        end
    end
end

shared_examples "assign and Unassign several arrays to a domain" do |domain_name, what_part|
    describe "assign and Unassign several arrays to a domain" do
        it "Go to the Access Points tab" do
            @browser.execute_script('$("#suggestion_box").hide()')
            sleep 1
            @ui.click('#msp_tab_arrays')
            sleep 5
            @ui.css('.tab-item-container .commonTitle span').wait_until_present
            @ui.click('.tab-item-container .commonTitle span')
            sleep 1
        end
        it "Set the view mode to '100' entries per page" do
            @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "100")
        end
        if what_part == "Assign" or what_part == "Both"
            it "Assign all available arrays to the #{domain_name} domain" do
                @ui.css(".nssg-table thead tr:nth-child(1) th:nth-child(2) .mac_chk_label").click
                sleep 1
                go_trough_the_array_list_and_perform_a_certain_action("untick non msp managed aps", nil, "disabled")
                sleep 1
                @ui.click('#msp_arrays_assign')
                sleep 1
                @ui.css('#msp_arrays_assign .move_to_nav .items a:last-child').hover
                @ui.css('#msp_arrays_assign .move_to_nav .items a:last-child').click
                sleep 1
                @ui.click('#_jq_dlg_btn_1')
            end
            it "Verify that all AP's show the domain name as #{domain_name}" do
                go_trough_the_array_list_and_perform_a_certain_action("verify", nil, domain_name)
                @browser.refresh
            end
        end
        if what_part == "Unassign" or what_part == "Both"
            it "Unassign all available arrays to the #{domain_name} domain" do
                @ui.css(".nssg-table thead tr:nth-child(1) th:nth-child(2) .mac_chk_label").click
                sleep 1
                go_trough_the_array_list_and_perform_a_certain_action("untick msp managed aps", nil, "disabled")
                sleep 1
                @ui.click('#msp_arrays_unassign')
                sleep 1
                @ui.click('#_jq_dlg_btn_1')
            end
            it "Verify that all AP's show the domain name as 'Unassigned'" do
                go_trough_the_array_list_and_perform_a_certain_action("verify", nil, "Unassigned")
            end
            it "Assign only one AP to the #{domain_name} domain" do
                @ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(2) .mac_chk_label").click
                sleep 1
                @ui.click('#msp_arrays_assign')
                sleep 1
                @ui.css('#msp_arrays_assign .move_to_nav .items a:last-child').hover
                @ui.css('#msp_arrays_assign .move_to_nav .items a:last-child').click
                sleep 1
                @ui.click('#_jq_dlg_btn_1')
                sleep 2
                @browser.refresh
            end
            it "Select all entries in the grid" do
                @ui.css(".nssg-table thead tr:nth-child(1) th:nth-child(2) .mac_chk_label").click
                sleep 1
                # go_trough_the_array_list_and_perform_a_certain_action("untick non msp managed aps", nil, "disabled")
                # sleep 1
            end
            it "Ensure that the assign button is visible but grayed out and that the unassign button is visible and works" do
                expect(@ui.css('#msp_arrays_unassign')).to be_visible
                expect(@ui.css('#msp_arrays_assign')).to be_visible
                sleep 1
                @ui.css('#msp_arrays_assign').hover
                sleep 1
                # expect(@ui.css('.ko_tooltip_active')).to be_visible
                # sleep 1
                @ui.click('#msp_arrays_assign')
                expect(@ui.css('.move_to_nav')).not_to be_visible
                sleep 1
                @ui.click('#msp_arrays_unassign')
                sleep 1
                @ui.click('#_jq_dlg_btn_1')
            end
            it "Verify that all AP's show the domain name as 'Unassigned'" do
                go_trough_the_array_list_and_perform_a_certain_action("verify", nil, "Unassigned")
            end
            it "Set the view mode to '10' entries per page" do
                @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "10")
            end
        end
    end
end

shared_examples "export all access points" do
    describe "Export all the available Access Points" do
        it "Go to the Access Points tab" do
            @ui.click('#msp_tab_arrays')
            sleep 1
        end
        it "Press the 'Export All' button" do
            sleep 1
            @ui.click('#mn-cl-export-btn')
            sleep 1
        end
        it "Verify that the exported file exists, it contains the MAC addresses of all three APs and can be deleted" do
            ap_one = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(3)").text
            ap_two = @ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(3)").text
            ap_three = @ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(3)").text

            fname = @download + "/CommandCenterAccessPoints-" + (Date.today.to_s) + ".csv"
            file = File.open(fname, "r")
            data = file.read
            file.close

            sleep 1
            expect(data.include?(ap_one)).to eq(true)
            expect(data.include?(ap_two)).to eq(true)
            expect(data.include?(ap_three)).to eq(true)

            sleep 1
            File.delete(@download + "/CommandCenterAccessPoints-" + (Date.today.to_s) + ".csv")
        end
    end
end

# US5132 - CC Dashboard | Export to excel
shared_examples "export msp domains groups" do |verified_parameters|
    describe "Export available settings for CommandCenter Domains" do
        if verified_parameters != nil
            it "Press the 'Export All' button" do
                if @browser.url.include?("/#mynetwork/aps/groups")
                    @ui.css('#groups-export-btn').wait_until_present
                    @ui.click('#groups-export-btn')
                else
                    @ui.css('#msp-export-btn').wait_until_present
                    @ui.click('#msp-export-btn')
                end
                sleep 1
            end
            it "Verify that the exported file exists and it contains the needed details" do
                if @browser.url.include?("/#mynetwork/aps/groups")
                    fname = @download + "/APGroupSummaries-" + (Date.today.to_s) + ".csv"\
                else
                    fname = @download + "/CommandCenterSummaries-" + (Date.today.to_s) + ".csv"\
                end
                file = File.open(fname, "r")
                data = file.read
                file.close
                sleep 1
                verified_parameters.each do |key, value|
                    value.each do |single_val|
                        expect(data.include?(single_val)).to eq(true)
                    end
                end
                sleep 1
                if @browser.url.include?("/#mynetwork/aps/groups")
                    File.delete(@download + "/APGroupSummaries-" + (Date.today.to_s) + ".csv")
                else
                    File.delete(@download + "/CommandCenterSummaries-" + (Date.today.to_s) + ".csv")
                end
            end
        else
            it "Verfiy that the 'Export' button isn't visible" do
                if @browser.url.include?("/#mynetwork/aps/groups")
                    expect(@ui.css('#groups-export-btn')).not_to be_visible
                else
                    @ui.click('#msp_tab_dashboard')
                    sleep 3
                    @browser.refresh
                    sleep 5
                    expect(@ui.css('#msp-export-btn')).not_to be_visible
                end
            end
        end
    end
end

#WIP - view edit administrator details - domains tab
shared_examples "delete a certain Domain" do |what_domain_should_be_deleted|
  describe "delete a certain Domain" do
    it "Delete a certain Domain named: #{what_domain_should_be_deleted}" do

        @browser.execute_script('$("#suggestion_box").hide()')

        abc = @ui.css('.nssg-paging-count').text

        i = abc.index('of')
        length = abc.length
        number = abc[i + 3, abc.length]
        number2 = number.to_i

        while (number2 != 0) do
            #if (!@ui.css(".nssg-table tbody tr:nth-child(#{i}) td:nth-child(3)").text.strip != "adinte+automation@macadamian.com")
            if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(2)").text == what_domain_should_be_deleted)
                sleep 1
                @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(2)").hover
                sleep 1
                @ui.css(".nssg-table tbody tr:nth-child(#{number2}) .nssg-actions-container .nssg-action-delete").click
                sleep 1
                @ui.click('#_jq_dlg_btn_1')
                sleep 1
            end
            number2-=1
        end

    end
  end
end

shared_examples "verify the users filter" do |role, user_name|
    describe "Verify that the user's filter works properly" do
        it "Go to the Users tab" do
            @ui.click('#msp_tab_users')
            sleep 1
        end
        it "Ensure that the user's filter value is set to '#{role}'" do
            @ui.set_dropdown_entry('msp-users-filter', role)
            sleep 1
        end
        it "Ensure that the user #{user_name} is displayed in the grid" do
            abc = @ui.css('.nssg-paging-count').text

            i = abc.index('of')
            length = abc.length
            number = abc[i + 3, abc.length]
            number2 = number.to_i

            while (number2 != 0) do
                if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3)").text == user_name)
                    expect(@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3)").text).to eq(user_name)
                else
                    puts "Move to the next user"
                end
                sleep 1
                number2-=1
            end
        end
    end
end


# **********************************************************************************
# **************************** NEGATIVE TESTING ************************************
# **********************************************************************************

shared_examples "error message on create domain" do
  describe "Error message on create domain" do
    it "Verify that the user receives the proper error message when not setting a name for a domain " do
        @browser.execute_script('$("#suggestion_box").hide()')
        @ui.click('#msp_tab_accounts')
        sleep 1
        @ui.click('#msp-newacct-btn')
        sleep 1
        @ui.click('#accountdetails_save')
        sleep 1
        expect(@ui.css('.msgbody').text).to eq("Please enter a domain name")
        sleep 1
        @ui.click('#accountdetails_close_btn')
        sleep 5
    end
  end
end

shared_examples "error messages on create administrator" do
    describe "Error messages on create administrator" do
        it "Go to Administrators tab and open a New Administrator slideout window" do
            sleep 1
            @ui.click('#msp_tab_users')
            sleep 1
            @browser.execute_script('$("#suggestion_box").hide()')
            sleep 1
            @ui.click('#msp-users-new')
            sleep 2
        end
        it "Verify the 'Please enter a first name, last name and valid email' error message" do
            @ui.click('#accountdetails_tab_general')
            sleep 1
            @ui.click('#msp-users-save')
            sleep 2
            expect(@ui.css('.msgbody').text).to eq("Please enter a first name, last name and valid email")
            sleep 4
        end
        it "Enter First Name value and verify error message" do
            @ui.click('#accountdetails_tab_general')
            sleep 1
            @ui.set_input_val('#msp-users-firstname', "First Name")
            sleep 1
            @ui.click('#msp-users-save')
            sleep 2
            expect(@ui.css('.msgbody').text).to eq("Please enter a first name, last name and valid email")
            sleep 4
        end
        it "Enter Last Name value and verify error message" do
            @ui.click('#accountdetails_tab_general')
            sleep 1
            @ui.set_input_val('#msp-users-lastname', "Last Name")
            sleep 1
            @ui.click('#msp-users-save')
            sleep 2
            expect(@ui.css('.msgbody').text).to eq("Please enter a first name, last name and valid email")
            sleep 4
        end
        it "Enter improper email and verify the error messages" do
            @ui.click('#accountdetails_tab_general')
            sleep 2
            @ui.set_input_val('#msp-users-email', "email")
            sleep 2
            @ui.click('#msp-users-save')
            sleep 2
            expect(@ui.css('.msgbody').text).to eq("Please enter a first name, last name and valid email")
            #expect(@ui.css('.xirrus-error').text).to eq("Please enter a valid email.")
            sleep 4
        end
        it "Enter valid email and verify the error message displayed is 'Please assign the user to one or more domains'" do
            @ui.click('#accountdetails_tab_general')
            sleep 1
            @ui.set_input_val('#msp-users-email', "email@email.com")
            sleep 1
            @ui.click('#msp-users-save')
            sleep 2
            expect(@ui.css('.msgbody').text).to eq("Please assign the user to one or more domains")
            sleep 5
            @ui.click('#clidetails_close_btn')
            sleep 1
            @ui.click('#_jq_dlg_btn_0')
            sleep 2
        end
    end
end

shared_examples "create admin from admin tab with the same email address as a previous admin and verify the proper domains" do |existing_domain, new_domain_name, first_name, last_name, email|
    describe "create administrator from administrators tab with the same email address as a previous account" do
        it "Go to the Administrators tab" do
            sleep 1
            @ui.click('#msp_tab_accounts')
            sleep 3
            @ui.click('#msp_tab_users')
            @browser.execute_script('$("#suggestion_box").hide()')
            sleep 1
            @ui.click('#msp-users-new')
            sleep 1
        end
        it "Set the following values: #{first_name} + #{last_name} + #{email}" do
            @ui.click('#accountdetails_tab_general')
            sleep 1
            @ui.set_input_val('#msp-users-firstname',first_name)
            #@ui.set_input_val('.ko_slideout_container .tab_contents .xc-field:first-child > input', first_name)
            sleep 1
            @ui.set_input_val('#msp-users-lastname',last_name)
            #@ui.set_input_val('.ko_slideout_container .tab_contents .xc-field:nth-child(2) > input', last_name)
            sleep 1
            @ui.set_input_val('#msp-users-email',email)
            #@ui.set_input_val('.ko_slideout_container .tab_contents .xc-field:nth-child(3) > input', email)
            sleep 1
        end
        it "Go to the Domains tab and add to the domain: #{new_domain_name}" do
           @ui.click('#accountdetails_tab_accounts')
           sleep 1
           @ui.click('#msp-users-addtoaccount')
           sleep 1
           @ui.set_dropdown_entry('msp-users-accounts', new_domain_name)
           sleep 1
            @ui.click('#msp-users-addaccount')
        end
        it "Save the user" do
            sleep 1
            @ui.click('#msp-users-save')
            sleep 3
            @ui.click('.nssg-paging .nssg-refresh')
        end
        it "Verify that the existing user '#{first_name} '#{last_name}' with the email '#{email}' now has the domains: '#{existing_domain}' and '#{new_domain_name}'" do
            verify_value_on_grid_cell(4, email, "div", 5, ".nssg-td-text", Array[new_domain_name, existing_domain])
        end
    end
end

shared_examples "remove a user from a domain" do |email, domain, remaining_domain|
    describe "Remove the user with the email '#{email}' from the domain named '#{domain}' and ensure the '#{remaining_domain}' clearence has not been changed" do
        it "Go to the Users tab" do
            @ui.click('#msp_tab_users')
            sleep 1
            @ui.click('.nssg-paging .nssg-refresh')
        end
        it "Verify that the user with the email '#{email}' has the domains: '#{domain}' and '#{remaining_domain}'" do
            verify_value_on_grid_cell(4, email, "div", 5, "div", domain + ", " + remaining_domain)
        end
        it "Open the slideout window for the user with the email '#{email}'" do
            @ui.grid_action_on_specific_line(4, "div", email, "invoke")
        end
        it "Go to the Domains tab and verify that the table exists and there are two domains assigned" do
            @ui.click('#accountdetails_tab_accounts')
            sleep 0.5
            expect(@ui.css('.tab_contents grid .nssg-container .nssg-table')).to exist
            expect(@ui.css('.tab_contents grid .nssg-container .nssg-table')).to be_visible
            grid_length = @ui.css(".tab_contents grid .nssg-container .nssg-table .nssg-tbody")
            grid_length.wait_until_present
            expect(grid_length.trs.length).to eq(2)
            $grid_length_global = grid_length.trs.length
        end
        it "Remove the '#{domain}' entry in the grid and verify the grid length is '1'" do
            while ($grid_length_global != 0) do
                if (@ui.css(".tab_contents grid .nssg-container .nssg-table tbody tr:nth-child(#{$grid_length_global}) td:nth-child(2)").text == domain)
                    sleep 1
                    @ui.css(".tab_contents grid .nssg-container .nssg-table tbody tr:nth-child(#{$grid_length_global}) td:nth-child(2)").hover
                    sleep 1
                    @ui.css(".tab_contents grid .nssg-container .nssg-table tbody tr:nth-child(#{$grid_length_global}) .nssg-actions-container .nssg-action-delete").click
                end
            $grid_length_global-=1
            end
            sleep 1
            @ui.click('#_jq_dlg_btn_1')
            sleep 1
            grid_length = @ui.css(".tab_contents grid .nssg-container .nssg-table .nssg-tbody")
            grid_length.wait_until_present
            expect(grid_length.trs.length).to eq(1)
        end
        it "Press the <SAVE> button" do
            @ui.click('#msp-users-save')
            sleep 1
            expect(@ui.css('.dialogOverlay.temperror').exists?).to eq(false)
        end
        it "Verify that the Users tab grid shows the user '#{email}' with the domain value of '#{remaining_domain}'" do
            if @ui.css('.tabpanel_slideout.opened').exists?
                @ui.click('#clidetails_close_btn')
                sleep 0.5
                if @ui.css('.dialogOverlay.confirm').exists?
                    @ui.click('#_jq_dlg_btn_0')
                end
            end
            sleep 1.5
            @ui.click('.nssg-paging .nssg-refresh')
            sleep 0.6
            verify_value_on_grid_cell(4, email, "div", 5, "div", remaining_domain)
        end
    end
end

shared_examples "edit an admin and set a previously used email" do |domain_name, first_name, last_name, email, email_edited|
    describe "Edit an admin and set a previously used email" do
        it "Go to the Administrators tab" do
            @browser.execute_script('$("#suggestion_box").hide()')
            @ui.click('#msp_tab_users')
            sleep 1
            @ui.click('.nssg-paging .nssg-refresh')
        end
        it "Find the administrator #{first_name} #{last_name} and open it" do
            @ui.grid_action_on_specific_line(4, "div", email, "invoke")
        end
        it "Change the email address to #{email_edited}" do
            @ui.click('#accountdetails_tab_general')
            sleep 2
            @ui.set_input_val('#msp-users-email', email_edited)
        end
        it "Press the <SAVE> button" do
            @ui.click('#msp-users-save')
        end
        it "Verify that the error message is properly displayed and has the text: 'Could not save the user.'" do
            expect(@ui.css('.dialogOverlay.temperror').exists?).to eq(true)
            expect(@ui.css('.dialogOverlay.temperror .title').text).to eq('Save Failed')
            #expect(@ui.css('.dialogOverlay.temperror .title').text).to eq('The user already exists in this tenant family')
        end
        it "Verify that the Users tab grid shows the user '#{email}' with the domain value of '#{domain_name}'" do
            if @ui.css('.tabpanel_slideout.opened').exists?
                @ui.click('#clidetails_close_btn')
                sleep 0.5
                if @ui.css('.dialogOverlay.confirm').exists?
                    @ui.click('#_jq_dlg_btn_0')
                end
            end
            sleep 1.5
            @ui.click('.nssg-paging .nssg-refresh')
            sleep 0.6
            verify_value_on_grid_cell(4, email, "div", 5, "div", domain_name)
        end
        it "Verify that the Users tab grid shows the user '#{email_edited}' with the domain value of 'Negative testing'" do
            @ui.click('.nssg-paging .nssg-refresh')
            sleep 0.6
            verify_value_on_grid_cell(4, email_edited, "div", 5, "div", "Negative testing")
            #verify_value_on_grid_cell(4, email_edited, "div", 5, "div", "Negative testing 2, Negative testing")
        end
    end
end

shared_examples "scope to tenant" do |tenant_name|
    describe "Scope to the tenant named '#{tenant_name}'" do
        it "Open the tenant scope dropdown and select the proper tenant" do
            @ui.change_tenant(tenant_name)
        end
    end
end

shared_examples "scope to parent tenant" do
    describe "Scope to the Parent tenant" do
        it "Open the scope dropdown and select the Parent tenant" do
            @ui.click('#tenant_scope_options .arrow')
            @ui.css('.ko_dropdownlist_list.active ul').wait_until_present
            @ui.click('.ko_dropdownlist_list.active ul li:first-child span')
            sleep 4
        end
    end
end

shared_examples "manage specific domain" do |domain_name|
    describe "Open the domain '#{domain_name}' using the 'Manage Domain' context button from the grid" do
        it "Go to the Domains tab" do
            @ui.click('#msp_tab_accounts')
        end
        it "Hover over the domain named '#{domain_name}' and press the 'Manage' button" do
            @ui.grid_action_on_specific_line(2, "div span:nth-child(2)", domain_name, "scope")
            sleep 2
        end
        it "Verify that the domain dropdown list shows the tenant as '#{domain_name}'" do
            expect(@ui.css('#tenant_scope_options a span:first-child').text).to eq(domain_name)
        end
    end
end

shared_examples "deploy profile to a domain from profiles landing page - verify the deploy modal" do |profile_name, domain_name|
    describe "Deploy the profile named '#{profile_name}' to the domain named '#{domain_name}' by using the profiles landing page context buttons (verify the deploy modal content and functionality)" do
        it "Go to the profiles landing page" do
            @ui.view_all_profiles
        end
        it "Hover over the '#{profile_name}' Profile's tile to reveal overlay buttons and press the 'Deploy to Domain' button" do
            hover_over_tile_and_press_deploy_button("Profiles", profile_name)
        end
        it "Verify that the 'Deploy to Domain' modal is displayed " do
            verify_the_deploy_to_domain_modal_contents("Profiles", profile_name)
        end
        it "Change the 'Domain' option to '#{domain_name}'" do
            @ui.set_dropdown_entry('profile_location_input', domain_name)
        end
        it "Press the <DEPLOY> button and verify the deploy message is 'Profile was successfully deployed.' and that the grid still shows the Profile named '#{profile_name}'" do
            @ui.click('#profiles_profiledeploy .buttons .button.orange')
            sleep 3
            profile_found = verify_that_a_tile_is_present("Profiles", profile_name)
            expect(profile_found).to eq(true)
        end
    end
end

shared_examples "verify landing page deployed element" do |profiles_portals, searched_name|
    describe "Verify that the '#{profiles_portals}' area contains the element '#{searched_name}'" do
        if profiles_portals == "Profiles"
            it "Go to the '#{profiles_portals}' landing page" do
                @ui.view_all_profiles
            end
        elsif profiles_portals == "Portals"
            it "Go to the '#{profiles_portals}' landing page" do
                @ui.goto_all_guestportals_view
            end
        end
        it "Verify that the tile is properly present in the grid" do
            found = verify_that_a_tile_is_present(profiles_portals, searched_name)
            expect(found).to eq(true)
        end
    end
end

shared_examples "deploy portal facebook not possible" do |portal_name|
    describe "Verify that the portal named '#{portal_name}' of type FACEBOOK cannot be deployed" do
        it "Go to the portals landing page" do
            @ui.goto_all_guestportals_view
        end
        it "Hover over the '#{portal_name}' Portal's tile to reveal overlay buttons and press the 'Deploy to Domain' button" do
            hover_over_tile_and_verify_deploy_button_hidden("Portals", portal_name)
        end
        it "Go into the profile and verify that the tools dropdown menu does not show the 'Deploy to Domain' option" do
            navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
            sleep 2
             @ui.click('#profile_menu_btn')
            sleep 0.5
            deploy_to_domain_option = @ui.css('#guestportal_deploy_btn')
            expect(deploy_to_domain_option).not_to be_visible
            expect(deploy_to_domain_option.attribute_value("style")).to eq("display: none;")
        end
    end
end

shared_examples "deploy a portal to a domain and verify that the portal configurations are copied" do |portal_name, portal_type, what_tab, what_to_verify, verify_value|
    describe "Once the portal '#{portal_name}' was deployed to a new domain, verify that the portal's configurations were properly copied along side it" do
        it "Go to the '#{portal_name}' portal" do
            navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,true)
        end
        if what_tab == "General"
            it "Go to the 'General' tab" do
                @ui.click('#guestportal_config_tab_general')
                sleep 2
                expect(@browser.url).to include("/general")
            end
            case what_to_verify
                when "Description"
                    it "Verify the '#{what_to_verify}' text area has the value '#{verify_value}'" do
                        expect(@ui.get(:textarea, {id: 'guestportal_config_basic_description'}).value).to eq(verify_value)
                    end
                when "Landing Page"
                    it "Verify the '#{what_to_verify}' inputbox has the value '#{verify_value}'" do
                        expect(@ui.get(:input, {id: 'landingpage'}).value).to eq(verify_value)
                    end
                when "Login Domain"
                    it "Verify the '#{what_to_verify}' grid has the value '#{verify_value}'" do
                        expect(@ui.get(:span, {css: '#guestportal_config_general_domain .whitelist_record'}).text).to eq(verify_value)
                    end
            end
        elsif what_tab == "Look & Feel"
            it "Go to the 'L:ook & Feel' tab" do
                @ui.click('#guestportal_config_tab_lookfeel')
                sleep 2
                expect(@browser.url).to include("/lookfeel")
            end
            case what_to_verify
                when "Company Name"
                    it "Verify the '#{what_to_verify}' inputbox has the value '#{verify_value}'" do
                        expect(@ui.get(:input, {id: 'guestportal_config_lookfeel_companyname'}).value).to eq(verify_value)
                    end
                when "Show Powered by Xirrus"
                    it "Verify the '#{what_to_verify}' checkbox has the value '#{verify_value}'" do
                        expect(@ui.get(:checkbox, {id: 'poweredByXirrus'}).set?).to eq(verify_value)
                    end
            end
        end
    end
end

shared_examples "deploy a portal to a domain and verify that the portal records are not copied" do |portal_name, second_tab|
    describe "Once the portal '#{portal_name}' was deployed to a new domain, verify that the portal's records were not copied along side it" do
        it "Go to the '#{portal_name}' portal" do
            navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,true)
        end
        it "Go to the SSIDs tab and verify no records exist" do
            @ui.click('#guestportal_config_tab_ssids')
            sleep 3
            expect(@browser.url).to include("/config/ssids")
            expect(@ui.css('.nssg-table')).to be_present
            expect(@ui.css('.nssg-table .nssg-thead')).to be_present
            expect(@ui.css('.nssg-table .nssg-tbody').trs.length).to eq(0)
        end
        if second_tab == true
            it "Go to the Users/Guests/Vouchers tab and verify no recors exist" do
                @ui.click('#profile_tabs a:nth-child(2)')
                sleep 3
                expect(@ui.css('#profile_tabs a:nth-child(2)').attribute_value("class")).to eq("selected")
                expect(@ui.css('.nssg-table')).to be_present
                expect(@ui.css('.nssg-table .nssg-thead')).to be_present
                expect(@ui.css('.nssg-table .nssg-tbody').trs.length).to eq(0)
            end
        end
    end
end

shared_examples "deploy portal to a domain from portals landing page - verify the deploy modal" do |portal_name, domain_name|
    describe "Deploy the portal named '#{portal_name}' to the domain named '#{domain_name}' by using the portals landing page context buttons (verify the deploy modal content and functionality)" do
        it "Go to the portals landing page" do
            @ui.goto_all_guestportals_view
        end
        it "Hover over the '#{portal_name}' Portal's tile to reveal overlay buttons and press the 'Deploy to Domain' button" do
            hover_over_tile_and_press_deploy_button("Portals", portal_name)
        end
        it "Verify that the 'Deploy to Domain' modal is displayed " do
            verify_the_deploy_to_domain_modal_contents("Portals", portal_name)
        end
        it "Change the 'Domain' option to '#{domain_name}'" do
            @ui.set_dropdown_entry('guestportals-deploy-domain-list', domain_name)
        end
        it "Press the <DEPLOY> button and verify the deploy message is 'EasyPass Portal was successfully deployed.' and that the grid still shows the Profile named '#{portal_name}'" do
            @ui.click('#guestportals-deploy-submit')
            @ui.css('.success').wait_until_present
            expect(@ui.css('.success .msgbody div').text).to eq("EasyPass Portal was successfully deployed.")
            sleep 3
            portal_found = verify_that_a_tile_is_present("Portals", portal_name)
            expect(portal_found).to eq(true)
        end
    end
end

shared_examples "deploy portal to a domain from portals landing page - verify the duplicate error message" do |portal_name, domain_name|
     describe "Deploy the portal named '#{portal_name}' to the domain named '#{domain_name}' by using the portals landing page context buttons (verify the user properly received an error message)" do
         it "Go to the portals landing page" do
            @ui.goto_all_guestportals_view
        end
        it "Hover over the '#{portal_name}' Portal's tile to reveal overlay buttons and press the 'Deploy to Domain' button" do
            hover_over_tile_and_press_deploy_button("Portals", portal_name)
        end
        it "Verify that the 'Deploy to Domain' modal is displayed " do
            verify_the_deploy_to_domain_modal_contents("Portals", portal_name)
        end
        it "Change the 'Domain' option to '#{domain_name}'" do
            @ui.set_dropdown_entry('guestportals-deploy-domain-list', domain_name)
        end
         it "Press the <DEPLOY> button and verify the error message is 'Portal name already exists for the selected domain. Please enter a different name.' and that the grid still shows the Profile named '#{portal_name}'" do
            @ui.click('#guestportals-deploy-submit')
            @ui.css('.temperror').wait_until_present
            expect(@ui.css('.success')).not_to exist
            expect(@ui.css('.temperror .msgbody div').text).to eq("Portal name already exists for the selected domain. Please enter a different name.")
            sleep 3
            portal_found = verify_that_a_tile_is_present("Portals", portal_name)
            expect(portal_found).to eq(true)
        end
     end
end

shared_examples "deploy portal to a domain from inside portal - verify the deploy modal" do |portal_name, domain_name|
    describe "Deploy the portal named '#{portal_name}' to the domain named '#{domain_name}' by using the options dropdown list from within the portal (verify the deploy modal content and functionality)" do
        it "Go to the portal named '#{portal_name}'" do
            navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
        end
        it "Open the tools dropdown menu and verify that the 'Deploy to Domain' options is displayed" do
            @ui.click('#profile_menu_btn')
            sleep 0.5
            deploy_to_domain_option = @browser.a(:text => 'Deploy to Domain')
            expect(deploy_to_domain_option).to be_visible
            expect(deploy_to_domain_option.attribute_value("class")).to eq("nav_item")
            expect(deploy_to_domain_option.text).to eq("Deploy to Domain")
            deploy_to_domain_option.click
        end
        it "Verify that the 'Deploy to Domain' modal is displayed " do
            verify_the_deploy_to_domain_modal_contents("Portals", portal_name)
        end
        it "Change the 'Domain' option to '#{domain_name}'" do
            @ui.set_dropdown_entry('guestportals-deploy-domain-list', domain_name)
        end
        it "Press the <DEPLOY> button and verify the deploy message is 'Profile was successfully deployed.' and that the grid still shows the Profile named '#{portal_name}'" do
            @ui.click('#guestportals-deploy-submit')
            sleep 3
            @ui.goto_all_guestportals_view
            sleep 2
            found = verify_that_a_tile_is_present("Portals", portal_name)
            expect(found).to eq(true)
        end
    end
end

shared_examples "deploy profile to a domain from profiles landing page - using as default" do |profile_name, domain_name|
    describe "Deploy the profile named '#{profile_name}' to the domain named '#{domain_name}' by using the profiles landing page context buttons (verify the deploy modal content and functionality)" do
        it "Go to the profiles landing page" do
            @ui.view_all_profiles
        end
        it "Hover over the '#{profile_name}' Profile's tile to reveal overlay buttons and press the 'Deploy to Domain' button" do
            hover_over_tile_and_press_deploy_button("Profiles", profile_name)
        end
        it "Verify that the 'Deploy to Domain' modal is displayed " do
            verify_the_deploy_to_domain_modal_contents("Profiles", profile_name)
        end
        it "Change the 'Domain' option to '#{domain_name}'" do
            @ui.set_dropdown_entry('profile_location_input', domain_name)
        end
        it "Change the 'Set as Default' switch to YES" do
            @ui.click('#profiles_profiledeploy .content div:nth-child(4) .switch .switch_label')
        end
        it "Press the <DEPLOY> button and verify the deploy message is 'Profile was successfully deployed.' and that the grid still shows the Profile named '#{profile_name}'" do
            @ui.click('#profiles_profiledeploy .buttons .button.orange')
            sleep 3
            profile_found = verify_that_a_tile_is_present("Profiles", profile_name)
            expect(profile_found).to eq(true)
        end
    end
end

shared_examples "deploy profile to a domain from inside profile - verify the deploy modal" do |profile_name, domain_name|
    describe "Deploy the profile named '#{profile_name}' to the domain named '#{domain_name}' by using the options dropdown list from within the profile (verify the deploy modal content and functionality)" do
        it "Go to the profiles named '#{profile_name}'" do
            @ui.goto_profile profile_name
        end
        it "Open the tools dropdown menu and verify that the 'Deploy to Domain' options is displayed" do
            @ui.click('#profile_menu_btn')
            sleep 0.5
            deploy_to_domain_option = @browser.a(:text => 'Deploy to Domain')
            expect(deploy_to_domain_option).to be_visible
            expect(deploy_to_domain_option.attribute_value("class")).to eq("nav_item")
            expect(deploy_to_domain_option.text).to eq("Deploy to Domain")
            deploy_to_domain_option.click
        end
        it "Verify that the 'Deploy to Domain' modal is displayed " do
            verify_the_deploy_to_domain_modal_contents("Profiles", profile_name)
        end
        it "Change the 'Domain' option to '#{domain_name}'" do
            @ui.set_dropdown_entry('profile_location_input', domain_name)
        end
        it "Press the <DEPLOY> button and verify the deploy message is 'Profile was successfully deployed.' and that the grid still shows the Profile named '#{profile_name}'" do
            @ui.click('#profiles_profiledeploy .buttons .button.orange')
            sleep 3
            @ui.view_all_profiles
            sleep 2
            profile_found = verify_that_a_tile_is_present("Profiles", profile_name)
            expect(profile_found).to eq(true)
        end
    end
end

shared_examples "deploy profile to a domain from profiles landing page - verify deploy duplicate error message" do |profile_name, domain_name|
    describe "Deploy the profile named '#{profile_name}' to the domain named '#{domain_name}' by using the profiles landing page context buttons (verify the deploy modal content and functionality)" do
        it "Go to the profiles landing page" do
            @ui.view_all_profiles
        end
        it "Hover over the '#{profile_name}' Profile's tile to reveal overlay buttons and press the 'Deploy to Domain' button" do
            hover_over_tile_and_press_deploy_button("Profiles", profile_name)
        end
        it "Verify that the 'Deploy to Domain' modal is displayed " do
            verify_the_deploy_to_domain_modal_contents("Profiles", profile_name)
        end
        it "Change the 'Domain' option to '#{domain_name}'" do
            @ui.set_dropdown_entry('profile_location_input', domain_name)
        end
        it "Press the <DEPLOY> button and verify the deploy message is 'An error occurred, the deploy was not completed.' and that the 'Deploy to Domain' modal isn't closed" do
            @ui.click('#profiles_profiledeploy .buttons .button.orange')
            sleep 1
            expect(@ui.css('.dialogOverlay.temperror.top .dialogBox.temperror .title span').text).to eq('Error')
            expect(@ui.css('.dialogOverlay.temperror.top .dialogBox.temperror .msgbody div').text).to eq("A profile with the name #{profile_name} already exists.")
            sleep 3
            expect(@ui.css('#profiles_profiledeploy')).to be_visible
        end
        it "Close the 'Deploy to Domain' modal" do
            @ui.click('#profiles_profiledeploy_closemodalbtn')
            sleep 1
            expect(@ui.css('#profiles_profiledeploy')).not_to be_visible
        end
    end
end

shared_examples "ceanup on environment" do |do_not_delete_domains_array, do_not_delete_accounts|
    describe "Cleanup the environment and leave only the domain/domains: #{do_not_delete_domains_array}" do
        it "Ensure that the 'Domains' tab is displayed" do
            if !@browser.url.include?("/#msp/accounts")
                @ui.click("#msp_tab_accounts")
                sleep 2
            end
            expect(@browser.url).to include("/#msp/accounts")
        end
        it "Delete all other domains except for #{do_not_delete_domains_array}" do
            domains_grid_length = @ui.css('.nssg-table .nssg-tbody').trs.length
            while domains_grid_length > 1
                entry_name = @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{domains_grid_length}) td:nth-child(2) .nssg-td-text span:nth-child(2)").text
                found_string = false
                do_not_delete_domains_array.each do |string|
                    if entry_name.include? string
                        found_string = true
                    end
                end
                if found_string == false
                #if do_not_delete_domains_array.any? include entry_name
                    @ui.click(".nssg-table .nssg-tbody tr:nth-child(#{domains_grid_length}) td:nth-child(2) .nssg-td-text span:nth-child(2)")
                    sleep 0.5
                    @ui.click(".nssg-table .nssg-tbody tr:nth-child(#{domains_grid_length}) td:nth-child(1) .nssg-actions-container .nssg-action-delete")
                    sleep 1
                    @ui.click("#_jq_dlg_btn_1")
                    sleep 1
                end
                domains_grid_length -= 1
            end
        end
        it "Go to the 'Users' tab" do
            @ui.click("#msp_tab_users")
            sleep 2
            expect(@browser.url).to include("/#msp/users")
        end
        it "Delete all the other users except for the ones that contain the string '#{do_not_delete_accounts}'" do
            @ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
            sleep 1
            @ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "100")
            sleep 2
            users_grid_length = @ui.css('.nssg-table .nssg-tbody').trs.length
            while users_grid_length > 0
                entry_name = @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{users_grid_length}) td:nth-child(3) .nssg-td-text span:nth-child(2)").text
                if !entry_name.include? do_not_delete_accounts
                    @ui.click(".nssg-table .nssg-tbody tr:nth-child(#{users_grid_length}) td:nth-child(3) .nssg-td-text span:nth-child(2)")
                    sleep 0.5
                    @ui.click(".nssg-table .nssg-tbody tr:nth-child(#{users_grid_length}) td:nth-child(1) .nssg-actions-container .nssg-action-delete")
                    sleep 1
                    @ui.click("#_jq_dlg_btn_1")
                    sleep 1
                end
                users_grid_length -= 1
            end
        end
    end
end

shared_examples "scope to customer" do |customer_name|
    describe "Scope to the customer named '#{customer_name}'" do
        it "Change customers" do
            @ui.set_dropdown_entry("tenant_scope_options", customer_name)
            sleep 5
        end
    end
end

shared_examples "go to dashboard" do
    describe "Go to the Dashboard tab of the CommandCenter Admin area" do
        it "Go to the DASHBOARD tab" do
            expect(@ui.css('#msp_tab_dashboard')).to be_present
            @ui.click('#msp_tab_dashboard')
            sleep 1
            @ui.css('xc-tile-grid').wait_until_present
            expect(@ui.css('xc-tile-grid')).to be_present
            expect(@browser.url).to include("/#msp/dashboard")
        end
    end
end

def search_for_tile_name_and_verify_status_and_reason(domain_name, domain_status, reason, warning_message)
    it "Search for the tile named '#{domain_name}' in the (dashboard or groups) tile grid verify it has the status: '#{domain_status} #{reason}'" do
        @browser.refresh
        sleep 5
        tiles = @ui.get(:elements , {css: 'xc-tile-grid xc-tile-container .tile'}).length
        while tiles > 0
            if @ui.css("xc-tile-grid xc-tile-container xc-tile:nth-child(#{tiles}) .tile").attribute_value("title") == domain_name
                string = "xc-tile-grid xc-tile-container xc-tile:nth-child(#{tiles}) .tile"
                if domain_status == "good"
                    expect(@ui.css(string + " .icons .imgDiv")).not_to exist
                elsif domain_status == "warning"
                    expect(@ui.css(string + " .icons .imgDiv").attribute_value("class")).to eq("imgDiv " + reason)
                    expect(@ui.css(string + " .icons span").text).to eq(warning_message)
                end
                break
            end
            tiles-= 1
        end
    end
end


shared_examples "verify domain on dashboard" do |ensure_location, domain_name, domain_status, reason, warning_message|
    if ensure_location == true
        it_behaves_like "go to dashboard"
    end
    describe "Verify the domain named '#{domain_name}' on the DASHBOARD area of CommandCenter Admin" do
        search_for_tile_name_and_verify_status_and_reason(domain_name, domain_status, reason, warning_message)
    end
end

shared_examples "verify dashboard sort" do |ensure_location, domain_names_hash|
    if ensure_location == true
        it_behaves_like "go to dashboard"
    end
    describe "Verify that the MSP Dashboard has '#{domain_names_hash.length}' elements and all are properly sorted" do
        it "Verify the sorting feature of the Dashboard tiles" do
            tiles = @ui.get(:elements , {css: 'xc-tile-grid xc-tile-container .tile'}).length
            domains_length = domain_names_hash.length
            expect(tiles).to eq(domains_length)
            sleep 0.5
            while domains_length > 0 do
                expect(@ui.css("xc-tile-grid xc-tile-container xc-tile:nth-child(#{domains_length}) .tile").attribute_value("title")).to eq(domain_names_hash[domains_length])
                domains_length -= 1
            end
        end
    end
end

shared_examples "verify dashboard domain position" do |ensure_location, domain_name, domain_position|
    if ensure_location == true
        it_behaves_like "go to dashboard"
    end
    describe "Verify that the MSP Dashboard has the '#{domain_name}' element at the position '#{domain_position}'" do
        it "Verify the sorting feature of the Dashboard tiles" do
            expect(@ui.css("xc-tile-grid xc-tile-container xc-tile:nth-child(#{domain_position}) .tile").attribute_value("title")).to eq(domain_name)
        end
    end
end

shared_examples "verify dashboard tab notification" do |count|
    describe "Verify that the Dashboard tab show the Notification alert" do
        it "Verify that the Notification alert is present and has the count '#{count}'" do
            @browser.refresh
            sleep 8
            expect(@ui.css('#msp_tab_dashboard .tabBarInlineNotification')).to be_present
            expect(@ui.css('#msp_tab_dashboard .tabBarInlineNotification').text).to eq(count)
        end
    end
end

def search_for_the_tile_and_open_the_detailed_view(domain_name)
    puts @ui.css('.koProgrammaticPopupPanel').visible?
    if @ui.css('.koProgrammaticPopupPanel').visible? != true
        tiles = @ui.get(:elements , {css: 'xc-tile-grid xc-tile-container .tile'}).length
        while tiles > 0
            string = "xc-tile-grid xc-tile-container xc-tile:nth-child(#{tiles})"
            puts string
            if @ui.css(string + " .tile").attribute_value("title") == domain_name
                @ui.click(string + " .tile")
                sleep 2
                expect(@ui.css('.koProgrammaticPopupContent')).to be_visible
                break
            end
            tiles-= 1
        end
    end
end

shared_examples "verify dashboard domain detailed view" do |ensure_location, domain_name, domain_status, image_name, warning_message|
    if ensure_location == "CommandCenter"
        it_behaves_like "go to dashboard"
    elsif ensure_location == "AP Groups"
        #it_behaves_like "go to groups tab"
    end
    describe "Find the domain named '#{domain_name}' on the DASHBOARD area of CommandCenter Admin and click on it" do
        it "Search for the domain named '#{domain_name}' in the dashboard grid verify it has the status: '#{domain_status}'" do
            search_for_the_tile_and_open_the_detailed_view(domain_name)
        end
        it "Verify the domain status is '#{domain_status}'" do
            search_for_the_tile_and_open_the_detailed_view(domain_name)
            expect(@ui.css('.koProgrammaticPopupContent .sidebar')).to be_visible
            expect(@ui.css('.koProgrammaticPopupContent .sidebar span').text).to eq(domain_status)
        end
        it "Verify the icon of the detailed view" do
            search_for_the_tile_and_open_the_detailed_view(domain_name)
            if domain_status == "OK"
                status_text = "good"
            elsif domain_status == "Critical"
                status_text = "reason0"
            end
            expect(@ui.css('.koProgrammaticPopupContent .content .icons .statusIcon').attribute_value("class")).to include(status_text)
            if domain_status == "OK"
                expect(@ui.css('.koProgrammaticPopupContent .content .icons span:nth-child(2)')).not_to be_visible
                expect(@ui.css('.koProgrammaticPopupContent .content .icons span:nth-child(4)').text).to eq(warning_message)
            elsif domain_status == "Critical"
                expect(@ui.css('.koProgrammaticPopupContent .content .icons span:nth-child(2)')).to be_visible
                expect(@ui.css('.koProgrammaticPopupContent .content .icons span:nth-child(2)').text).to eq(warning_message)
            end
        end
        it "Verify the links" do
            search_for_the_tile_and_open_the_detailed_view(domain_name)
            if ensure_location == "AP Groups"
                expect(@ui.css('.koProgrammaticPopupContent .content .links li:nth-child(1) a').attribute_value("data-bind")).to include("i18n: 'arrays.groups.delete', click: $parent.deleteGroup")
                expect(@ui.css('.koProgrammaticPopupContent .content .links li:nth-child(1) a').text).to eq("Delete")
                expect(@ui.css('.koProgrammaticPopupContent .content .links li:nth-child(2) a').attribute_value("data-bind")).to eq("i18n: 'arrays.groups.view', click: $parent.viewGroup")
                expect(@ui.css('.koProgrammaticPopupContent .content .links li:nth-child(2) a').text).to eq("View")
                expect(@ui.css('.koProgrammaticPopupContent .content .links li:nth-child(3) a').attribute_value("data-bind")).to include("i18n: 'arrays.groups.edit', click: $parent.editGroup")
                expect(@ui.css('.koProgrammaticPopupContent .content .links li:nth-child(3) a').text).to eq("Edit this Group")
            else
                expect(@ui.css('.koProgrammaticPopupContent .content .links li:nth-child(1) a').attribute_value("data-bind")).to eq("visible: !expired, i18n:'msp.dashboard.manageDomain', attr:{ href: '#tenant/' + tenantId }")
                expect(@ui.css('.koProgrammaticPopupContent .content .links li:nth-child(1) a').text).to eq("Manage this Domain…")
                expect(@ui.css('.koProgrammaticPopupContent .content .links li:nth-child(2) a').attribute_value("data-bind")).to eq("i18n:'msp.dashboard.more', attr:{ href: '#msp/accounts/' + tenantId }")
                expect(@ui.css('.koProgrammaticPopupContent .content .links li:nth-child(2) a').text).to eq("More…")
            end
        end
    end
end

shared_examples "verify dashboard group container controls" do |control_name, ensure_location, domain_name, domain_status, image_name, warning_message, ap_count| #Created on 21/08/2017
    it_behaves_like "verify dashboard domain detailed view", ensure_location, domain_name, domain_status, image_name, warning_message
    describe "Use the '#{control_name}' and verify it has the proper functionality" do
        case control_name
            when "Delete"
                @@control_css = ".koProgrammaticPopupContent .content .links li:nth-child(1) a"
            when "View"
                @@control_css = ".koProgrammaticPopupContent .content .links li:nth-child(2) a"
            when "Edit this Group"
                @@control_css = ".koProgrammaticPopupContent .content .links li:nth-child(3) a"
        end
        it "Press the '#{control_name}' button" do
            @ui.click(@@control_css)
            sleep 2
        end
        case control_name
            when "Delete"
            when "View"
                it "Expect that the user is navigated to the Access Points sub tab and that the view is filtered" do
                    sleep 2
                    expect(@browser.url).to include('/#mynetwork/aps/aps/')
                    expect(@ui.css('#mynetwork-aps-filter .text').text).to eq(domain_name)
                    expect(@ui.css('#mynetwork_tab_arrays').attribute_value("class")).to include("filtered")
                    expect(@ui.css('.nssg-table tbody').trs.length).to eq(ap_count)
                end
            when "Edit this Group"
        end
    end
end

shared_examples "verify dashboard domain detailed view navigation" do |ensure_location, domain_name, domain_status, image_name, warning_message|
    it_behaves_like "verify dashboard domain detailed view", ensure_location, domain_name, domain_status, image_name, warning_message
    describe "Go to the 'Domains' page using the 'More...' link" do
        it "Press the 'More' link" do
            @ui.click('.koProgrammaticPopupContent .content .links li:nth-child(2) a')
            sleep 2
        end
        it "Verify the application navigated to the 'Domains' tab" do
            expect(@browser.url).to include('/#msp/accounts')
            expect(@ui.css('.nssg-table')).to be_present
        end
    end
    it_behaves_like "verify dashboard domain detailed view", ensure_location, domain_name, domain_status, image_name, warning_message
    describe "Go to the 'Managed Domain' area using the 'Manage this domain...' link" do
        it "Press the 'Manage this domain...' link" do
            @ui.click('.koProgrammaticPopupContent .content .links li:nth-child(1) a')
            sleep 4
        end
        it "Verify the application navigated to the 'Managed Domains' area on the My Network Map" do
            @ui.css('#dashboardContainer').wait_until_present
            expect(@browser.url).to include('/#mynetwork/overview/')
            expect(@ui.css('#tenant_scope_options a .text').text).to eq(domain_name)
        end
    end
end

shared_examples "verify dashboard search" do |ensure_location, domain_name, empty_search|
    if ensure_location == true
        it_behaves_like "go to dashboard"
    end
    describe "Verify that the MSP Dashboard search input box acts as intended" do
        it "Set the string '#{domain_name}' inside the search input box and verify 1 domain is displayed" do
            @@tiles_before = @ui.get(:elements , {css: 'xc-tile-grid xc-tile-container .tile'}).length
            @ui.set_input_val('.xc-search input', domain_name)
            sleep 3
            if empty_search == false
                tiles_after = @ui.get(:elements , {css: 'xc-tile-grid xc-tile-container .tile'}).length
                expect(@@tiles_before).not_to eq(tiles_after)
                expect(tiles_after).to eq(1)
            else
                expect(@ui.css('xc-tile-grid xc-tile-container .tile')).not_to exist
            end
        end
        it "Cancel the search and verify that the grid entries are returned to normal" do
            @ui.click('.xc-search .btn-clear')
            sleep 3
            tiles_after = @ui.get(:elements , {css: 'xc-tile-grid xc-tile-container .tile'}).length
            expect(@@tiles_before).to eq(tiles_after)
        end
    end
end


def find_what_browser_were_using(array_sn, local_browser_name)
        puts "aci"
        puts array_sn
        puts @browser_name.to_s.upcase
        if !array_sn.include? @browser_name.to_s.upcase
            case @browser_name.to_s.upcase
                when "IE"
                    return array_sn.gsub!(local_browser_name, @browser_name.to_s.upcase).tr("0", "000")
                when "EDGE", "FIREFOX"
                    puts "edge sau firefox return ala schimbat"
                    return array_sn.gsub!(local_browser_name, @browser_name.to_s.upcase).tr("0", "")
                when "CHROME"
                    return array_sn.gsub!(local_browser_name, @browser_name.to_s.upcase)
            end
        end
    end

def find_array_serial_number_depending_on_the_browser_used(array_sn)
    local_browser_name = @browser_name.to_s.upcase
    case @browser_name.to_s.upcase
        when "IE"
            return array_sn.gsub!(local_browser_name, @browser_name.to_s.upcase).tr("0", "000")
        when "EDGE", "FIREFOX"
            puts "edge sau firefox return ala schimbat"
            return array_sn.gsub!(local_browser_name, @browser_name.to_s.upcase).tr("0", "")
        when "CHROME"
            return array_sn.gsub!(local_browser_name, @browser_name.to_s.upcase)
    end
    #found_browser_sn = nil
    #browsers = ["CHROME", "FIREFOX", "EDGE", "IE", "SAFARI"]
    #browsers.each { |browser_asta|
    #    puts browser_asta
    #    found_browser_sn = find_what_browser_were_using(array_sn, browser_asta)
    #    if found_browser_sn != nil
    #        puts "--------------> #{found_browser_sn}"
    #        return found_browser_sn
    #    end
    #}
end

def find_and_tick_array_name_using_certain_characters(certain_characters)
    expect(@ui.css('.nssg-table tbody')).to exist
    grid_length = @ui.css(".nssg-table tbody").trs.length
    while grid_length > 0
        if @ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) .serialNumber .nssg-td-text").text.include?(certain_characters)
            @ui.click('.nssg-table tbody tr:nth-child(#grid_length) td:nth-child(2) input + .mac_chk_label')
            sleep 1
            return @ui.css(".nssg-table tr:nth-child(#{grid_length})")
        end
        grid_length -= 1
    end
end

#This code will
shared_examples "only assign array to domain" do |array_sn, domain_name|
    describe "Only assign an Array to the domain named '#{domain_name}'" do
        it "Assign the AP '#{array_sn}' to the domain named ''#{domain_name}''" do
            @browser.execute_script('$("#suggestion_box").hide()')
            sleep 0.4
            @ui.click('#msp_tab_arrays')
            sleep 5
            @ui.css('.tab-item-container .commonTitle span').wait_until_present
            @ui.click('.tab-item-container .commonTitle span')
            sleep 0.4
            #@@array_sn_depending_on_browser = find_array_serial_number_depending_on_the_browser_used(array_sn)
            #@ui.grid_action_on_specific_line("4", "div", @@array_sn_depending_on_browser, "invoke")
            #grid_entry = find_and_tick_array_name_using_certain_characters(array_sn)
            #@ui.click(grid_entry + " .nssg-action-delete .nssg-action-invoke")
            @ui.css('.nssg-table .nssg-thead tr th:nth-child(4) .nssg-th-text').wait_until_present
            until @ui.css('.nssg-table .nssg-thead tr th:nth-child(4)').attribute_value("class").include?("nssg-sorted-asc")
                @ui.click('.nssg-table .nssg-thead tr th:nth-child(4) .nssg-th-text')
                sleep 2
            end
            @path_of_line = @ui.find_array_depending_on_included_strings_then_return_path(array_sn, 4, "div")
            puts @path_of_line
            tick_box = @path_of_line.sub("td:nth-child(4) div", "td:nth-child(2) .mac_chk_label")
            @ui.click(tick_box)
            actions_container_invoke = @path_of_line.sub("td:nth-child(4) div", "td:nth-child(1) .nssg-action-invoke")
            @ui.click(actions_container_invoke)
            sleep 0.4
            @ui.click('#msp-aps-assign')
            sleep 0.4
            @ui.set_input_val('#msp_filter_tags_input', domain_name)
            sleep 0.4
            @ui.click('#msp_filter_tags_btn')
            sleep 1
            expect(@ui.css('#msp-aps-assign .drop_menu_nav .items a:first-child').text).to eq(domain_name)
            @ui.css('#msp-aps-assign .drop_menu_nav .items a:first-child').hover
            sleep 1
            @ui.click('#msp-aps-assign .drop_menu_nav .items a:first-child')
            sleep 0.4
            @ui.click('#_jq_dlg_btn_1')
            sleep 3
            @ui.click('.slideout_collapse_icon')
        end
        it "Expect the Domain name in the grid to match the value ''#{domain_name}''" do
            expect(@browser.url).to include("/#msp/arrays")
            @ui.css('.nssg-paging .nssg-refresh').wait_until_present
            @ui.click('.nssg-paging .nssg-refresh')
            sleep 3
            #array_sn_depending_on_browser = find_array_serial_number_depending_on_the_browser_used(array_sn)
            #verify_value_on_grid_cell(4, @@array_sn_depending_on_browser, "div", 6, "div", domain_name)
                @path_of_line = @ui.find_array_depending_on_included_strings_then_return_path(array_sn, 4, "div")
                css_of_cell = @path_of_line.sub("td:nth-child(4) div", "td:nth-child(6) div")
                expect(@ui.css(css_of_cell).text).to eq(domain_name)
            #grid_entry = find_and_tick_array_name_using_certain_characters(array_sn)
            #expect(@ui.css(grid_entry + " .tenantId .nssg-td-text").text).to eq(domain_name)
            #find_and_tick_array_name_using_certain_characters(array_sn)
        end
    end
end

shared_examples "only unassign array to domain" do |array_sn, domain_name|
    describe "Only unassign an array from the domain named '#{domain_name}'" do
        it "Unassign the AP using the 'Unassign' button above the grid" do
            @ui.click('#msp_tab_arrays')
            sleep 0.4
            @browser.refresh
            sleep 4
            #@browser.execute_script('$("#suggestion_box").hide()')
            sleep 1
            @path_of_line = @ui.find_array_depending_on_included_strings_then_return_path(array_sn, 4, "div")
            tick_box = @path_of_line.sub("td:nth-child(4) div", "td:nth-child(2) .mac_chk_label")
            @ui.click(tick_box)
            sleep 0.4
            @ui.click('#msp_arrays_unassign')
            sleep 0.4
            @ui.click('#_jq_dlg_btn_1')
        end
        it "Go to the Domains tab" do
           @ui.click('#msp_tab_accounts')
           sleep 3
        end
        it "Verify that the ''#{domain_name}'' domain has an AP count of '0'" do
            @path_of_line = @ui.find_array_depending_on_included_strings_then_return_path(domain_name, 2, "div span:nth-child(2)")
                css_of_cell = @path_of_line.sub("td:nth-child(2) div span:nth-child(2)", "td:nth-child(3) div")
                expect(@ui.css(css_of_cell).text).to eq("0")
            #verify_value_on_grid_cell(2, domain_name, "div span:nth-child(2)", 3, "div", '0')
        end
    end
end

shared_examples "verify non msp owned equipment domains tab" do |domain_name|
    describe "Verify that NON MSP owned equipment cannot be moved (assigned/unassigned)" do
        it "Search for a domain with the name of : #{domain_name} and open to edit it" do
            @browser.execute_script('$("#suggestion_box").hide()')
            @ui.grid_action_on_specific_line("2", "div", domain_name, "invoke")
        end
        it "Go to the Access Points tab and verify that the AP lines do not have a 'checkbox' control" do
            @ui.click('#accountdetails_tab_aps')
            sleep 2
            table_length = @ui.css('.ko_slideout_container .nssg-table .nssg-tbody').trs.length
            while table_length > 0
                expect(@ui.css(".ko_slideout_container .nssg-table .nssg-tbody tr:nth-child(#{table_length}) td:first-child .nssg-td-select")).not_to be_visible
                table_length -= 1
            end
        end
        it "Close the slideout modal" do
            @ui.click('#accountdetails_close_btn')
        end
    end
end

shared_examples "verify non msp owned equipment access points tab" do |domain_name|
    describe "Verify that NON MSP owned equipment cannot be moved (assigned/unassigned)" do
        it "Go to the APs tab" do
            @ui.click('#msp_tab_arrays')
        end
        it "Search for an AP that belongs to the domain named : #{domain_name} and select it" do
            @browser.execute_script('$("#suggestion_box").hide()')
            @ui.grid_action_on_specific_line("6", "div", domain_name, "tick")
        end
        it "Expect that the 'Unassign' button is disabled" do
            expect(@ui.css('#msp_arrays_unassign').attribute_value("disabled")).to eq("true")
            @browser.refresh
            sleep 3
        end
        it "Search for an AP that is 'Unassigned' and select it" do
            @ui.grid_action_on_specific_line("6", "div", "Unassigned", "tick")
        end
        it "Open the 'Assign' dropdown menu and verify that the '#{domain_name}' domain isn't displayed in the list" do
            @ui.click('#msp_arrays_assign')
            sleep 1
            expect(@ui.css('#msp_arrays_assign .move_to_nav .items')).to be_visible
            domains_available = @ui.get(:elements , {css: '#msp_arrays_assign .move_to_nav .items a'})
            domains_available.each { |domain_available|
                expect(domain_available.text).not_to eq(domain_name)
            }
            @browser.refresh
            sleep 3
        end
        it "Search for an AP that is 'Unassigned', open it for editing and " do
            @ui.grid_action_on_specific_line("6", "div", "Unassigned", "invoke")
            sleep 1
            domains_available = @ui.get(:elements , {css: '.msp_apdetails_tab_general .drop_menu_nav .items a'})
            domains_available.each { |domain_available|
                expect(domain_available.text).not_to eq(domain_name)
            }
            @browser.refresh
            sleep 3
        end
        it "Select both an 'Unassigned' AP and one that belogs to the domain '#{domain_name}'" do
            @ui.grid_action_on_specific_line("6", "div", domain_name, "tick")
            sleep 2
            @ui.grid_action_on_specific_line("6", "div", "Unassigned", "tick")
        end
        it "Verify that the 'Unassign' and 'Assign' buttons are both disabled" do
            expect(@ui.css('#msp_arrays_unassign').attribute_value("disabled")).to eq("true")
            expect(@ui.css('#msp_arrays_assign').attribute_value("class")).to include("disabled")
            @ui.css('#msp_arrays_unassign').hover
            sleep 0.5
            expect(@ui.css('.ko_tooltip_content_text')).to be_visible
            expect(@ui.css('.ko_tooltip_content_text .ko_tooltip_content').text).to eq("You cannot move Access Points that are owned by the domain.")
            sleep 1
            @browser.refresh
            sleep 3
        end
    end
end

shared_examples "verify support email features" do
    describe "Verify the CC Support Email Settings features" do
        it "Verify all texts are properly displayed" do
            expect(@ui.css('#command-center-tab .commonTitle').text).to eq("CommandCenter")
            expect(@ui.css('#command-center-tab .commonSubtitle').text).to eq("Configuration for the CommandCenter")
            expect(@ui.css('#command-center-tab .field_heading').text).to eq("Contact Support Email:")
            expect(@ui.css('#command-center-tab .field .email-input-label').text).to eq("Send Support Email To:")
            expect(@ui.css(".email-input-label + input").attribute_value("placeholder")).to eq("mail@mail.com")
        end
    end
end

shared_examples "support email input" do |email, error, copy_write|
    describe "Set the Support Email input's value to '#{email}'" do
        it "Set the value '#{email}' in the email input box" do
            sleep 3
            expect(@ui.css(".email-input-label + input")).to be_present
            if copy_write == "Copy"
                @ui.set_input_val(".email-input-label + input", email)
            elsif copy_write == "Write"
               @ui.set_val_for_input_field(".email-input-label + input", email)
            end
            @ui.click('#command-center-tab .commonTitle')
            if email == ""
                @browser.send_keys :enter
            end
            if error == false
                @ui.css('.success').wait_until_present
                expect(@ui.css('.success .msgbody div').text).to eq("Account Settings Saved")
                sleep 1
                expect(@ui.get(:input, {css: ".email-input-label + input"}).value).to eq(email)
            else
                @ui.css('.temperror').wait_until_present
                expect(@ui.css('.temperror .msgbody div').text).to eq("Please correct any errors before saving")
                sleep 0.1
                expect(@ui.css(".email-input-label ~ .xirrus-error").text).to eq("Please enter a valid email.")
                if email.length > 50
                    email = email[0..49]
                end
                expect(@ui.get(:input, {css: ".email-input-label + input"}).value).to eq(email)
                #expect(@ui.css('.success')).not_to be_present
            end
        end
    end
end

shared_examples "support email verify value" do |value|
    describe "Verify the Support Email input value" do
        it "Verify the input value" do
            expect(@ui.get(:input, {css: ".email-input-label + input"}).value).to eq(value)
        end
    end
end

shared_examples "verify command center tab not present in settings" do
    describe "Verify that the Command Center tab isn't present in the Settings area" do
        it "Expect CommandCenter tab not to exist" do
            expect(@ui.css("#settings_tab_commandcenter")).not_to exist
        end
    end
end

shared_examples "verify domains meter updated properly" do |already_present_domains, max_limit, verify_tooltip| # Created 16/01/2018 - XMSC 615 CommandCenter Licensing
    describe "Verify that the CommandCenter Domains meter is properly updated" do
        it "(If needed) Go to the Domains tab" do
            if !@browser.url.include?("/#msp/accounts")
                @ui.click('#msp_tab_accounts') and sleep 2
            end
        end
        it "Verify the xc-meter control ('#{already_present_domains} of #{max_limit}')" do
            expect(@ui.css(".msp-accounts-meter .c-meter .value").text).to eq(already_present_domains.to_s + " of " + max_limit.to_s)
            added_domains_percentage = already_present_domains*100/max_limit
            expect(@ui.css(".msp-accounts-meter .c-meter .bar").attribute_value("style")).to eq("width: #{added_domains_percentage}%;")
        end
        if verify_tooltip == true
            it "Verify the 'i' button's tooltip" do
                @ui.click('.grey-outline-info-icon')
                sleep 1
                expect(@ui.css('.grey-outline-info-icon.ko_tooltip_active')).to exist
                expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq("Your license allows management of #{max_limit} domains.")
                @ui.click(".msp-accounts-meter .c-meter .value")
            end
        end
    end
end

shared_examples "verify create new domain button disabled" do # Created 16/01/2018 - XMSC 615 CommandCenter Licensing
    describe "Verify that the '+ New Domain' button is disabled and cannot be used" do
        it "Verify the '+ New Domain' button" do
            expect(@ui.css('#msp-newacct-btn')).to be_present
            expect(@ui.css('#msp-newacct-btn').attribute_value("disabled")).to eq("true")
            expect(@ui.css('#msp-newacct-btn + .ko_tooltip_helper')).to exist
        end
        it "Click the '+ New Domain' button and verify the tooltip message" do
            expect{@ui.click('#msp-newacct-btn')}.to raise_error(Watir::Exception::ObjectDisabledException)
            @ui.css('#msp-newacct-btn').hover
            sleep 1
            expect(@ui.css('.msp-newacct-btn-wrapper.ko_tooltip_active')).to exist
            expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq("There are no more licenses remaining. Please remove an existing domain or contact your administrator for additional licenses.")
            @browser.refresh
            sleep 3
        end
    end
end

 shared_examples "assign unassign switch to domain" do |sw_sn, action, domain_name|
  describe "Assign unassign switch-#{sw_sn} action-#{action}, from #{domain_name}" do
    it "assign unassign switch from domain" do
      @ui.css('#header_nav_user').click
      sleep 0.2
      @ui.css('#header_msp_link').click
      sleep 0.2
      @ui.click('#msp_tab_switches')
      sleep 0.4
      @browser.refresh
      sleep 1
      @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "100")
      @ui.grid_action_on_specific_line(3, "div", sw_sn, "tick")
      sleep 0.4
      if action == "assign"
        @ui.css('#msp_switches_assign').click
        sleep 1
        @ui.css('#msp_switches_assign .move_to_nav .items a:last-child').hover
        @ui.css('#msp_switches_assign .move_to_nav .items a:last-child').click
      end
      if action== "unassign"
        @ui.css('#msp_switches_unassign').click
      end

      sleep 0.4
      @ui.click('#_jq_dlg_btn_1')
    end
  end
end

shared_examples "deploy profile to a domain from profiles landing page" do |profile_name, domain_name|
    describe "Deploy the profile named '#{profile_name}' to the domain named '#{domain_name}' by using the profiles landing page" do
        it "Go to the profiles landing page" do
            @ui.view_all_profiles_with_switch
        end
        it "Hover over the '#{profile_name}' Profile's tile to reveal overlay buttons and press the 'Deploy to Domain' button" do
            hover_over_tile_and_press_deploy_button("Profiles", profile_name)
        end
        it "Verify that the 'Deploy to Domain' modal is displayed " do
            verify_the_deploy_to_domain_modal_contents("Profiles", profile_name)
        end
        it "Change the 'Domain' option to '#{domain_name}'" do
            @ui.set_dropdown_entry('profile_location_input', domain_name)
        end
        it "Press the <DEPLOY> button and verify the deploy message is 'Profile was successfully deployed.' and that the grid still shows the Profile named '#{profile_name}'" do
            @ui.click('#profiles_profiledeploy .buttons .button.orange')
            sleep 3
            profile_found = verify_that_a_tile_is_present("Profiles", profile_name)
            expect(profile_found).to eq(true)
        end
    end
end
shared_examples "deploy switch port template to a domain from switch port template landing page" do |sw_port_template_name, domain_name|
    describe "Deploy the switch port template named '#{sw_port_template_name}' to the domain named '#{domain_name}' by using the switch port template landing page" do
        it "Go to the switch port template landing page" do
            goto_switch_port_template
        end
        it "Hover over the '#{sw_port_template_name}' templet's tile to reveal overlay buttons and press the 'Deploy to Domain' button" do
            hover_over_tile_and_press_deploy_button("port_templates", sw_port_template_name)
        end
        it "Verify that the 'Deploy to Domain' modal is displayed " do
            verify_the_deploy_to_domain_modal_contents("port_templates", sw_port_template_name)
        end
        it "Change the 'Domain' option to '#{domain_name}'" do
            @ui.set_dropdown_entry('profile_location_input', domain_name)
        end
        it "Press the <DEPLOY> button and verify the deploy message is 'Profile was successfully deployed.' and that the grid still shows the Profile named '#{sw_port_template_name}'" do
            @ui.click('#profiles_profiledeploy .buttons .button.orange')
            sleep 3
            profile_found = verify_that_a_tile_is_present("port_templates", sw_port_template_name)
            expect(profile_found).to eq(true)
        end
    end
end
shared_examples "deploy switch template to a domain from switch template landing page" do |sw_template_name, domain_name|
    describe "Deploy the switch port template named '#{sw_template_name}' to the domain named '#{domain_name}' by using the switch port template landing page" do
        it "Go to the switch port template landing page" do
            goto_switch_template
        end
        it "Hover over the '#{sw_template_name}' templet's tile to reveal overlay buttons and press the 'Deploy to Domain' button" do
            press_deploy_button_for_namespace_before_after("switch_templates", sw_template_name)
        end
        it "Verify that the 'Deploy to Domain' modal is displayed " do
            verify_the_deploy_to_domain_modal_contents("switch_templates", sw_template_name)
        end
        it "Change the 'Domain' option to '#{domain_name}'" do
            @ui.set_dropdown_entry('profile_location_input', domain_name)
        end
        it "Press the <DEPLOY> button and verify the deploy message is 'Profile was successfully deployed.' and that the grid still shows the Profile named '#{sw_template_name}'" do
            @ui.click('#profiles_profiledeploy .buttons .button.orange')
            sleep 3
            profile_found = verify_that_a_tile_is_present("switch_templates", sw_template_name)
            expect(profile_found).to eq(true)
        end
    end
end