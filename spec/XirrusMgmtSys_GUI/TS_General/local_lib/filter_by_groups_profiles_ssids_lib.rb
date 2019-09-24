shared_examples "verify that filter for groups-profiles-ssids drop-down display list" do |sections, group_list, profile_list, ssid_list|
  describe "verify that filter for groups-profiles-ssids drop-down display list" do
    it "verify that filter for groups-profiles-ssids drop-down display list for My network => Overview" do
      @ui.css('#header_mynetwork_link').click
      sleep 1
      @ui.css("#mynetwork_tab_overview").click
      sleep 1
      @ui.css("#myNetworkOverview .ko_dropdownlist_button").click
      verify_filter_section_available(sections, group_list, profile_list, ssid_list)
      @ui.css('#ko_dropdownlist_overlay').click    
    end
    it "verify that filter for groups-profiles-ssids drop-down display list for My network => Access Points tab" do
      if @ui.css('.ko_dropdownlist.active').exists?
        @ui.css('#ko_dropdownlist_overlay').click
      end
      @ui.css("#mynetwork_tab_arrays").click
      sleep 1
      @ui.css("#mynetwork-aps-filter .ko_dropdownlist_button").click
      verify_filter_section_available(sections, group_list, profile_list, ssid_list) 
      @ui.css('#ko_dropdownlist_overlay').click
    end
    it "verify that filter for groups-profiles-ssids drop-down display list for My network => Clients" do
      if @ui.css('.ko_dropdownlist.active').exists?
        @ui.css('#ko_dropdownlist_overlay').click
      end
      @ui.css("#mynetwork_tab_clients").click
      sleep 1
      @ui.css(".clients_tab .ko_dropdownlist_button").click
      verify_filter_section_available(sections, group_list, profile_list, ssid_list)   
      @ui.css('#ko_dropdownlist_overlay').click
    end
    
    it "verify that filter for groups-profiles-ssids drop-down display list for My network => Rogues" do
      if @ui.css('.ko_dropdownlist.active').exists?
        @ui.css('#ko_dropdownlist_overlay').click
      end
      @ui.css("#mynetwork_tab_rogues").click
      sleep 1
      @ui.css(".rogues_tab .ko_dropdownlist_button").click
      verify_filter_section_available(sections, group_list, profile_list, ssid_list) 
      @ui.css('#ko_dropdownlist_overlay').click 
    end
    
     it "verify that filter for groups-profiles-ssids drop-down display list for Report => Edit Report" do
      if @ui.css('.ko_dropdownlist.active').exists?
        @ui.css('#ko_dropdownlist_overlay').click
      end
      @ui.goto_report "AP and Client Throughput Report"
      sleep 1
      @ui.click('.report-edit-view-btn')
      sleep 0.5
      @ui.css("#report-edit-view-profile .ko_dropdownlist_button").click
      verify_filter_section_available(sections, group_list, profile_list, ssid_list)  
      @ui.css('#ko_dropdownlist_overlay').click 
      @browser.button(:text => 'Cancel').click  
    end

    it "verify that filter for groups-profiles-ssids drop-down display list for Reports => Analytic" do
      if @ui.css('.ko_dropdownlist.active').exists?
        @ui.css('#ko_dropdownlist_overlay').click
      end
      if @browser.url.include?('/#analytics') == false
         expect(@ui.css('#header_nav_reports')).to be_visible
        @ui.click('#header_nav_reports') and sleep 1
        expect(@ui.css('#header_nav_reports .drop_menu_nav')).to be_visible and expect(@ui.css('#header_nav_reports .drop_menu_nav #analytics_menu_item')).to be_visible
        @ui.click('#analytics_menu_item a')
        sleep 5
        @ui.css('.analytics-header span').wait_until_present and expect(@ui.css('.analytics-header span').text).to eq('Analytics') and expect(@browser.url).to include('/#analytics')
      end
      @ui.css('.new-widget-button').click
      sleep 1
      @ui.css(".ko_dropdownlist_button").click
      verify_filter_section_available(sections,  group_list, profile_list, ssid_list) 
      # @ui.css('#ko_dropdownlist_overlay').click
      @ui.css('.ko_dropdownlist_list_wrapper ul li:first-child').click
      @ui.css('.xc-modal-close').click  
    end
  end
end

def verify_filter_section_available(sections, exp_groups, exp_profiles, exp_ssids) 
  act_groups=[]
  act_profiles=[]
  act_ssids=[]
     
  if(sections[0]=="none")  
    @ui.css(".ko_dropdownlist_list.active ul").divs.each_with_index do |div, i|  
      expect(div).not_to be_visible
    end
     if @browser.url.include?('/#analytics')
      expect(@ui.css(".ko_dropdownlist_list.active ul").lis[0].text).to eq("All Access Points")
    else
      expect(@ui.css(".ko_dropdownlist_list.active ul").lis[0].text).to eq("All Devices")
    end
    expect(act_groups).to match_array exp_groups
    expect(act_profiles).to match_array exp_profiles
    expect(act_ssids).to match_array exp_ssids
  elsif(sections[0]=="all")
        if @browser.url.include?('/#mynetwork/rogues') == true
          sections=["Groups", "Profiles"]
          @ui.css(".ko_dropdownlist_list.active ul").divs.each_with_index do |div, i|
          expect(div).to be_visible
          expect(div.a.text).to eq("See All")
          expect(div.span.text).to eq(sections[i])
          end
          @ui.css(".ko_dropdownlist_list.active ul").lis.each_with_index do |li, i|
            if(i !=0)
              if(li.attribute_value("data-ddlvalindex").to_i == i)
                act_groups << li.attribute_value("data-value").to_s
              end
              if((li.attribute_value("data-ddlvalindex").to_i - i) == 1)
                act_profiles << li.attribute_value("data-value").to_s
              end
            end
          end
          expect(@ui.css(".ko_dropdownlist_list.active ul").lis[0].text).to eq("All Devices")
          expect(act_groups).to match_array exp_groups
          expect(act_profiles).to match_array exp_profiles 
      elsif @browser.url.include?('/#analytics') == true
        sections=["Groups", "SSIDs"]
        @ui.css(".ko_dropdownlist_list.active ul").divs.each_with_index do |div, i|
          expect(div).to be_visible
          expect(div.a.text).to eq("See All")
          expect(div.span.text).to eq(sections[i])
        end
        @ui.css(".ko_dropdownlist_list.active ul").lis.each_with_index do |li, i|
          if(i !=0)
            if(li.attribute_value("data-ddlvalindex").to_i == i)
              act_groups << li.attribute_value("data-value").to_s
            end
            if((li.attribute_value("data-ddlvalindex").to_i - i) == 1)
              act_ssids << li.attribute_value("data-value").to_s
            end
          end
        end
        expect(@ui.css(".ko_dropdownlist_list.active ul").lis[0].text).to eq("All Access Points")
        expect(act_groups).to match_array exp_groups
        expect(act_ssids).to match_array exp_ssids
        else        
          sections=["Groups", "Profiles", "SSIDs"]
          @ui.css(".ko_dropdownlist_list.active ul").divs.each_with_index do |div, i|
            expect(div).to be_visible
            expect(div.a.text).to eq("See All")
            expect(div.span.text).to eq(sections[i])
          end
          @ui.css(".ko_dropdownlist_list.active ul").lis.each_with_index do |li, i|
            if(i !=0)
              if(li.attribute_value("data-ddlvalindex").to_i == i)
                act_groups << li.attribute_value("data-value").to_s
              end
              if((li.attribute_value("data-ddlvalindex").to_i - i) == 1)
                act_profiles << li.attribute_value("data-value").to_s
              end
              if((li.attribute_value("data-ddlvalindex").to_i - i) == 2)
                act_ssids << li.attribute_value("data-value").to_s
              end
            end  
         end  
            if @browser.url.include?('/#analytics')
              expect(@ui.css(".ko_dropdownlist_list.active ul").lis[0].text).to eq("All Access Points")
            else
              expect(@ui.css(".ko_dropdownlist_list.active ul").lis[0].text).to eq("All Devices")
            end
            expect(act_groups).to match_array exp_groups
            expect(act_profiles).to match_array exp_profiles
            expect(act_ssids).to match_array exp_ssids
      end     
  end
end