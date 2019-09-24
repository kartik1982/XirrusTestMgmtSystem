###################################################################################################################################
##################TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - ACCESS POINT - PUT IN DECOMMISSION##################
###################################################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - ACCESS POINT - PUT IN DECOMMISSION **********" do
  before :all do
    @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
    @ng = API::ApiClient.new(token: @token)
    tenant_name="mynetwork-accesspointtab-automation-xms-admin"
    @get_tenant_by_name = @ng.tenant_by_name(tenant_name).body
    puts "Needed tenant ID: #{@get_tenant_by_name.to_s[18..53]}"
    @needed_tenent_id = @get_tenant_by_name.to_s[18..53]
    ## add fake XR2230 to XMSC, used only for UI tests
    @array_mac = UTIL.random_mac
    @array_iap_mac = UTIL.random_mac
    @array_ip = "207.241.148.80"
    @array_serial = UTIL.random_serial

    arrays_to_add = []
    arrays_to_add << {            
      baseMacAddress: @array_mac, 
      baseIapMacAddress: @array_iap_mac,   
      serialNumber: @array_serial,
      arrayModel: "XR2230",
      expirationDate: 1537296278000,
      manufacturer: "Xirrus",
      aosVersion: "",
      licenseKey: "NOT_A_REAL_LICENSE",
      licensedAosVersion: "10.2",
      location: "FAKE",
      hostName: @array_serial,
      activationStatus: "NOT_ACTIVATED",
      onlineStatus: "DOWN",    
      country: "US"
    }
    @create_fake_array_res = @ng.add_arrays_to_tenant(@needed_tenent_id, arrays_to_add) 
    expect([200,201]).to include(@create_fake_array_res.code)

    @fake_array = @create_fake_array_res.body[0]

    @fake_array_id = @create_fake_array_res.body[0]['id']

    @browser.refresh
    sleep 8
  end
  it "Go to the Access Points tab of the My Network area " do
      @ui.click('#header_mynetwork_link')
      sleep 2.5
      @ui.click('#mynetwork_tab_arrays')
      sleep 1
    end
  it "Set the view per page to '100' entries" do
      if @ui.css('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .text') != "100"
        @ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string('.ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul', "100")
        sleep 2
      end
    end
  it "Place a tick for the Access Point line with the serial number of '#{@array_serial}'" do
      css_path = @ui.grid_tick_on_specific_line("4", @array_serial, "a")
      expect(css_path).not_to eq(nil)
  end
  it "Verify that after decommission Ap removed from GUI" do
      more_button = @ui.css('#arrays_more_btn').parent
      expect(more_button).to be_present
      more_button.element(css: ".icon").click
      sleep 1
      expect(more_button.element(css: ".more_menu")).to be_present
      expect(@ui.css('#arrays-menu-reboot')).to be_present
      expect(@ui.css('#arrays-menu-admin-decommission')).to be_visible
      expect(@ui.css('#arrays-menu-admin-decommission')).to be_present
      @ui.css('#arrays-menu-admin-decommission').click
      sleep 2
      @browser.button(:text => 'YES, DECOMMISSION THE ACCESS POINT').click 
      sleep 2
      css_path = @ui.grid_tick_on_specific_line("4", @array_serial, "a")
      expect(css_path).to eq(nil)
    end
  it "Place a tick for the first Access Point line with the serial number" do
      $added_first_access_point_sn = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(4) .nssg-td-text").text
      css_path = @ui.grid_tick_on_specific_line("4", $added_first_access_point_sn, "a")
      expect(css_path).not_to eq(nil)
  end
  it "Verify that decommission Drop down option is not avaialble in More for AP with valid license" do
      more_button = @ui.css('#arrays_more_btn').parent
      expect(more_button).to be_present
      more_button.element(css: ".icon").click
      sleep 1
      expect(more_button.element(css: ".more_menu")).to be_present
      expect(@ui.css('#arrays-menu-reboot')).to be_present
      expect(@ui.css('#arrays-menu-admin-decommission')).not_to be_visible
      expect(@ui.css('#arrays-menu-admin-decommission')).not_to be_present
    end

  after :all do 
    array_res = @ng.global_by_serial(@array_serial)
    id = array_res.body["xirrusArrayDto"]["id"]
    del_res = @ng.delete_array_global({arrayId: id})
    puts del_res
    expect(del_res.code).to eql(200)
    expect(del_res.body).to eql("\"Array deleted\"")    
  end
end