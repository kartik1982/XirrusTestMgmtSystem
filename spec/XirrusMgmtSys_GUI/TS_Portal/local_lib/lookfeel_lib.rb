require_relative "portal_lib.rb"
require_relative "general_lib.rb"

def verify_iframe_preview_string(element_path)
  frame = @ui.get(:iframe, { css: '.preview .preview_wrap .iframe_wrap .iframe_preview' })
  expect(frame.element(:css => element_path)).to exist
  iframe_element = frame.element(:css => element_path)
  iframe_element.wait_until_present
  return iframe_element
end

def check_correct_number_of_pages(portal_type)
  c = @ui.css('.page_tiles_container ul')
  c.wait_until_present
  case portal_type
    when "self_reg"
      if @browser_name.to_s == "edge"
        expect(c.lis.length).to eq(6)
        expect(c.lis[3].attribute_value("style")).to eq("display: none;")
      else
        expect(c.lis.select{|li| li.visible?}.length).to eq(5)
      end
    when "ambassador"
      expect(c.lis.select{|li| li.visible?}.length).to eq(2)
    when "onboarding", "azure", "google"
      expect(c.lis.select{|li| li.visible?}.length).to eq(1)
    when "voucher"
      expect(c.lis.select{|li| li.visible?}.length).to eq(2)
    when "personal"
      expect(c.lis.select{|li| li.visible?}.length).to eq(4)
    when "onetouch"
      expect(c.lis.select{|li| li.visible?}.length).to eq(2)
    when "mega"
      expect(c.lis.select{|li| li.visible?}.length).to eq(1)
    else
      puts 'Type not defined'
  end
end

def close_the_preview_window
  if @ui.css('#guestportal_config_lookfeel_view .innertab .preview').attribute_value("class").include?("fullscreen")
    @browser.execute_script('$("#guestportal_preview_close").click()')
    sleep 1
    while @ui.css('#guestportal_config_lookfeel_view .innertab .preview').attribute_value("class").include?("fullscreen") do
      sleep 0.5
      @browser.execute_script('$("#guestportal_config_lookfeel_view .innertab .preview").removeClass("fullscreen")')
    end
    @ui.click('.commonTitle span')
  end
end

def close_the_preview_window_with_it_block
  it "Close the iframe full screen display page" do
    @browser.execute_script('$("#guestportal_preview_close").click()')
    sleep 2
  end
end

def find_specific_page(page_name)
  pages = @ui.get(:elements , {css: '.innertab .page_tiles_container .ko-hover-scroll .tiles .tile'})
  pages.each { |page|
    if page.element(css: ".page_name").text == page_name
      return page
    end
  }
end

def ensure_voucher_portal_is_properly_handled(portal_type)
  if(portal_type == "voucher")
    if @ui.css('#manageguests_vouchermodal .buttons .orange').present?
      @ui.click('#manageguests_vouchermodal .buttons .orange')
      sleep 1
    end
  end
end

def add_and_select_external_image(external_link, image_name)
  while @ui.css('.ko-gallery-modal').present? != true
    sleep 0.5
  end
  @ui.click('.ko-gallery .modal-overlay .ko-gallery-modal .content .ko-gallery-list .ko-gallery-external')
  sleep 1
  @ui.set_input_val('#promptInput', external_link)
  sleep 2
  @ui.click('._jq_dlg_btn.default')
  sleep 4
  if (@ui.css('#_jq_dlg_btn_2').exist?)
    sleep 2
    @ui.click('#_jq_dlg_btn_2')
    sleep 2
  end
  sleep 2
  images_length = @ui.get(:elements , {css: ".ko-gallery-modal .ko-gallery-image"}).length + 2
  puts images_length
  while images_length != 2 do
    if @ui.css(".ko-gallery-modal .ko-gallery-image:nth-of-type(#{images_length})").attribute_value("style").include?(image_name)
      @ui.click(".ko-gallery-modal .ko-gallery-list li:nth-child(#{images_length})")
      sleep 2
      @ui.click(".ko-gallery-modal .ko-gallery-list li:nth-child(#{images_length})")
    end
    images_length-=1
  end
  sleep 2
  @ui.click('.ko-gallery-modal .button.orange')
  sleep 1
  if @ui.css('.dialogOverlay.temperror .dialogBox .msgbody').present?
    if @ui.css('.dialogOverlay.temperror .dialogBox .msgbody').text == "No image was selected."
      sleep 5
      @ui.click('.ko-gallery-modal .ko-gallery-image')
      sleep 1
      @ui.click('.ko-gallery-modal .button.orange')
    end
  end
end

def click_the_first_page_tile
  c = @ui.css('.page_tiles_container ul')
  c.wait_until_present
  li = c.lis.select{|li| li.visible?}[0]
  li.wait_until_present
  li.click
end

shared_examples "go to portal look feel tab" do |portal_name|
  describe "Go to the portal named '#{portal_name}' on the 'Look & Feel' tab" do
    it "Go to portal and then to the 'Look & Feel' tab" do
      navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,false)
      sleep 2
      @ui.click('#guestportal_config_tab_lookfeel')
      sleep 2
      @browser.execute_script('$("#suggestion_box").hide()')
      expect(@browser.url).to include("/config/lookfeel")
    end
  end
end

shared_examples "update portal look & feel company name" do |portal_name, portal_type, company_name|
  describe "Update the portal's look & feel settings with the company name as '#{company_name}'" do
    it "Update the company name field with the value '#{company_name}'" do
      check_correct_number_of_pages(portal_type)
      sleep 0.5
      @ui.set_input_val("#guestportal_config_lookfeel_companyname", company_name)
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      click_the_first_page_tile
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      title = frame.element(:css => ".companyname")
      title.wait_until_present
      expect(title.text).to eq(company_name)
    end
  end
end

shared_examples "update portal look & feel logo external" do |portal_name, portal_type, external_link, verify_name|
  describe "Update the portal's look & feel settings with the logo" do
    it "Update the logo and save" do
      close_the_preview_window
      sleep 0.5
      @ui.click('#guestportal_config_lookfeel_logobutton')
      sleep 2
      add_and_select_external_image(external_link, verify_name)
      sleep 2
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      click_the_first_page_tile
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      frame.wait_until_present
      img = frame.element(:css => "#logo_image")
      img.wait_until_present
      expect(img.attribute_value('src').include?(verify_name)).to eq(true)
    end
  end
end

shared_examples "update portal look & feel background external" do |portal_name, portal_type, external_link, verify_name|
  describe "Update the portal's look & feel settings with the background from: '#{external_link}' and verify that the image contains the string '#{verify_name}'" do
    it "Update the background and save" do
      close_the_preview_window
      sleep 0.5
      @ui.click('#guestportal_config_lookfeel_backgroundbutton')
      sleep 2
      add_and_select_external_image(external_link, verify_name)
      sleep 2
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      sleep 0.5
      click_the_first_page_tile
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      frame.wait_until_present
      img = frame.element(:css => ".wrapper.background")
      img.wait_until_present
      expect(img.style).to include(verify_name)
    end
  end
end

shared_examples "update portal look & feel background fill screen" do |portal_name, portal_type, status|
  describe "Update the portal's look & feel settings with the background image to 'Fill screen' as '#{status}'" do
     it "Set the 'powered by Xirrus' as '#{status}' and save" do
      close_the_preview_window
      sleep 0.5
      @ui.click("#backgroundFillScreen + .mac_chk_label")
      sleep 2
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      sleep 0.5
      click_the_first_page_tile
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      if status == "enabled"
        expect(frame.element(:css => ".wrapper.background.background-fill-screen")).to be_visible
      elsif status == "disabled"
        expect(frame.element(:css => ".wrapper.background.background-fill-screen")).not_to exist
      end
    end
  end
end

shared_examples "update portal look & feel color" do |portal_name, portal_type, background_color|
  describe "Update the portal's look & feel settings with the color '#{background_color}'" do
    it "Update the color and save" do
      close_the_preview_window
      sleep 0.5
      colors_list = @ui.get(:elements , {css: ".colors .color"})
      colors_list.each { |color_element|
        if color_element.attribute_value("style").include?(background_color)
          sleep 0.5
          color_element.click
          sleep 0.5
        end
      }
      sleep 0.5
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)

      click_the_first_page_tile
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      bgcolor = frame.element(:css => ".primary_bg_color")
      case background_color
        when "rgb(188, 214, 95)" , "rgb(253, 222, 85)"
          expect(bgcolor.style).to include("color: rgb(51, 51, 51)")
        when "rgb(0, 67, 86)" , "rgb(35, 141, 118)" , "rgb(252, 117, 48)" , "rgb(220, 58, 51)"
          expect(bgcolor.style).to include("color: rgb(255, 255, 255)")
      end
      expect(bgcolor.style).to include("background-color: #{background_color}")
    end
  end
end

shared_examples "update portal look & feel powered by" do |portal_name, portal_type, status|
  describe "Update the portal's look & feel setting for 'Powered by Xirrus' and verify it's properly '#{status}'" do
    it "Set the 'powered by Xirrus' as '#{status}' and save" do
      close_the_preview_window
      sleep 0.5
      @ui.click("#poweredByXirrus + .mac_chk_label")
      sleep 2
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      sleep 0.5
      click_the_first_page_tile
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      if status == "enabled"
        expect(frame.element(:css => ".poweredbyxirrus_wrapper")).to be_visible
      elsif status == "disabled"
        expect(frame.element(:css => ".poweredbyxirrus_wrapper")).not_to be_visible
      end
      close_the_preview_window
    end
  end
end

shared_examples "update portal look & feel require mobile collection" do |portal_name, portal_type, status|
  describe "Update the portal's look & feel setting for 'Require Mobile number collection' and verify it's properly '#{status}'" do
    it "Update the mobile collection and save" do
      close_the_preview_window
      sleep 0.5
      @ui.click('#guestportal_config_lookfeel_view .commonTitle span')
      sleep 1
      @ui.click("#requireMobile + .mac_chk_label")
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      if ["ambassador" , "azure"].include?(portal_type) == false
        @ui.click('.page_tiles_container ul li:nth-child(1)')
        sleep 1
        @ui.show_needed_control(".fullscreen_button")
        sleep 1
        @ui.click('.fullscreen_button')
        sleep 1
        frame = @ui.get(:iframe, { css: '.iframe_preview' })
        if status == "enabled"
          expect(frame.element(:css => ".mobile_required")).to be_visible
        elsif status == "disabled"
          expect(frame.element(:css => ".mobile_required")).not_to be_visible
        end
      else
        if status == "enabled"
          expect(@ui.get(:checkbox, {id: "requireMobile"}).set?).to eq(true)
        elsif status == "disabled"
          expect(@ui.get(:checkbox, {id: "requireMobile"}).set?).to eq(false)
        end
      end
    end
  end
end

shared_examples "update portal look & feel google+" do |portal_name, portal_type, status|
  describe "Update the portal's look & feel setting for 'Google+' and verify it's properly '#{status}'" do
    it "Update google+ and save" do
      close_the_preview_window
      sleep 1
      @ui.click("#google + .mac_chk_label")
      sleep 0.5
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      @ui.click('.page_tiles_container ul li:nth-child(1)')
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      if status == "enabled"
        expect(frame.element(:css => "#login_google")).to be_visible
      elsif status == "disabled"
        expect(frame.element(:css => "#login_google")).not_to be_visible
      end
    end
  end
end

shared_examples "update portal look & feel facebook" do |portal_name, portal_type, status|
  describe "Update the portal's look & feel setting for 'Facebook' and verify it's properly '#{status}'" do
    it "Update facebook and save" do
      close_the_preview_window
      sleep 0.5
      @ui.click("#facebook + .mac_chk_label")
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      @ui.click('.page_tiles_container ul li:nth-child(1)')
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      if status == "enabled"
        expect(frame.element(:css => "#login_facebook")).to be_visible
      elsif status == "disabled"
        expect(frame.element(:css => "#login_facebook")).not_to be_visible
      end
    end
  end
end

shared_examples "update portal look & feel terms of use" do |portal_name, portal_type, status|
  describe "Update the portal's look & feel setting for 'Terms of Use' and verify it's properly '#{status}'" do
    it "Enable TOC and save" do
      close_the_preview_window
      sleep 0.5
      @ui.click("#enableToU + .mac_chk_label")
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      if (portal_type == "onetouch" or portal_type == "personal" or portal_type == "google") and status == "disabled"
        expect(@ui.css('.page_tiles_container ul li:nth-child(3)')).not_to be_visible
      elsif portal_type == "mega" and status == "disabled"
        expect(@ui.css('.page_tiles_container ul li:nth-child(2)')).not_to be_visible
      else
        sleep 1
        if portal_type == "mega"
          @ui.click('.page_tiles_container ul li:nth-child(2)')
        else
          @ui.click('.page_tiles_container ul li:nth-child(3)')
        end
        sleep 1
        @ui.show_needed_control(".fullscreen_button")
        sleep 1
        @ui.click('.fullscreen_button')
        sleep 1
        frame = @ui.get(:iframe, { css: '.iframe_preview' })
        if status == "enabled"
          expect(frame.element(:css => ".terms_of_use")).to be_visible
        elsif status == "disabled"
          expect(frame.element(:css => ".terms_of_use")).not_to be_visible
        end
      end
      close_the_preview_window
    end
  end
end

shared_examples "verify portal look & feel terms of use not present" do |portal_name, portal_type|
  describe "Verify the portal's look & feel setting for 'Terms of Use' isn't displayed" do
    it "Verify TOC and save" do
      close_the_preview_window
      sleep 0.5
      expect(@ui.css('#enableToU')).not_to exist
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
    end
  end
end

shared_examples "update portal look & feel data disclosure" do |portal_name, portal_type, status|
  describe "Update the portal's look & feel setting for 'Data Disclosure' and verify it's properly '#{status}'" do
    it "Disable data disclosure and save" do
      close_the_preview_window
      sleep 0.5
      if status != "verify initial disabled"
        @ui.click("#requireDisclosure + .mac_chk_label")
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        ensure_voucher_portal_is_properly_handled(portal_type)
        sleep 1
        if portal_type == "onetouch"
          page = find_specific_page("One-Click Access")
          page.click
        else
          @ui.click('.page_tiles_container ul li:nth-child(3)')
        end
        sleep 1
        @ui.show_needed_control(".fullscreen_button")
        sleep 1
        @ui.click('.fullscreen_button')
        sleep 1
        frame = @ui.get(:iframe, { css: '.iframe_preview' })
        if status == "enabled"
          expect(frame.element(:css => ".disclaimer")).to be_visible
          expect(frame.element(:css => ".disclaimer").text).to eq("In providing your Personal Data to enable you to use our service, you acknowledge and agree that such Personal Data may be transferred from your current location to the offices and servers of Xirrus, Inc. and the affiliates, agents and service providers referred to herein located in the United States and in other countries.")
        elsif status == "disabled"
          expect(frame.element(:css => ".disclaimer")).not_to be_visible
        end
      else
        expect(@ui.css('#requireDisclosure').attribute_value("disabled")).to eq("true")
        expect(@ui.get(:checkbox , {id: 'requireDisclosure'}).set?).to eq(false)
      end
    end
  end
end

shared_examples "verify page name, description and position" do |page_name, page_position, page_description|
  describe "Verify that the page named '#{page_name}' exists, is at the postion '#{page_position}' and has the proper description" do
    it "Find the page with the position '#{page_position}' and click on it, then verify it's name and description" do
      close_the_preview_window
      sleep 0.5
      pages = @ui.get(:elements , {css: '.innertab .page_tiles_container .ko-hover-scroll .tiles .tile'})
      @searched_for_index = page_position - 1
      pages.each_with_index { |page, index|
        if index == @searched_for_index
          page.click
          sleep 1.5
          expect(page.element(css: ".page_name").text).to eq(page_name)
        end
      }
      expect(@ui.css('.preview .preview_details .page_description .preview_title span').text).to eq(page_name)
      expect(@ui.css('.preview .preview_details .page_description .preview_desc span').text).to eq(page_description)
    end
  end
end

shared_examples "update portal look & feel verify onboarding with authentication" do |portal_name, portal_type|
  describe "Verify that the correct number of pages is displayed for 'Onboarding' portals with User Authentication" do
    it "Update the user authentication and save" do
      close_the_preview_window
      @ui.click('#guestportal_config_tab_general')
      @ui.click('#userauthentication_switch .switch_label')
      @ui.set_input_val("#host", "1.2.3.4")
      @ui.set_input_val("#share", "12345678")
      @ui.set_input_val("#share_confirm", "12345678")
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      h = @ui.get(:text_field, {id: "host"})
      h.wait_until_present
      expect(h.value).to eq("1.2.3.4")
      sh = @ui.get(:text_field, {id: "share"})
      sh.wait_until_present
      expect(sh.value).to eq("--------")
    end
    it "Check that there is the correct number of pages for onboarding with authentication" do
      @ui.click('#guestportal_config_tab_lookfeel')
      sleep 0.5
      c = @ui.css('.page_tiles_container ul')
      c.wait_until_present
      expect(c.lis.select{|li| li.visible?}.length).to eq(2)
    end
  end
end

shared_examples "update portal look & feel client opt in" do |portal_name, portal_type, status, new_text, click|
  describe "Update the portal's look & feel setting for 'Clients Opt in' and verify it's properly '#{status}'" do
    it "#{status} 'Client Opt In' and save" do
      close_the_preview_window
      sleep 0.5
      if click == true
        @ui.css("#clientOptIn + .mac_chk_label").wait_until_present
        @ui.css("#clientOptIn + .mac_chk_label").hover
        sleep 1
        @ui.click('#clientOptIn + .mac_chk_label')
        sleep 1
      end
      if status != "disabled"
        @ui.set_textarea_val("#optInText", new_text)
        sleep 0.5
        @ui.click(".lhs .title")
      end
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      if new_text == ""
        expect(@ui.css('.dialogBox.error')).to be_visible
        sleep 0.5
        @ui.set_textarea_val("#optInText", "rescue from error")
        sleep 0.5
        @ui.click(".lhs .title")
        sleep 1
        save_portal_ensure_no_error_is_displayed(portal_type)
        sleep 1
        expect(@ui.css('.dialogBox.error')).not_to exist
      end
      if status == "enabled"
        expect(@ui.css('#optInText')).to be_visible
        if new_text == ""
          expect(@ui.get(:textarea, {id: 'optInText'}).value).to eq("rescue from error")
        else
          expect(@ui.get(:textarea, {id: 'optInText'}).value).to eq(new_text)
        end
        if portal_type == "self_reg"
          page = find_specific_page("Register Page")
          page.click
        elsif portal_type == "onetouch"
          page = find_specific_page("One-Click Access")
          page.click
        end
        sleep 1
        @ui.show_needed_control(".fullscreen_button")
        sleep 1
        @ui.click('.fullscreen_button')
        sleep 1
        frame = @ui.get(:iframe, { css: '.iframe_preview' })
        expect(frame.element(:css => ".useOptIn")).to be_visible
        if new_text == ""
          expect(frame.element(:css => ".useOptIn .check_label").text).to eq("rescue from error")
        else
          expect(frame.element(:css => ".useOptIn .check_label").text).to eq(new_text)
        end
        ################################### REMEMBER TO FIX ONCE THE ISSUE IS RESOLVED ###################################
        expect([true, false]).to include(frame.checkbox(:css => "#optin_check_register").set?)
        ################################### REMEMBER TO FIX ONCE THE ISSUE IS RESOLVED ###################################
      elsif status == "disabled"
        expect(@ui.css('#optInText')).not_to be_visible
        if portal_type == "self_reg"
          page = find_specific_page("Register Page")
          page.click
        elsif portal_type == "onetouch"
          page = find_specific_page("One-Click Access")
          page.click
          if click == nil
            @ui.css("#clientOptIn + .mac_chk_label").wait_until_present
            @ui.css("#clientOptIn + .mac_chk_label").hover
            expect(@ui.css('#clientOptIn ~ .ko_tooltip_helper')).to be_present
            expect(@ui.css('#clientOptIn ~ .ko_tooltip_helper').parent.attribute_value("class")).to eq("inline ko_tooltip_active")
            expect(@ui.css('.ko_tooltip_content').text).to eq("This option requires email address")
            expect(@ui.css('.ko_tooltip .ko_tooltip_arrow.ko_tooltip_arrow_bottom')).to be_present
          end
        end
        sleep 1
        @ui.show_needed_control(".fullscreen_button")
        sleep 1
        @ui.click('.fullscreen_button')
        sleep 1
        frame = @ui.get(:iframe, { css: '.iframe_preview' })
        expect(frame.element(:css => ".useOptIn")).not_to be_visible
      end
    end
  end
end

shared_examples "verify portal look & feel client opt in feature does not exist" do |portal_name, portal_type|
  describe "Go to the portal's look & feel settings and verify the option 'Clients Opt in' isn't visible for the portal type '#{portal_type}'" do
    it "Search for the option 'Client Opt In' and save" do
      close_the_preview_window
      sleep 0.5
      expect(@ui.css("#clientOptIn")).not_to exist
      expect(@ui.css("#optInText")).not_to exist
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
    end
  end
end

shared_examples "update portal look & feel require email address" do |portal_name, portal_type, status, click|
  describe "Update the portal's look & feel setting for 'Require Email Address' and verify it's properly '#{status}'" do
    it "#{status} 'Email Address' and save" do
      if !@browser.url.include?('/config/lookfeel')
        @ui.click('#guestportal_config_tab_lookfeel')
        sleep 0.5
      end
      close_the_preview_window
      sleep 0.5
      if click == true
        @ui.css("#requireEmail + .mac_chk_label").wait_until_present
        @ui.css("#requireEmail + .mac_chk_label").hover
        sleep 1
        @ui.click('#requireEmail + .mac_chk_label')
        sleep 1
      end
      if status != "disabled"
        expect(@ui.css('#requireDisclosure').attribute_value("disabled")).to eq(nil)
        expect(@ui.css('#clientOptIn').attribute_value("disabled")).to eq(nil)
      else
        expect(@ui.css('#requireDisclosure').attribute_value("disabled")).to eq("true")
        expect(@ui.css('#clientOptIn').attribute_value("disabled")).to eq("true")
      end
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      expect(@ui.css('#requireEmail + .mac_chk_label')).to be_visible
      page = find_specific_page("One-Click Access")
      page.click
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      if status != "disabled"
        expect(frame.element(:css => "#login_form .required_field")).to be_visible
        expect(frame.element(:css => "#login_form .required_field").text).to eq("* Indicates required fields.")
        expect(frame.element(:css => "#guest_email")).to be_visible
        expect(frame.element(:css => "#guest_email .email_label span:first-child").text).to eq("Email")
        expect(frame.element(:css => "#guest_email .email_label span:last-child").text).to eq("*")
        expect(frame.input(:css => "#guest_email .email_input")).to be_present
        expect(frame.input(:css => "#guest_email .email_input").value).to eq("")
      else
        expect(frame.element(:css => "#login_form .required_field")).not_to be_visible
      end
    end
  end
end

shared_examples "update portal title subtitle" do |first_portal_title, first_portal_subtitle, second_portal_title, second_portal_subtitle|
  describe "Update the portal's look & feel settings for 'Portal Title' and 'Portal Subtitle' (Composite portals)" do
    it "Set '#{first_portal_title}', '#{first_portal_subtitle}', '#{second_portal_title}', '#{second_portal_subtitle}' on the Composite Portal Look&Feel page" do
      if !@browser.url.include?('/config/lookfeel')
        @ui.click('#guestportal_config_tab_lookfeel')
        sleep 0.5
      end
      close_the_preview_window
      sleep 0.5
      if first_portal_title != nil
        @ui.set_input_val("#guestportal_config_lookfeel_portal1_title", first_portal_title) and sleep 1
      end
      if first_portal_subtitle != nil
        @ui.set_input_val("#guestportal_config_lookfeel_portal1_subtitle", first_portal_subtitle) and sleep 1
      end
      if second_portal_title != nil
        @ui.set_input_val("#guestportal_config_lookfeel_portal2_title", second_portal_title) and sleep 1
      end
      if second_portal_subtitle != nil
        @ui.set_input_val("#guestportal_config_lookfeel_portal2_subtitle", second_portal_subtitle) and sleep 1
      end
      save_portal_ensure_no_error_is_displayed("mega")
      sleep 1
      verify_values_hash = Hash["#guestportal_config_lookfeel_portal1_title" => first_portal_title, "#guestportal_config_lookfeel_portal1_subtitle" => first_portal_subtitle, "#guestportal_config_lookfeel_portal2_title" => second_portal_title, "#guestportal_config_lookfeel_portal2_subtitle" => second_portal_subtitle]
      verify_values_hash.keys.each do |key|
        expect(@ui.get(:input, {css: key}).value).to eq(verify_values_hash[key])
      end
      page = find_specific_page("Welcome Page")
      page.click
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      expect(frame.element(:id => 'portal1_button').text).to eq(first_portal_title.upcase)
      expect(frame.element(:id => 'portal2_button').text).to eq(second_portal_title.upcase)
    end
    it "Close the preview window (if visible)" do
      close_the_preview_window
    end
  end
end

shared_examples "update custom text" do |text|
  describe "Update the portal's look & feel setting for 'Custom Text' input field with the value '#{text}'" do
    it "Set '#{text}' for the 'Custom Text' input field" do
      if !@browser.url.include?('/config/lookfeel')
        @ui.click('#guestportal_config_tab_lookfeel')
        sleep 0.5
      end
      close_the_preview_window
      sleep 0.5
      @ui.set_textarea_val('#guestportal_config_lookfeel_customtext_input', text) and sleep 1
      save_portal_ensure_no_error_is_displayed("mega")
      sleep 1
      expect(@ui.get(:textarea, {id: 'guestportal_config_lookfeel_customtext_input'}).value).to eq(text)
      page = find_specific_page("Welcome Page")
      page.click
      sleep 1
      @ui.show_needed_control(".fullscreen_button")
      sleep 1
      @ui.click('.fullscreen_button')
      sleep 1
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      expect(frame.element(:id => "welcome_msg")).to be_visible
      expect(frame.element(:id => "welcome_msg").text).to eq(text)
    end
  end
end


def select_success_page_and_verify_localized_string_content(language, your_password_verify, click_below_verify)
  @ui.click('#guestportal_config_tab_general')
  sleep 2
  @ui.set_dropdown_entry("guestportal_config_basic_language", language)
  sleep 1
  @ui.click('#guestportal_config_tab_lookfeel')
  sleep 2
  pages = @ui.get(:elements , {css: '.innertab .page_tiles_container .ko-hover-scroll .tiles .tile'})
  pages.each { |page|
    if page.element(css: ".page_name").text == "Success! Page"
      page.click
      sleep 1
    end
  }
  iframe = @ui.get(:iframe ,{css: "#guestportal_config_lookfeel_view .innertab .preview .preview_wrap .iframe_wrap .iframe_preview"})
  your_password_text = iframe.element(css: ".require_self_validation div:nth-child(1)").text
  if language == "繁體中文"
    index = your_password_text.index("：")
  else
    index = your_password_text.index(":")
  end
  expect(your_password_text[0..index]).to eq(your_password_verify)
  click_below_text = iframe.element(css: ".require_self_validation").text
  index = click_below_text.index("11111")+6
  if language == "简体中文"
    index2 = click_below_text.index("。\n")
  elsif language == "繁體中文"
    index2 = click_below_text.index("入：\n")
  else
    index2 = click_below_text.index(".\n")
  end
  expect(click_below_text[index..index2]).to eq(click_below_verify)
end


shared_examples "update self reg authentication to connect" do |portal_name, portal_type|
  describe "Update the Authentication to Connect - - #{portal_type.upcase}" do
    it "Go to the 'General' tab and update the 'Require Authentication to Connect' switch" do
      @ui.click('#guestportal_config_tab_general')
      sleep 2
      @ui.click('#require_self_validation .switch_label')
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      expect(@ui.get(:checkbox , {id: "require_self_validation_switch"}).set?).to eq(true)
    end
    it "Verify the 'Success!' page on 'ENGLISH'" do
      select_success_page_and_verify_localized_string_content("English", "Your password has been sent to:", "After you retrieve your credentials, click below to login.")
    end
    it "Verify the 'Success!' page on 'Español (América Latina)'" do
      select_success_page_and_verify_localized_string_content("Español (América Latina)", "Su contraseña se ha enviado a:", "Después de recibir sus credenciales, por favor haz clic abajo.")
    end
    it "Verify the 'Success!' page on 'Español'" do
      select_success_page_and_verify_localized_string_content("Español", "La contraseña se le ha enviado a:", "Después de recuperar sus credenciales, haga clic a continuación para iniciar sesión.")
    end
    it "Verify the 'Success!' page on 'Nedherlands'" do
      select_success_page_and_verify_localized_string_content("Nederlands", "Logingegevens zijn verzonden naar:", "Gelieve hier in te loggen na het ophalen van je logingegevens.")
    end
    it "Verify the 'Success!' page on 'Deutch'" do
      select_success_page_and_verify_localized_string_content("Deutsch", "Wurde Ihr Kennwort an folgendes Ziel:", "Nachdem sie ihre Anmeldeinformationen abgerufen haben, klicken Sie unten um sich anzumelden.")
    end
    it "Verify the 'Success!' page on 'Português (Brasil)'" do
      select_success_page_and_verify_localized_string_content("Português (Brasil)", "Sua senha foi enviada para:", "Após recuperar suas credenciais, click abaixo para acessar.")
    end
    it "Verify the 'Success!' page on 'Français'" do
      select_success_page_and_verify_localized_string_content("Français", "Votre mot de passe a été envoyé à l'adresse:", "Après avoir obtenu vos informations d'identification, cliquez ci-dessous pour vous connecter.")
    end
    it "Verify the 'Success!' page on 'Français (Canadien)'" do
      select_success_page_and_verify_localized_string_content("Français (Canadien)", "Votre mot de passe a été envoyé à l'adresse:", "Après avoir obtenu vos informations d'identification, cliquez ci-dessous pour vous connecter.")
    end
    it "Verify the 'Success!' page on 'Italiano'" do
      select_success_page_and_verify_localized_string_content("Italiano", "La password è stata inviata ai seguenti recapiti:", "Dopo aver recuperato le credenziali, clicca qui sotto per accedere.")
    end
    it "Verify the 'Success!' page on 'Chinese (Traditional)'" do
      select_success_page_and_verify_localized_string_content("繁體中文", "您的密碼已傳送到：", "收到密碼後，請由下方登入")
    end
    it "Verify the 'Success!' page on 'Chinese (Simplified)'" do
      select_success_page_and_verify_localized_string_content("简体中文", "您的密码已发送到:", "您找回您的凭据后，点击下面登录。")
    end
  end
end

############################################################################################################################

shared_examples "update portal look & feel" do |portal_name, portal_type, company_name|
  it_behaves_like "go to portal look feel tab", portal_name
  it_behaves_like "update portal look & feel company name", portal_name, portal_type, company_name
  it_behaves_like "update portal look & feel logo external", portal_name, portal_type, 'https://i.imgur.com/4VOBizw.jpg', '4VOBizw'
  it_behaves_like "update portal look & feel color", portal_name, portal_type, "rgb(0, 67, 86)"
  it_behaves_like "update portal look & feel color", portal_name, portal_type, "rgb(35, 141, 118)"
  it_behaves_like "update portal look & feel color", portal_name, portal_type, "rgb(188, 214, 95)"
  it_behaves_like "update portal look & feel color", portal_name, portal_type, "rgb(253, 222, 85)"
  it_behaves_like "update portal look & feel color", portal_name, portal_type, "rgb(252, 117, 48)"
  it_behaves_like "update portal look & feel color", portal_name, portal_type, "rgb(220, 58, 51)"
  case portal_type
    when "ambassador", "self_reg", "onetouch", "voucher", "azure", "mega"
      if portal_type != "azure"
        it_behaves_like "update portal look & feel background external", portal_name, portal_type, 'https://i.imgur.com/4VOBizw.jpg', '4VOBizw'
        it_behaves_like "update portal look & feel background fill screen", portal_name, portal_type, "enabled"
        it_behaves_like "update portal look & feel background fill screen", portal_name, portal_type, "disabled"
      end
      if portal_type == "self_reg"
        it_behaves_like "update portal look & feel google+", portal_name, portal_type, "enabled"
        it_behaves_like "update portal look & feel google+", portal_name, portal_type, "disabled"
        it_behaves_like "update portal look & feel facebook", portal_name, portal_type, "enabled"
        it_behaves_like "update portal look & feel require mobile collection", portal_name, portal_type, "enabled"
        it_behaves_like "update portal look & feel require mobile collection", portal_name, portal_type, "disabled"
        it_behaves_like "update portal look & feel facebook", portal_name, portal_type, "disabled"
      elsif portal_type == "ambassador"
        it_behaves_like "update portal look & feel require mobile collection", portal_name, portal_type, "enabled"
        it_behaves_like "update portal look & feel require mobile collection", portal_name, portal_type, "disabled"
      end
      if ["self_reg", "onetouch"].include?(portal_type) == true
        it_behaves_like "update portal look & feel client opt in", portal_name, portal_type, "disabled", nil
        if portal_type == "onetouch"
          it_behaves_like "update portal look & feel data disclosure",  portal_name, portal_type, "verify initial disabled"
          it_behaves_like "update portal look & feel require email address", portal_name, portal_type, "disabled", false
          it_behaves_like "update portal look & feel require email address", portal_name, portal_type, "enabled", true
          it_behaves_like "update portal look & feel data disclosure",  portal_name, portal_type, "enabled"
          it_behaves_like "update portal look & feel data disclosure",  portal_name, portal_type, "disabled"
        end
        it_behaves_like "update portal look & feel client opt in", portal_name, portal_type, "enabled", "This is a test message !!!", true
        it_behaves_like "update portal look & feel client opt in", portal_name, portal_type, "disabled", "No text needed", true
        it_behaves_like "update portal look & feel client opt in", portal_name, portal_type, "enabled", "Yes! I want to be the first to hear about promotions from Xirrus.", true
        if portal_type == "onetouch"
          it_behaves_like "update portal look & feel require email address", portal_name, portal_type, "disabled", true
          it_behaves_like "update portal look & feel client opt in", portal_name, portal_type, "disabled", nil
        end
      end
      if ["ambassador", "azure"].include?(portal_type) == false
        it_behaves_like "update portal look & feel terms of use", portal_name, portal_type, "enabled"
        it_behaves_like "update portal look & feel terms of use", portal_name, portal_type, "disabled"
      end
      if ["onetouch", "voucher", "ambassador","mega", "azure"].include?(portal_type) == false
        it_behaves_like "update portal look & feel data disclosure", portal_name, portal_type, "disabled"
        it_behaves_like "update portal look & feel data disclosure", portal_name, portal_type, "enabled"
      end
      if portal_type == "mega"
        it_behaves_like "update portal title subtitle", "FIRST", "SECOND", "THIRD", "FOURTH"
        it_behaves_like "update portal title subtitle", "First Portal Name", "", "Second Portal Name", ""
        it_behaves_like "update custom text", "Test text to appear above the 'Connect' section"
        it_behaves_like "update portal look & feel terms of use", portal_name, portal_type, "enabled"
        it_behaves_like "update portal look & feel terms of use", portal_name, portal_type, "disabled"
      end
    when "onboarding"
      it_behaves_like "update portal look & feel verify onboarding with authentication", portal_name, portal_type
    when "personal"
      it_behaves_like "update portal look & feel terms of use", portal_name, portal_type, "enabled"
      it_behaves_like "update portal look & feel terms of use", portal_name, portal_type, "disabled"
    when "google", "azure"
      it_behaves_like "verify portal look & feel terms of use not present", portal_name, portal_type
  end
  it_behaves_like "update portal look & feel powered by", portal_name, portal_type, "disabled"
  it_behaves_like "update portal look & feel powered by", portal_name, portal_type, "enabled"
  if ["self_reg", "onetouch"].include?(portal_type) == false
    it_behaves_like "verify portal look & feel client opt in feature does not exist", portal_name, portal_type
  end
end

############################################################################################################################

def return_certain_string_based_on_language(string, language)
  case language
    when "简体中文"
      strings_hash = Hash["Voucher Header Login Title" => "登录\n的 无线上网服务", "Self-Reg Header Login Title" => "注册或登录\n的 无线上网服务", "Forgot Password" => "忘记密码了？", "Username Placeholder" => "用户名", "Password Placeholder" => "密码", "Ambassador & Voucher Login Title" => "登录" ,"Login Title" => "登录\n的 无线上网服务", "Greeting string" => "Guest 您好，", "Access will expire" => "您的访问权限将在 # 天后到期。", "Need to login again" => "您可能需要每 # 小时重新登录一次。", "Did not request" => "如果您没有申请使用无线上网服务，则可能有人代您申请此项服务，或者不小心输入了您的电子邮件地址。如果您认为此封邮件内容与您无关，您可安全删除此邮件。", "Username String" => "用户名:", "Password String" => "密码:", "Subject String" => "访客无线上网密码", "Voucher Login Button" => "同意并登录", "Login Button" => "登录", "Logo Title" => "无线上网门户", "Register Button" => "注册", "Need New Account" => "需要新帐户？", "Register Link" => "注册", "Register Page" => "", "Register Page Title" => "注册", "Register Page Subtitle" => "注册以使用 的无线上网服务","Guest Name Label" => "访客姓名", "Email Label" => "电子邮件", "Mobile Label" => "手机", "Mobile Checkbox Label" => "除电子邮件之外，也可以通过短信接收密码。", "Cancel Bzutton" => "取消", "Submit Button Self-Registration" => "同意并注册", "Submit Button" => "注册为访客", "Already Registered" => "已经注册？", "Login Link" => "登录", "Powered by string Email" => "Xirrus 提供技术支持", "Powered by string" => "技术支持", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "使用条款", "TOU Description" => "请阅读使用条款，然后再继续注册。", "TOU Close Btn" => "完成", "Registration Successfull" => "注册成功！", "Registration Login Bzutton" => "访问 WEB！"]
    when "繁體中文"
      strings_hash = Hash["Voucher Header Login Title" => "登入\n無線上網服務", "Self-Reg Header Login Title" => "註冊或登入\n無線上網服務", "Forgot Password" => "忘記密碼？", "Username Placeholder" => "用戶名", "Password Placeholder" => "密碼", "Ambassador & Voucher Login Title" => "登入" ,"Login Title" => "登入\n無線上網服務", "Greeting string" => "Guest 您好，", "Access will expire" => "您的使用權限將於 # 天內過期。", "Need to login again" => "您可能需要每隔 # 小時重新登入一次。", "Did not request" => "若您並沒有申請使用無線上網服務，則可能有人代您申請此項服務，或是不小心輸入您的電子郵件地址。若您確定這些訊息內容與您無關，您可放心地刪除此封訊息。", "Username String" => "用戶名：", "Password String" => "密碼：", "Subject String" => "訪客無線上網密碼", "Voucher Login Button" => "同意並登入", "Login Button" => "登入", "Logo Title" => "無線上網入口網站", "Register Button" => "註冊", "Need New Account" => "需要新帳號？", "Register Link" => "註冊", "Register Page" => "", "Register Page Title" => "註冊", "Register Page Subtitle" => "註冊以使用 無線上網服務","Guest Name Label" => "訪客姓名", "Email Label" => "電子郵件", "Mobile Label" => "手機", "Mobile Checkbox Label" => "除電子郵件之外，也透過簡訊接收密碼。", "Cancel Bzutton" => "取消", "Submit Button Self-Registration" => "同意並註冊", "Submit Button" => "註冊為訪客", "Already Registered" => "已經註冊？", "Login Link" => "登入", "Powered by string Email" => "Xirrus 技術提供", "Powered by string" => "技術提供", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "使用條款", "TOU Description" => "在註冊前，請先審閱使用條款。", "TOU Close Btn" => "完成", "Registration Successfull" => "註冊成功！", "Registration Login Bzutton" => "使用無線上網服務！"]
    when "Nederlands"
      strings_hash = Hash["Voucher Header Login Title" => "meld u aan bij\nom toegang te krijgen tot Wi-Fi.", "Self-Reg Header Login Title" => "Registreer u of meld u aan bij\nom toegang te krijgen tot Wi-Fi.", "Forgot Password" => "Bent u uw wachtwoord vergeten?", "Username Placeholder" => "gebruikersnaam", "Password Placeholder" => "wachtwoord", "Ambassador & Voucher Login Title" => "Aanmelden" ,"Login Title" => "meld u aan bij\nom toegang te krijgen tot Wi-Fi.", "Greeting string" => "Dag Guest,", "Access will expire" => "Uw toegang verloopt over # dag(en).", "Need to login again" => "Mogelijk moet u zich om de # uur opnieuw aanmelden.", "Did not request" => "Als u geen gasttoegang hebt aangevraagd, heeft iemand anders dit mogelijk voor u gedaan of heeft iemand per ongeluk uw e-mailadres ingevoerd. Als u denkt dat u dit bericht niet had moeten ontvangen, kunt u het zonder problemen verwijderen.", "Username String" => "gebruikersnaam:", "Password String" => "wachtwoord:", "Subject String" => "Wachtwoord voor Gast-Wi-Fi", "Voucher Login Button" => "INSTEMMEN EN AANMELDEN", "Login Button" => "AANMELDEN", "Logo Title" => "WI-FI-PORTAL", "Register Button" => "Registreren", "Need New Account" => "Wilt u een nieuw account maken?", "Register Link" => "Registreren", "Register Page" => "", "Register Page Title" => "Registreren", "Register Page Subtitle" => "Registeer u bij om toegang te krijgen tot Wi-Fi","Guest Name Label" => "Gastennaam", "Email Label" => "E-mail", "Mobile Label" => "Mobiel", "Mobile Checkbox Label" => "Wachtwoord ontvangen via sms-bericht en e-mail.", "Cancel Bzutton" => "Annuleren", "Submit Button Self-Registration" => "INSTEMMEN EN REGISTREREN", "Submit Button" => "REGISTREER u als gast", "Already Registered" => "Bent u al geregistreerd?", "Login Link" => "Aanmelden", "Powered by string Email" => "Mogelijk gemaakt door Xirrus", "Powered by string" => "MOGELIJK GEMAAKT DOOR", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Gebruiksrechtovereenkomst", "TOU Description" => "Lees de Gebruiksrechtovereenkomst voordat u verdergaat met de registratie.", "TOU Close Btn" => "GEREED", "Registration Successfull" => "De registratie is voltooid.", "Registration Login Bzutton" => "TOEGANG TOT INTERNET."]
    when "English"
      strings_hash = Hash["Voucher Header Login Title" => "Login to access Wi-Fi at", "Self-Reg Header Login Title" => "Register or Login to access Wi-Fi at", "Forgot Password" => "Forgot Password?", "Username Placeholder" => "username", "Password Placeholder" => "password", "Ambassador & Voucher Login Title" => "Login" ,"Login Title" => "Connect to Wi-Fi at", "Greeting string" => "Hello Guest,", "Access will expire" => "Your access will expire in # day(s).", "Need to login again" => "You may need to login again every # hour(s).", "Did not request" => "If you did not request guest access, someone may have done so for you, or someone may have entered your email address by mistake. If you believe you've received this message in error, it is safe to delete this message.", "Username String" => "username:", "Password String" => "password:", "Subject String" => "Guest Wi-Fi Password", "Voucher Login Button" => "AGREE & LOGIN", "Login Button" => "LOGIN", "Logo Title" => "WI-FI PORTAL", "Register Button" => "Register", "Connect Button" => "CONNECT", "Connect Button with email" => "AGREE & CONNECT", "Need New Account" => "Need a new account?", "Register Link" => "Register", "Register Page" => "", "Register Page Title" => "Register", "Register Page Subtitle" => "Register to access Wi-Fi at","Guest Name Label" => "Guest Name", "Email Label" => "Email", "Mobile Label" => "Mobile", "Mobile Checkbox Label" => "Receive password via text message in addition to email.", "Cancel Bzutton" => "Cancel", "Submit Button Self-Registration" => "AGREE & REGISTER", "Submit Button" => "REGISTER as a guest", "Already Registered" => "Already registered?", "Login Link" => "Login", "Powered by string Email" => "Powered by Xirrus", "Powered by string" => "POWERED BY", "Required aid" => "* Indicates required fields.", "Terms of Use" => "By clicking the button below, I agree to the Terms of Use.", "Data Disclaimer" => "In providing your Personal Data to enable you to use our service, you acknowledge and agree that such Personal Data may be transferred from your current location to the offices and servers of Xirrus, Inc. and the affiliates, agents and service providers referred to herein located in the United States and in other countries.", "Access Expired" => "Access expired", "Expired String" => "Your session has expired.", "Start New Session" => "You can begin a new session:", "TOU Title" => "Terms of Use", "TOU Description" => "Please review the Terms of Use before proceeding with registration.", "Close Button" => "DONE", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Close Btn" => "DONE", "Registration Successfull" => "Registration Successful!", "Registration Login Bzutton" => "ACCESS THE WEB!"]
    when "Français"
      strings_hash = Hash["Voucher Header Login Title" => "se connecter pour accéder au Wi-Fi chez", "Self-Reg Header Login Title" => "S'enregistrer ou se connecter pour accéder au Wi-Fi chez", "Forgot Password" => "Mot de passe oublié ?", "Username Placeholder" => "nom d'utilisateur", "Password Placeholder" => "mot de passe", "Ambassador & Voucher Login Title" => "Se connecter" ,"Login Title" => "Connectez à une connexion Wi-Fi à", "Greeting string" => "Bonjour Guest,", "Access will expire" => "Votre accès expirera dans # jour(s).", "Need to login again" => "Vous devrez peut-être vous reconnecter toutes les # heure(s).", "Did not request" => "Si vous n'avez pas demandé d'accès invité, un tiers l'a peut-être fait pour vous ou a saisi votre adresse e-mail par erreur. Si vous pensez avoir reçu ce message par erreur, supprimez-le par sécurité.", "Username String" => "nom d'utilisateur :", "Password String" => "mot de passe :", "Subject String" => "Mot de passe du Wi-Fi invité", "Voucher Login Button" => "ACCEPTER ET SE CONNECTER", "Login Button" => "SE CONNECTER", "Logo Title" => "PORTAIL WI-FI", "Register Button" => "S'enregistrer", "Connect Button" => "CONNECTER", "Connect Button with email" => "ACCEPTER ET SE CONNECTER", "Need New Account" => "Vous avez besoin d'un nouveau compte ?", "Register Link" => "S'enregistrer", "Register Page" => "", "Register Page Title" => "S'enregistrer", "Register Page Subtitle" => "S'enregistrer pour accéder au Wi-Fi chez", "Guest Name Label" => "Nom de l'invité", "Email Label" => "E-mail", "Mobile Label" => "Portable", "Mobile Checkbox Label" => "Recevoir le mot de passe via un message texte en plus de l'e-mail.", "Cancel Bzutton" => "Annuler", "Submit Button Self-Registration" => "ACCEPTER ET S'ENREGISTRER", "Submit Button" => "S'ENREGISTRER en tant qu'invité", "Already Registered" => "Déjà enregistré ?", "Login Link" => "Se connecter", "Powered by string Email" => "Généré par Xirrus", "Powered by string" => "GÉNÉRÉ PAR", "Required aid" => "* Indique les champs obligatoires.", "Terms of Use" => "En cliquant sur le bouton ci-après, j'accepte les Conditions générales.", "Data Disclaimer" => "En fournissant vos données personnelles pour que vous puissiez utiliser nos services, vous reconnaissez et acceptez que ces données puissent être transférées de votre localisation actuelle vers nos bureaux et serveurs Xirrus, Inc. et vers les associés, agents et prestataires de services cités ici situés aux États-Unis et dans d'autres pays.", "Access Expired" => "Accès périmé", "Expired String" => "Votre session a expiré.", "Start New Session" => "Commencer une nouvelle session:", "TOU Title" => "Conditions générales", "TOU Description" => "Veuillez lire les conditions générales avant de poursuivre l'enregistrement.", "Close Button" => "TERMINÉ", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Close Btn" => "TERMINÉ", "Registration Successfull" => "Enregistrement réussi !", "Registration Login Bzutton" => "ACCÈS À INTERNET !"]
    when "Deutsch"
      strings_hash = Hash["Voucher Header Login Title" => "Melden Sie sich an um auf das Wi-Fi bei\nzuzugreifen", "Self-Reg Header Login Title" => "Registrieren Sie sich oder Melden Sie sich an um auf das Wi-Fi bei\nzuzugreifen", "Forgot Password" => "Kennwort vergessen?", "Username Placeholder" => "Benutzername", "Password Placeholder" => "Kennwort", "Ambassador & Voucher Login Title" => "Anmelden" ,"Login Title" => "Verbinden Sie sich mit dem\n- Wi-Fi", "Greeting string" => "Hallo Guest,", "Access will expire" => "Ihr Zugang erlischt in # Tag(en).", "Need to login again" => "Eventuell müssen Sie sich nach jeweils # Stunde(n) erneut anmelden.", "Did not request" => "Falls Sie keinen Gastzugang angefordert haben, hat dies möglicherweise jemand in Ihrem Namen getan oder aus Versehen Ihre E-Mail-Adresse angegeben. Sollten Sie diese Nachricht irrtümlich erhalten haben, können Sie sie einfach löschen.", "Username String" => "Benutzername:", "Password String" => "Kennwort:", "Subject String" => "Kennwort für Gast-Wi-Fi", "Voucher Login Button" => "ZUSTIMMEN UND ANMELDEN", "Login Button" => "ANMELDEN", "Logo Title" => "WI-FI-PORTAL", "Register Button" => "Registrieren", "Need New Account" => "Brauchen Sie ein neues Konto?", "Register Link" => "Registrieren", "Register Page" => "", "Register Page Title" => "Registrieren", "Register Page Subtitle" => "Registrieren, um auf das Wi-Fi bei zuzugreifen","Guest Name Label" => "Name des Gasts", "Email Label" => "E-Mail-Adresse", "Mobile Label" => "Handynummer", "Mobile Checkbox Label" => "Zusätzlich zur E-Mail können Sie Ihr Kennwort auch per SMS erhalten.", "Cancel Bzutton" => "Abbrechen", "Submit Button Self-Registration" => "ZUSTIMMEN und REGISTRIEREN", "Submit Button" => "REGISTRIEREN Sie sich als Gast", "Already Registered" => "Sie haben sich bereits registriert?", "Login Link" => "Anmelden", "Powered by string Email" => "Powered by Xirrus", "Powered by string" => "POWERED BY", "Connect Devices Button" => "Verbinden", "Connect Button" => "VERBINDEN", "Access Expired" => "Zugang abgelaufen", "Expired String" => "Ihre Zugangszeit ist abgelaufen.", "Start New Session" => "Sie können eine neue Sitzung beginnen ab:", "Connect Button with email" => "Zustimmen & Verbinden", "Required aid" => "* Mit Sternchen gekennzeichnete Felder müssen ausgefüllt werden.", "Terms of Use" => "Durch Klicken auf die unten angezeigte Schaltfläche akzeptiere ich die Nutzungsbedingungen.", "Data Disclaimer" => "Durch die Angabe Ihrer persönlichen Daten für die Nutzung unseres Diensts bestätigen und erklären Sie, dass diese persönlichen Daten von Ihrem aktuellen Standort an die Niederlassungen und Server von Xirrus, Inc., sowie die genannten Partner, Vertreter und Dienstanbieter in den USA und anderen Ländern weitergegeben werden dürfen.", "Manage Devices Subtitle" => "Sie k\u00F6nnen nur bis zu # Ger\u00E4te registrieren.\nBevor Sie weitere Ger\u00E4te verbinden k\u00F6nnen, m\u00FCssen Sie mindestens ein anderes Ger\u00E4t entfernen.", "TOU Title" => "Nutzungsbedingungen", "TOU Description" => "Bitte lesen Sie die Nutzungsbedingungen, bevor Sie die Registrierung fortsetzen.","TOU Close Btn" => "FERTIG", "Close Button" => "FERTIG", "Registration Successfull" => "Sie haben sich erfolgreich registriert!", "Registration Login Bzutton" => "GREIFEN SIE AUF DAS WEB ZU!"]
    when "Ελληνικά"
      strings_hash = Hash["Voucher Header Login Title" => "Συνδεθείτε για να αποκτήσετε πρόσβαση στο Wi-Fi στην", "Self-Reg Header Login Title" => "Εγγραφείτε ή Συνδεθείτε για να αποκτήσετε πρόσβαση στο Wi-Fi στην", "Forgot Password" => "Ξεχάσατε τον κωδικό πρόσβασης;", "Username Placeholder" => "όνομα χρήστη", "Password Placeholder" => "κωδικός πρόσβασης", "Ambassador & Voucher Login Title" => "Σύνδεση" ,"Login Title" => "Συνδεθείτε για να αποκτήσετε πρόσβαση στο Wi-Fi στην", "Greeting string" => "Γεια σας Guest,", "Access will expire" => "Η πρόσβασή σας θα λήξει σε# ημέρα(ες).", "Need to login again" => "Ενδέχεται να απαιτείται ανανέωση της σύνδεσής σας κάθε # ώρα(ες).", "Did not request" => "Εάν δεν έχετε ζητήσει πρόσβαση ως επισκέπτης, ενδέχεται κάποιος να το έκανε για εσάς ή ενδέχεται κάποιος να καταχώρησε το email σας κατά λάθος. Εάν πιστεύετε ότι έχετε λάβει αυτό το μήνυμα κατά λάθος, είναι ασφαλές να διαγράψετε το μήνυμα.", "Username String" => "όνομα χρήστη:", "Password String" => "κωδικός πρόσβασης:", "Subject String" => "Κωδικός πρόσβασης Wi-Fi επισκέπτη", "Voucher Login Button" => "ΣΥΜΦΩΝΩ ΚΑΙ ΣΥΝΔΕΣΗ", "Login Button" => "Σύνδεση", "Logo Title" => "ΠΥΛΗ WI-FI", "Register Button" => "Εγγραφή", "Need New Account" => "Χρειάζεστε νέο λογαριασμό;", "Register Link" => "Εγγραφή", "Register Page" => "", "Register Page Title" => "Εγγραφή", "Register Page Subtitle" => "Εγγραφείτε για να έχετε πρόσβαση στο Wi-Fi στην","Guest Name Label" => "Όνομα επισκέπτη", "Email Label" => "Email", "Mobile Label" => "Αριθμός κινητού τηλεφώνου", "Mobile Checkbox Label" => "Επιθυμώ να λάβω τον κωδικό πρόσβασής μου και με μήνυμα κειμένου εκτός από email.", "Cancel Bzutton" => "Ακύρωση", "Submit Button Self-Registration" => "ΣΥΜΦΩΝΗΣΤΕ ΚΑΙ ΕΓΓΡΑΦΕΙΤΕ", "Submit Button" => "ΕΓΓΡΑΦΗ ως επισκέπτης", "Already Registered" => "Είστε ήδη εγγεγραμμένος;", "Login Link" => "Σύνδεση", "Powered by string Email" => "Χρηματοδοτούμενο από την Xirrus", "Powered by string" => "ΧΡΗΜΑΤΟΔΟΤΟΥΜΕΝΟ ΑΠΟ", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Όρους Χρήσης", "TOU Description" => "Διαβάστε τους Όρους Χρήσης πριν προχωρήσετε με την εγγραφή.", "TOU Close Btn" => "ΤΕΛΟΣ", "Registration Successfull" => "Η εγγραφή σας είναι επιτυχής!", "Registration Login Bzutton" => "ΑΠΟΚΤΉΣΤΕ ΠΡΌΣΒΑΣΗ ΣΤΟ ΔΙΑΔΊΚΤΥΟ!"]
    when "Bahasa Indonesia"
      strings_hash = Hash["Voucher Header Login Title" => "Login untuk mengakses Wi-Fi di", "Self-Reg Header Login Title" => "Daftar atau Login untuk mengakses Wi-Fi di", "Forgot Password" => "Lupa Kata Sandi?", "Username Placeholder" => "nama pengguna", "Password Placeholder" => "kata sandi", "Ambassador & Voucher Login Title" => "Login" ,"Login Title" => "Login untuk mengakses Wi-Fi di", "Greeting string" => "Halo Guest,", "Access will expire" => "Akses Anda akan berakhir dalam # hari.", "Need to login again" => "Anda mungkin perlu masuk lagi setiap # jam.", "Did not request" => "Jika Anda tidak meminta akses tamu, seseorang mungkin telah melakukannya untuk Anda, atau memasukkan alamat email Anda secara tidak sengaja. Jika Anda yakin pesan ini muncul karena kesalahan, Anda dapat menghapus pesan ini dengan aman.", "Username String" => "nama pengguna:", "Password String" => "kata sandi:", "Subject String" => "Kata sandi Wi-Fi Tamu", "Voucher Login Button" => "SETUJU & LOGIN", "Login Button" => "LOGIN", "Logo Title" => "PORTAL WI-FI", "Register Button" => "Daftar", "Need New Account" => "Perlu akun baru?", "Register Link" => "Daftar", "Register Page" => "", "Register Page Title" => "Daftar", "Register Page Subtitle" => "Daftar untuk mengakses Wi-Fi di","Guest Name Label" => "Nama Tamu", "Email Label" => "Email", "Mobile Label" => "Seluler", "Mobile Checkbox Label" => "Selain lewat email, dapatkan juga kata sandi lewat pesan teks.", "Cancel Bzutton" => "Batal", "Submit Button Self-Registration" => "SETUJU & DAFTAR", "Submit Button" => "DAFTAR sebagai tamu", "Already Registered" => "Sudah terdaftar?", "Login Link" => "Login", "Powered by string Email" => "Didukung oleh Xirrus", "Powered by string" => "DIDUKUNG OLEH", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Syarat Penggunaan", "TOU Description" => "Bacalah Syarat Penggunaan sebelum melanjutkan proses pendaftaran.", "TOU Close Btn" => "SELESAI", "Registration Successfull" => "Pendaftaran Berhasil!", "Registration Login Bzutton" => "AKSES SITUS WEB!"]
    when "Italiano"
      strings_hash = Hash["Voucher Header Login Title" => "l'accesso per accedere alla rete Wi-Fi di", "Self-Reg Header Login Title" => "Eseguire la registrazione o l'accesso per accedere alla rete Wi-Fi di", "Forgot Password" => "Password dimenticata?", "Username Placeholder" => "nome utente", "Password Placeholder" => "password", "Ambassador & Voucher Login Title" => "Accedi" ,"Login Title" => "l'accesso per accedere alla rete Wi-Fi di", "Greeting string" => "Salve Guest,", "Access will expire" => "L'accesso scadrà fra # giorni.", "Need to login again" => "È possibile che debba eseguire di nuovo l'accesso ogni # ore.", "Did not request" => "Se non ha richiesto l'accesso guest, è possibile che lo abbia fatto qualcun altro o che qualcuno abbia immesso il suo indirizzo e-mail per errore. Se ritiene di avere ricevuto questo messaggio per sbaglio, può cancellarlo.", "Username String" => "nome utente:", "Password String" => "password:", "Subject String" => "Password Wi-Fi guest", "Voucher Login Button" => "ACCETTA e ACCEDI", "Login Button" => "ACCEDI", "Logo Title" => "PORTALE WI-FI", "Register Button" => "Registrati", "Need New Account" => "Occorre un nuovo account?", "Register Link" => "Registrati", "Register Page" => "", "Register Page Title" => "Registrati", "Register Page Subtitle" => "Registrati per accedere alla rete Wi-Fi di","Guest Name Label" => "Nome guest", "Email Label" => "E-mail", "Mobile Label" => "Dispositivo mobile", "Mobile Checkbox Label" => "La password verrà inviata tramite SMS e per e-mail.", "Cancel Bzutton" => "Annulla", "Submit Button Self-Registration" => "ACCETTA E REGISTRATI", "Submit Button" => "Effettua REGISTRAZIONE come guest", "Already Registered" => "Già registrato?", "Login Link" => "Accedi", "Powered by string Email" => "Con tecnologia Xirrus", "Powered by string" => "CON TECNOLOGIA", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Condizioni per l'utilizzo", "TOU Description" => "Prima di effettuare la registrazione, leggere le condizioni per l'utilizzo.", "TOU Close Btn" => "FINE", "Registration Successfull" => "Registrazione riuscita", "Registration Login Bzutton" => "ACCEDI AL WEB"]
   when "日本語"
      strings_hash = Hash["Voucher Header Login Title" => "で Wi-Fi にアクセスするには、するか、ログインしてください。", "Self-Reg Header Login Title" => "で Wi-Fi にアクセスするには、登録するか、ログインしてください。", "Forgot Password" => "パスワードを忘れた場合", "Username Placeholder" => "ユーザー名", "Password Placeholder" => "パスワード", "Ambassador & Voucher Login Title" => "ログインしてください" ,"Login Title" => "で Wi-Fi にアクセスするには、するか、ログインしてください。", "Greeting string" => "こんにちは、Guestさん", "Access will expire" => "アクセスの期限は # 日です。", "Need to login again" => "# 時間ごとにログインし直す必要がある場合があります。", "Did not request" => "ゲスト アクセスを要求した覚えがない場合は、第三者が代わりに要求したか、誤ってあなたのメール アドレスを入力した可能性があります。このメッセージに覚えがない場合は、削除していただいて構いません。", "Username String" => "ユーザー名:", "Password String" => "パスワード:", "Subject String" => "ゲスト Wi-Fi パスワード", "Voucher Login Button" => "同意してログイン", "Login Button" => "ログイン", "Logo Title" => "WI-FI ポータル", "Register Button" => "登録", "Need New Account" => "新しいアカウントが必要な場合", "Register Link" => "登録", "Register Page" => "", "Register Page Title" => "登録", "Register Page Subtitle" => "で Wi-Fi にアクセスするために登録します","Guest Name Label" => "ゲスト名", "Email Label" => "電子メール", "Mobile Label" => "携帯", "Mobile Checkbox Label" => "メールに加えて、テキスト メッセージでもパスワードを受信する。", "Cancel Bzutton" => "キャンセル", "Submit Button Self-Registration" => "同意して登録", "Submit Button" => "ゲストとして登録", "Already Registered" => "すでに登録がお済みの場合は", "Login Link" => "ログインしてください", "Powered by string Email" => "Powered by Xirrus", "Powered by string" => "POWERED BY", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "利用規約に同意するものとみなされます。", "TOU Description" => "登録手続きに進む前に、利用規約をご一読ください。", "TOU Close Btn" => "完了", "Registration Successfull" => "正常に登録されましたl!", "Registration Login Bzutton" => "WEB にアクセス!"]
    when "Bahasa Malaysia"
      strings_hash = Hash["Voucher Header Login Title" => "Log masuk untuk mengakses Wi-Fi di", "Self-Reg Header Login Title" => "Daftar atau Log masuk untuk mengakses Wi-Fi di", "Forgot Password" => "Terlupa Kata Laluan?", "Username Placeholder" => "nama pengguna", "Password Placeholder" => "kata laluan", "Ambassador & Voucher Login Title" => "Log masuk" ,"Login Title" => "Log masuk untuk mengakses Wi-Fi di", "Greeting string" => "Helo Guest,", "Access will expire" => "Akses anda akan tamat tempoh dalam # hari.", "Need to login again" => "Anda mungkin perlu log masuk semula setiap # jam.", "Did not request" => "Jika anda tidak meminta akses tetamu, seseorang mungkin telah melakukannya untuk anda atau seseorang mungkin telah tersilap memasukkan alamat e-mel anda. Jika anda percaya bahawa anda telah menerima mesej kerana kesilapan, ia selamat untuk memadam mesej ini.", "Username String" => "nama pengguna:", "Password String" => "kata laluan:", "Subject String" => "Kata Laluan Wi-Fi Tetamu", "Voucher Login Button" => "SETUJU & LOG MASUK", "Login Button" => "LOG MASUK", "Logo Title" => "PORTAL WI-FI", "Register Button" => "Daftar", "Need New Account" => "Perlukan akaun baharu?", "Register Link" => "Daftar", "Register Page" => "", "Register Page Title" => "Daftar", "Register Page Subtitle" => "Daftar untuk mengakses Wi-Fi di","Guest Name Label" => "Nama Tetamu", "Email Label" => "E-mel", "Mobile Label" => "Telefon bimbit", "Mobile Checkbox Label" => "Terima kata laluan melalui mesej teks selain e-mel.", "Cancel Bzutton" => "Batal", "Submit Button Self-Registration" => "SETUJU & DAFTAR", "Submit Button" => "DAFTAR sebagai tetamu", "Already Registered" => "Sudah mendaftar?", "Login Link" => "Log masuk", "Powered by string Email" => "Dikuasakan oleh Xirrus", "Powered by string" => "DIKUASAKAN OLEH", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Terma Penggunaan", "TOU Description" => "Sila semak Terma Penggunaan sebelum meneruskan pendaftaran.", "TOU Close Btn" => "SELESAI", "Registration Successfull" => "Pendaftaran Berjaya!", "Registration Login Bzutton" => "AKSES WEB!"]
    when "Norsk"
      strings_hash = Hash["Voucher Header Login Title" => "logg deg på for å få tilgang til Wi-Fi hos", "Self-Reg Header Login Title" => "Registrer deg eller logg deg på for å få tilgang til Wi-Fi hos", "Forgot Password" => "Glemt passordet?", "Username Placeholder" => "brukernavn", "Password Placeholder" => "passord", "Ambassador & Voucher Login Title" => "Logg deg på" ,"Login Title" => "logg deg på for å få tilgang til Wi-Fi hos", "Greeting string" => "Hei, Guest", "Access will expire" => "Tilgangen din vil opphøre om # dag(er).", "Need to login again" => "Du kan måtte logge deg på igjen hver # time.", "Did not request" => "Hvis du ikke har bedt om gjestetilgang, kan noen ha gjort det for deg, eller noen kan ha angitt e-postadressen din ved en feiltakelse. Hvis du mener du har mottatt denne meldingen ved en feiltakelse, kan du slette den.", "Username String" => "brukernavn:", "Password String" => "passord:", "Subject String" => "Wi-Fi-passord for gjester", "Voucher Login Button" => "GODTA OG LOGG PÅ", "Login Button" => "Logg deg på", "Logo Title" => "WI-FI-PORTAL", "Register Button" => "Registrer deg", "Need New Account" => "Trenger du en ny konto?", "Register Link" => "Registrer deg", "Register Page" => "", "Register Page Title" => "Registrer deg", "Register Page Subtitle" => "Registrer deg for å få tilgang til Wi-Fi hos","Guest Name Label" => "Gjestens navn", "Email Label" => "E-post", "Mobile Label" => "Mobil", "Mobile Checkbox Label" => "Motta passord via tekstmelding i tillegg til e-post.", "Cancel Bzutton" => "Avbryt", "Submit Button Self-Registration" => "GODTA OG REGISTRER DEG", "Submit Button" => "REGISTRER deg som gjest", "Already Registered" => "Allerede registrert?", "Login Link" => "Logg deg på", "Powered by string Email" => "Drevet av Xirrus", "Powered by string" => "DREVET AV", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Bruksbetingelsene", "TOU Description" => "Les gjennom bruksbetingelsene før du går videre med registreringen.", "TOU Close Btn" => "FULLFØRT", "Registration Successfull" => "Registreringen var vellykket!", "Registration Login Bzutton" => "TILGANG TIL INTERNETT."]
    when "Português (Brasil)"
      strings_hash = Hash["Voucher Header Login Title" => "faça o login para acessar o Wi-Fi em", "Self-Reg Header Login Title" => "Registre-se ou faça o login para acessar o Wi-Fi em", "Forgot Password" => "Esqueceu a senha?", "Username Placeholder" => "nome de usuário", "Password Placeholder" => "senha", "Ambassador & Voucher Login Title" => "Faça o login" ,"Login Title" => "faça o login para acessar o Wi-Fi em", "Greeting string" => "Olá Guest,", "Access will expire" => "Seu acesso vai expirar em # dia(s).", "Need to login again" => "Pode ser necessário fazer o login novamente a cada # hora(s).", "Did not request" => "Caso não tenha solicitado o acesso a convidados, alguém pode ter feito isso por você, ou alguém pode ter entrado no seu endereço de e-mail por engano. Caso acredite que tenha recebido esta mensagem por engano, é seguro excluir esta mensagem.", "Username String" => "nome de usuário:", "Password String" => "senha:", "Subject String" => "Senha Wi-Fi para convidado", "Voucher Login Button" => "CONCORDAR E FAZER O LOGIN", "Login Button" => "FAÇA O LOGIN", "Logo Title" => "PORTAL DE WI-FI", "Register Button" => "Registre-se", "Need New Account" => "Precisa de uma nova conta?", "Register Link" => "Registre-se", "Register Page" => "", "Register Page Title" => "Registre-se", "Register Page Subtitle" => "Registre-se para acessar o Wi-Fi em","Guest Name Label" => "Nome do convidado", "Email Label" => "E-mail", "Mobile Label" => "Celular", "Mobile Checkbox Label" => "Receba a senha por mensagem de texto, além do e-mail.", "Cancel Bzutton" => "Cancelar", "Submit Button Self-Registration" => "CONCORDE E REGISTRE-SE", "Submit Button" => "REGISTRE-SE como um convidado", "Already Registered" => "Já está registrado?", "Login Link" => "Faça o login", "Powered by string Email" => "Desenvolvido pela Xirrus", "Powered by string" => "DESENVOLVIDO POR", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Termos de uso", "TOU Description" => "Revise os Termos de uso antes de prosseguir com o registro.", "TOU Close Btn" => "CONCLUÍDO", "Registration Successfull" => "Registro executado com sucesso!", "Registration Login Bzutton" => "ACESSE A WEB!"]
    when "Pусский"
      strings_hash = Hash["Voucher Header Login Title" => "выполните вход для доступа к Wi-Fi компании", "Self-Reg Header Login Title" => "Зарегистрируйтесь или выполните вход для доступа к Wi-Fi компании", "Forgot Password" => "Забыли пароль?", "Username Placeholder" => "Имя пользователя", "Password Placeholder" => "Пароль", "Ambassador & Voucher Login Title" => "Вход" ,"Login Title" => "выполните вход для доступа к Wi-Fi компании", "Greeting string" => "Здравствуйте, Guest!", "Access will expire" => "Доступ будет прекращен через # дн.", "Need to login again" => "Возможно, Вам потребуется выполнять вход каждые # ч.", "Did not request" => "Если Вы не запрашивали гостевой доступ, возможно, кто-то сделал это для Вас или случайно указал Ваш адрес электронной почты. Если Вы считаете, что это письмо попало к Вам по ошибке, просто удалите его.", "Username String" => "Имя пользователя:", "Password String" => "Пароль:", "Subject String" => "Гостевой пароль для Wi-Fi", "Voucher Login Button" => "ПРИНЯТЬ И ВОЙТИ", "Login Button" => "ВХОД", "Logo Title" => "ПОРТАЛ WI-FI", "Register Button" => "Зарегистрироваться", "Need New Account" => "Нужна новая учетная запись?", "Register Link" => "Зарегистрироваться", "Register Page" => "", "Register Page Title" => "Зарегистрироваться", "Register Page Subtitle" => "Зарегистрируйтесь для получения доступа к Wi-Fi компании","Guest Name Label" => "Гостевое имя", "Email Label" => "Электронная почта", "Mobile Label" => "Мобильный телефон", "Mobile Checkbox Label" => "Получить пароль не только по электронной почте, но и в SMS-сообщении.", "Cancel Bzutton" => "Отмена", "Submit Button Self-Registration" => "ПРИНЯТЬ И ЗАРЕГИСТРИРОВАТЬСЯ", "Submit Button" => "ЗАРЕГИСТРИРОВАТЬСЯ как гость", "Already Registered" => "Уже зарегистрированы?", "Login Link" => "Вход", "Powered by string Email" => "При поддержке Xirrus", "Powered by string" => "ПРИ ПОДДЕРЖКЕ", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "условиями использования", "TOU Description" => "Перед тем как продолжить процесс регистрации, ознакомьтесь с условиями использования.", "TOU Close Btn" => "ГОТОВО", "Registration Successfull" => "Регистрация прошла успешно.", "Registration Login Bzutton" => "ВОЙДИТЕ В ИНТЕРНЕТ!"]
    when "Español"
      strings_hash = Hash["Voucher Header Login Title" => "Iniciar sesión para acceder a la Wi-Fi de", "Self-Reg Header Login Title" => "Registrarse o Iniciar sesión para acceder a la Wi-Fi de", "Forgot Password" => "¿Ha olvidado la contraseña?", "Username Placeholder" => "Nombre de usuario", "Password Placeholder" => "Contraseña", "Ambassador & Voucher Login Title" => "Iniciar sesión" ,"Login Title" => "Conectar a Wi-Fi en", "Greeting string" => "Hola, Guest:", "Access will expire" => "Su acceso caducará en # día(s).", "Need to login again" => "Es posible que tenga que volver a iniciar sesión cada # hora(s).", "Did not request" => "Si no ha solicitado acceso de invitado, es posible que alguien lo haya hecho por usted, o que alguien haya introducido su dirección de correo electrónico por error. Si cree que ha recibido este mensaje por error, elimínelo por seguridad.", "Username String" => "Nombre de usuario:", "Password String" => "Contraseña:", "Subject String" => "Contraseña de la Wi-Fi de invitados", "Voucher Login Button" => "ACEPTAR E INICIAR SESIÓN", "Login Button" => "INICIAR SESIÓN", "Logo Title" => "PORTAL DE WI-FI", "Register Button" => "Registrarse", "Connect Button" => "CONECTAR", "Connect Button with email" => "ACEPTAR E CONECTAR", "Need New Account" => "¿Necesita una cuenta nueva?", "Register Link" => "Registrarse", "Register Page" => "", "Register Page Title" => "Registrarse", "Register Page Subtitle" => "Registrarse para acceder a la Wi-Fi de","Guest Name Label" => "Nombre de invitado", "Email Label" => "Correo electrónico", "Mobile Label" => "Móvil", "Mobile Checkbox Label" => "Recibir la contraseña por mensaje de texto además de por correo electrónico.", "Cancel Bzutton" => "Cancelar", "Submit Button Self-Registration" => "ACEPTAR Y REGISTRARSE", "Submit Button" => "REGISTRARSE como invitado", "Already Registered" => "¿Ya se ha registrado?", "Login Link" => "Iniciar sesión", "Powered by string Email" => "Tecnología de Xirrus", "Powered by string" => "TECNOLOGÍA DE", "Required aid" => "El asterisco (*) indica los campos obligatorios.", "Terms of Use" => "Al hacer clic en el siguiente botón, acepto las Condiciones de uso.", "Data Disclaimer" => "Al proporcionar sus datos personales para que así pueda utilizar nuestro servicio, reconoce y acepta que estos datos personales pueden transferirse desde su ubicación actual a las oficinas y servidores de Xirrus, Inc. y a las filiales, agentes y proveedores de servicios que aquí figuran, localizados en los Estados Unidos y otros países.", "Access Expired" => "Acceso caducado", "Expired String" => "Su sesión ha caducado.", "Start New Session" => "Usted puede comenzar una nueva sesión:", "TOU Title" => "Condiciones de uso", "TOU Description" => "Revise las Condiciones de uso antes de registrarse.", "Close Button" => "HECHO", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Close Btn" => "HECHO", "Registration Successfull" => "Registro realizado correctamente.", "Registration Login Bzutton" => "ACCEDA A LA WEB."]
    when "Español (América Latina)"
      strings_hash = Hash["Voucher Header Login Title" => "inicie sesión para acceder a la red Wifi de", "Self-Reg Header Login Title" => "Regístrese o inicie sesión para acceder a la red Wifi de", "Forgot Password" => "¿Olvido su contraseña?", "Username Placeholder" => "Nombre de usuario", "Password Placeholder" => "Contraseña", "Ambassador & Voucher Login Title" => "Iniciar sesión" ,"Login Title" => "inicie sesión para acceder a la red Wifi de", "Greeting string" => "Hola Guest:", "Access will expire" => "Su acceso vencerá en # día(s).", "Need to login again" => "Es posible que tenga que volver a iniciar sesión cada # hora(s).", "Did not request" => "Si no solicitó acceso para invitados, es posible que alguien lo haya hecho por usted o que alguien haya ingresado su dirección de correo electrónico por error. Si cree que ha recibido este mensaje por error, puede eliminarlo.", "Username String" => "Nombre de usuario:", "Password String" => "Contraseña:", "Subject String" => "Contraseña de Wifi para invitados", "Voucher Login Button" => "ACEPTAR E INICIAR SESIÓN", "Login Button" => "Iniciar sesión", "Logo Title" => "PORTAL DE WIFI", "Register Button" => "Registrarse", "Need New Account" => "¿Necesita una cuenta nueva?", "Register Link" => "Registrarse", "Register Page" => "", "Register Page Title" => "Registrarse", "Register Page Subtitle" => "Regístrese para acceder a la red Wifi de","Guest Name Label" => "Nombre del invitado", "Email Label" => "Correo electrónico", "Mobile Label" => "Teléfono celular", "Mobile Checkbox Label" => "Recibir contraseña por mensaje de texto y correo electrónico.", "Cancel Bzutton" => "Cancelar", "Submit Button Self-Registration" => "ACEPTAR Y REGISTRARSE", "Submit Button" => "REGÍSTRESE como invitado", "Already Registered" => "¿Ya está registrado?", "Login Link" => "Iniciar sesión", "Powered by string Email" => "Desarrollado por Xirrus", "Powered by string" => "DESARROLLADO POR", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Términos de uso", "TOU Description" => "Lea los Términos de uso antes de registrarse.", "TOU Close Btn" => "LISTO", "Registration Successfull" => "¡Registro exitoso!", "Registration Login Bzutton" => "¡ACCEDER A LA WEB!"]
    when "Svenska"
      strings_hash = Hash["Voucher Header Login Title" => "logga in för tillgång till Wi-Fi på", "Self-Reg Header Login Title" => "Registrera dig eller logga in för tillgång till Wi-Fi på", "Forgot Password" => "Glömt lösenord?", "Username Placeholder" => "användarnamn", "Password Placeholder" => "lösenord", "Ambassador & Voucher Login Title" => "Inloggning" ,"Login Title" => "logga in för tillgång till Wi-Fi på", "Greeting string" => "Hej Guest,", "Access will expire" => "Din tillgång går ut om # dag(ar).", "Need to login again" => "Du kan behöva logga in igen varje gång det gått # timme/timmar.", "Did not request" => "Om du inte begärde gästtillgång kan någon ha gjort det åt dig eller någon kan ha angivit din e-postadress av misstag. Om du tror att du har fått detta meddelande av misstag kan du radera detta meddelande.", "Username String" => "användarnamn:", "Password String" => "lösenord:", "Subject String" => "Lösenord för Wi-Fi för gäst", "Voucher Login Button" => "GODKÄNN & LOGGA IN", "Login Button" => "Inloggning", "Logo Title" => "WI-FI-PORTAL", "Register Button" => "Registrera dig", "Need New Account" => "Behöver du ett nytt konto?", "Register Link" => "Registrera dig", "Register Page" => "", "Register Page Title" => "Registrera dig", "Register Page Subtitle" => "Registrera dig för tillgång till Wi-Fi på","Guest Name Label" => "Gästnamn", "Email Label" => "E-post", "Mobile Label" => "Mobil", "Mobile Checkbox Label" => "Få lösenord via textmeddelande och e-post.", "Cancel Bzutton" => "Avbryt", "Submit Button Self-Registration" => "GODKÄNN & REGISTRERA", "Submit Button" => "REGISTRERA DIG som gäst", "Already Registered" => "Redan registrerad?", "Login Link" => "Inloggning", "Powered by string Email" => "Drivet av Xirrus", "Powered by string" => "DRIVET AV", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Användarvillkor", "TOU Description" => "Granska Användarvillkoren innan du fortsätter med registreringen.", "TOU Close Btn" => "KLAR", "Registration Successfull" => "Registrering framgångsrik!", "Registration Login Bzutton" => "TILLGÅNG TILL NÄTET!"]
    when "Filipino"
      strings_hash = Hash["Voucher Header Login Title" => "Mag-login para ma- access ang Wi-Fi sa", "Self-Reg Header Login Title" => "Magrehistro o Mag-login para ma- access ang Wi-Fi sa", "Forgot Password" => "Nakalimutan ang Password?", "Username Placeholder" => "username", "Password Placeholder" => "password", "Ambassador & Voucher Login Title" => "Mag-login" ,"Login Title" => "Mag-login para ma- access ang Wi-Fi sa", "Greeting string" => "Hello Guest,", "Access will expire" => "Mapapaso ang iyong access sa loob ng # (na) araw.", "Need to login again" => "Maaaring kailanganin mong mag-login ulit bawat # (na) oras.", "Did not request" => "Kung hindi ka humiling ng access ng guest, maaaring may ibang humiling para sa iyo, o maaaring may nagkamaling ipasok ang iyong email. Kung naniniwala kang mali ang pagkakatanggap mo sa mensaheng ito, mas makabubuting i-delete ang mensaheng ito.", "Username String" => "username:", "Password String" => "password:", "Subject String" => "Wi-Fi Password ng Guest", "Voucher Login Button" => "SUMANG-AYON AT MAG-LOGIN", "Login Button" => "LOGIN", "Logo Title" => "WI-FI PORTAL", "Register Button" => "Magrehistro", "Need New Account" => "Kailangan mo ng bagong account?", "Register Link" => "Magrehistro", "Register Page" => "", "Register Page Title" => "Magrehistro", "Register Page Subtitle" => "Magrehistro para ma-access ang WI-Fi sa","Guest Name Label" => "Pangalan ng Guest", "Email Label" => "Email", "Mobile Label" => "Mobile", "Mobile Checkbox Label" => "Tanggapin ang password sa pamamagitan ng text message bilang karagdagan sa email.", "Cancel Bzutton" => "Ikansela", "Submit Button Self-Registration" => "SUMANG-AYON AT MAGREHISTRO", "Submit Button" => "MAGREHISTRO bilang guest (bisita)", "Already Registered" => "Nakarehistro na?", "Login Link" => "Mag-login", "Powered by string Email" => "Pinatatakbo ng Xirrus", "Powered by string" => "PINATATAKBO NG", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Mga Patakaran sa Paggamit", "TOU Description" => "Pag-aralan ang Mga Patakaran sa Paggamit sa ibaba bago tumuloy sa pagrehistro.", "TOU Close Btn" => "TAPOS NA", "Registration Successfull" => "Matagumpay ang Pagrehistro!", "Registration Login Bzutton" => "I-ACCESS ANG WEB!"]
    when "Українська"
      strings_hash = Hash["Voucher Header Login Title" => "ввійдіть, щоб отримати доступ до Wi-Fi у компанії\n.", "Self-Reg Header Login Title" => "Зареєструйтесь або ввійдіть, щоб отримати доступ до Wi-Fi у компанії\n.", "Forgot Password" => "Забули пароль?", "Username Placeholder" => "ім’я користувача", "Password Placeholder" => "пароль", "Ambassador & Voucher Login Title" => "Увійти" ,"Login Title" => "ввійдіть, щоб отримати доступ до Wi-Fi у компанії\n.", "Greeting string" => "Вітаємо, Guest,", "Access will expire" => "Доступ для Вас буде закрито через # дн.", "Need to login again" => "Може знадобитися повторно виконувати вхід кожні # год.", "Did not request" => "Якщо Ви не подавали запит на гостьовий доступ, хтось міг зробити це за Вас або помилково ввести Вашу електронну адресу. Якщо Ви вважаєте, що отримали це повідомлення помилково, видаліть його.", "Username String" => "ім’я користувача:", "Password String" => "пароль:", "Subject String" => "Пароль гостьового доступу до Wi-Fi", "Voucher Login Button" => "ПРИЙНЯТИ Й УВІЙТИ", "Login Button" => "УВІЙТИ", "Logo Title" => "ПОРТАЛ WI-FI", "Register Button" => "Зареєструватися", "Need New Account" => "Потрібен новий обліковий запис?", "Register Link" => "Зареєструватися", "Register Page" => "", "Register Page Title" => "Зареєструватися", "Register Page Subtitle" => "Зареєструйтеся, щоб отримувати доступ до Wi-Fi у","Guest Name Label" => "Гостьове ім’я", "Email Label" => "Електронна адреса", "Mobile Label" => "Мобільний телефон", "Mobile Checkbox Label" => "Пароль можна отримати електронною поштою й текстовим повідомленням.", "Cancel Bzutton" => "Скасувати", "Submit Button Self-Registration" => "ПРИЙНЯТИ ТА ЗАРЕЄСТРУВАТИСЯ", "Submit Button" => "ЗАРЕЄСТРУВАТИСЯ як гість", "Already Registered" => "Уже зареєструвалися?", "Login Link" => "Увійти", "Powered by string Email" => "Технології Xirrus", "Powered by string" => "ТЕХНОЛОГІЇ", "Connect Devices Button" => "Connect", "Manage Devices Subtitle" => "You can have up to # devices registered.\nYou must remove devices before you can connect with any new devices.", "TOU Title" => "Умови користування", "TOU Description" => "Перш ніж реєструватися, прочитайте Умови користування.", "TOU Close Btn" => "ГОТОВО", "Registration Successfull" => "Реєстрацію завершено!", "Registration Login Bzutton" => "МАНДРУЙТЕ ІНТЕРНЕТОМ!"]
  end
  return strings_hash[string]
end

def verify_certain_control_on_iframe_is_in_certain_language_by_item_type(item_name, css_path, language)
  if item_name.include?("Button")
    verify_certain_control_on_iframe_is_in_certain_language(item_name, css_path, language, "value")
  elsif item_name.include?("Placeholder")
    verify_certain_control_on_iframe_is_in_certain_language(item_name, css_path, language, "placeholder")
  else
    verify_certain_control_on_iframe_is_in_certain_language(item_name, css_path, language, nil)
  end
end

def return_pages_hash_based_on_portal_type(portal_type)
  pages_hash = Hash[
  "Welcome Page Self-Registration" => Hash["Self-Reg Header Login Title" => ".wrapper .container .title", "Register Button" => "#splash_login_single .registerBtn", "Logo Title" => ".wrapper .logo .logo_title .guest_portal", "Login Button" => "#splash_login_single .loginBtn", "Powered by string" => ".poweredbyxirrus span:first-child"],
  "Login Page Self-Registration" => Hash["Logo Title" => ".wrapper .logo .logo_title .guest_portal", "Ambassador & Voucher Login Title" => ".login_form .header", "Forgot Password" => "#forgot a", "Username Placeholder" => "#login_form .username input", "Password Placeholder" => "#login_form .password input", "Powered by string" => ".poweredbyxirrus span:first-child", "Need New Account" => "#login_form .doregister span", "Register Link" => "#login_form .doregister a"],
  "Register Page" => Hash["Logo Title" => ".wrapper .logo .logo_title .guest_portal", "Register Page Title" => ".wrapper .container .register_form .header .title", "Register Page Subtitle" => ".wrapper .container .register_form .header .subtitle", "Guest Name Label" => ".register_form .content #register_form div:first-child label span", "Email Label" => ".register_form .content #register_form div:nth-child(2) label span", "Mobile Label" => ".register_form .content #register_form div:nth-child(3) .mobile label span", "Mobile Checkbox Label" => ".register_form .content #register_form div:nth-child(3) label", "Cancel Bzutton" => ".register_form .content #register_form .buttons .cancelBtn", "Submit Button" => ".register_form .content #register_form .buttons #registration_submit", "Already Registered" => ".register_form .content #register_form .other span" , "Login Link" => ".register_form .content #register_form .other a", "Powered by string" => ".poweredbyxirrus span:first-child"],
  "Email" => Hash["Greeting string" => ".content .body .primary_text_color", "Username String" => ".content .body div:nth-child(4) tbody tr:first-child td:first-child", "Password String" => ".content .body div:nth-child(4) tbody tr:nth-child(2) td:first-child", "Subject String" => ".content .header span:nth-child(2)", "Access will expire" => ".content .body p:nth-child(5)", "Need to login again" => ".content .body p:nth-child(6)", "Did not request" => ".content .body p:nth-child(7)", "Powered by string Email" => ".content .body .poweredbyxirrus_wrapper"],
  "Success! Page" => Hash["Registration Successfull" => ".container .register_form .content .primary_text_color", "Registration Login Bzutton" => ".container .register_form .content #complete_link"],
  "Login Page Voucher" => Hash["Voucher Header Login Title" => ".container .login .title", "Password Placeholder" => "#login_form .password input", "Ambassador & Voucher Login Title" => ".container .login_form .header", "Voucher Login Button" => "#login_submit", "Powered by string" => ".poweredbyxirrus span:first-child"],
  "Manage Devices" => Hash["Manage Devices Subtitle" => ".container .header .subtitle", "Connect Devices Button" => "#connect_device"],
  "Terms of Use Self-Registration" => Hash["TOU Title" => ".terms_of_use .title", "TOU Description" => ".hideForSec", "TOU Close Btn" => "#close_tou"],
  "Terms of Use Others" => Hash["TOU Title" => ".terms_of_use .title", "TOU Description" => ".hideForSelfReg", "TOU Close Btn" => "#close_tou"],
  "Login Page Ambassador" => Hash["Logo Title" => ".wrapper .logo .logo_title .guest_portal", "Ambassador & Voucher Login Title" => ".login_form .header", "Forgot Password" => "#forgot a", "Username Placeholder" => "#login_form .username input", "Password Placeholder" => "#login_form .password input", "Powered by string" => ".poweredbyxirrus span:first-child"],
  "Welcome Page Composite" => Hash["Login Title" => ".container .uncleartext .title",  "Powered by string" => ".poweredbyxirrus span:first-child"]
  ]
  pages_hash_new = Hash[]
  page = ''
  pages_hash.each do |page, page_elements_hash|
    if portal_type == 'self_reg'
      if ["Welcome Page Self-Registration", "Login Page Self-Registration", "Register Page", "Email", "Success! Page", "Terms of Use Self-Registration"].include?(page)
        pages_hash_new[page] = page_elements_hash
      end
      if page == "Login Page Self-Registration"
        pages_hash_new["Login Page"] = pages_hash_new.delete("Login Page Self-Registration")
      elsif page == "Terms of Use Self-Registration"
        pages_hash_new["Terms of Use"] = pages_hash_new.delete("Terms of Use Self-Registration")
      elsif page == "Welcome Page Self-Registration"
        pages_hash_new["Welcome Page"] = pages_hash_new.delete("Welcome Page Self-Registration")
      end
      if page == "Register Page"
        pages_hash_new["Register Page"]["Submit Button Self-Registration"] = pages_hash_new["Register Page"].delete("Submit Button")
      end
    elsif portal_type == "voucher"
      if ["Login Page Voucher", "Manage Devices", "Terms of Use Others"].include?(page)
        pages_hash_new[page] = page_elements_hash
      end
      if page == "Login Page Voucher"
        pages_hash_new["Login Page"] = pages_hash_new.delete("Login Page Voucher")
      elsif page == "Terms of Use Others"
        pages_hash_new["Terms of Use"] = pages_hash_new.delete("Terms of Use Others")
      end
    elsif portal_type == "mega"
      if page.include?("Composite")
        pages_hash_new[page] = page_elements_hash
        pages_hash_new["Welcome Page"] = pages_hash_new.delete("Welcome Page Composite")
      end
    elsif portal_type == "ambassador"
      if ["Login Page Ambassador", "Email"].include?(page)
        pages_hash_new[page] = page_elements_hash
        if page == "Login Page Ambassador"
          pages_hash_new["Login Page"] = pages_hash_new.delete("Login Page Ambassador")
        end
      end
    end
  end
  pp pages_hash_new
  return pages_hash_new
end

def prerequisites_for_portal_language_look_feel_settings_it_blocks(portal_type, language, use_terms_of_use)
  it "Go to the 'General' tab" do
    @ui.click('#guestportal_config_tab_general')
    sleep 2
    expect(@browser.url).to include('/config/general')
  end
  it "Set the language to #{language}" do
    @ui.set_dropdown_entry('guestportal_config_basic_language', language)
  end
  it "Go to the 'Look & Feel' tab" do
    @ui.click('#guestportal_config_tab_lookfeel')
    sleep 0.5
    expect(@browser.url).to include('/config/lookfeel')
    @ui.css('.iframe_preview_overlay').wait_until_present
  end
  if ["self_reg", "onetouch", "voucher"].include?(portal_type)
    if use_terms_of_use == true
      it "If needed set the 'Enable Terms of Use' checkbox to ON" do
        if @ui.get(:checkbox, {id: "enableToU"}).set? == false
          @ui.click("#enableToU + .mac_chk_label")
        end
      end
    else
      it "If needed set the 'Enable Terms of Use' checkbox to OFF" do
        if @ui.get(:checkbox, {id: "enableToU"}).set? == true
          @ui.click("#enableToU + .mac_chk_label")
        end
      end
    end
  end
end

def open_specific_page(page_name)
  it "Open the full screen on the '#{page_name}' page" do
    page = find_specific_page("#{page_name}")
    page.click
    sleep 1.5
    @ui.show_needed_control(".fullscreen_button")
    sleep 0.5
    @ui.click('.fullscreen_button')
    sleep 0.5
    expect(@ui.css(".preview .preview_wrap .iframe_wrap .iframe_preview")).to be_visible
  end
end

def verify_certain_control_on_iframe_is_in_certain_language(control_string_name, control_css, language, attribute_value_string)
  it "Verify '#{control_string_name}' in '#{language}' is '#{return_certain_string_based_on_language(control_string_name, language)}'" do
    iframe_element = verify_iframe_preview_string(control_css)
    control_object = return_certain_string_based_on_language(control_string_name, language)
    if attribute_value_string == nil
      expect(iframe_element.text).to eq(control_object)
    else
      expect(iframe_element.attribute_value(attribute_value_string)).to eq(control_object)
    end
  end
end

shared_examples "update general language settings and verify portal look & feel tab pages" do |portal_type, language|
  describe "VERIFY THE LANGUAGE SETTINGS ON THE LOOK & FEEL TAB FOR THE LANGUAGE ''#{language}''" do
    prerequisites_for_portal_language_look_feel_settings_it_blocks(portal_type, language, true)
    pages_hash = return_pages_hash_based_on_portal_type(portal_type)
    pages_hash.each do |page, page_elements_hash|
      open_specific_page(page)
      page_elements_hash.each do |item_name, css_path|
        verify_certain_control_on_iframe_is_in_certain_language_by_item_type(item_name, css_path, language)
      end
      close_the_preview_window_with_it_block
    end
    if(language == "Українська")
      it "Reselect the 'Welcome Page' and return the language back to English on the last iteration" do
        @ui.click('#guestportal_config_lookfeel_preview_tile_login')
        @ui.click('#guestportal_config_tab_general')
        sleep 0.5
        @ui.set_dropdown_entry('guestportal_config_basic_language', "English")
      end
    end
  end
end

shared_examples "update general language settings and verify on portal look & feel onetouch" do |portal_name, language, use_email, use_terms_of_use|
  describe "VERIFY THE LANGUAGE SETTINGS ON THE LOOK & FEEL TAB FOR THE LANGUAGE ''#{language}''" do
    prerequisites_for_portal_language_look_feel_settings_it_blocks("onetouch", language, use_terms_of_use)
    open_specific_page("One-Click Access")
    if use_email == false
      verify_languages_hash = Hash["Login Title" => ".container .login .title",  "Connect Button" => "#connect_submit", "Powered by string" => ".poweredbyxirrus span:first-child"]
      verify_languages_hash.keys.each do |key|
        if key == "Connect Button"
          verify_certain_control_on_iframe_is_in_certain_language(key, verify_languages_hash[key], language, "value")
        else
          verify_certain_control_on_iframe_is_in_certain_language(key, verify_languages_hash[key], language, nil)
        end
      end
    elsif use_email == true
      verify_languages_hash = Hash["Login Title" => ".container .login .title",  "Connect Button with email" => ".submitBtn", "Required aid" => ".required_field", 'Terms of Use' => ".terms_of_use_field", 'Data Disclaimer' => ".disclaimer", "Powered by string" => ".poweredbyxirrus span:first-child"]
      verify_languages_hash.keys.each do |key|
        if key == "Connect Button with email"
          verify_certain_control_on_iframe_is_in_certain_language(key, verify_languages_hash[key], language, "value")
        else
          verify_certain_control_on_iframe_is_in_certain_language(key, verify_languages_hash[key], language, nil)
        end
      end
    end
    close_the_preview_window_with_it_block
    if use_terms_of_use == false
      open_specific_page("Access Expired")
      verify_languages_hash = Hash[ "Access Expired" => ".login_form .header", "Expired String" => ".session_expired", 'Start New Session' => ".expired_time div:first-child", "Powered by string" => ".poweredbyxirrus span:first-child"]
      verify_languages_hash.keys.each do |key|
        verify_certain_control_on_iframe_is_in_certain_language(key, verify_languages_hash[key], language, nil)
      end
      close_the_preview_window_with_it_block
    elsif use_terms_of_use == true
      open_specific_page("Terms of Use")
      verify_languages_hash = Hash["Logo Title" => ".logo .logo_container .logo_title .guest_portal", "TOU Title" => ".terms_of_use .title", "TOU Description" => ".terms_of_use .hideForSelfReg", 'Close Button' => "#close_tou", "Powered by string" => ".poweredbyxirrus span:first-child"]
      verify_languages_hash.keys.each do |key|
        verify_certain_control_on_iframe_is_in_certain_language(key, verify_languages_hash[key], language, nil)
      end
      close_the_preview_window_with_it_block
    end
    it "Reselect the 'One-Click Access' page and return the language back to English" do
      if(language == "Español")
        @ui.click('#guestportal_config_lookfeel_preview_tile_onetouch')
        @ui.click('#guestportal_config_tab_general')
        sleep 0.5
        @ui.set_dropdown_entry('guestportal_config_basic_language', "English")
      end
    end
  end
end

def search_for_lhs_element_and_perform_action(element_name_and_identifier, element_type, action, input_value, attribute)
  @not_found = true
  background_path = "#guestportal_config_lookfeel_view .innertab .lhs"
  field_elements = @ui.get(:elements, {css: background_path + " .field"})
  field_elements.each_with_index { |field_element, index|
    a = index + 2
    if @ui.css(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier).exists?
        if element_type == "check label"
          label_class = " + .mac_chk_label"
        else
          label_class = ""
        end
      if action == "verify text" and @ui.css(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier + label_class).text == input_value
        expect(@ui.css(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier + label_class).text).to eq(input_value)
        @not_found = false
        break
      elsif action == "tick" and @ui.css(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier + label_class).exists?
        original_state = @ui.get(:checkbox , {css: background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier}).set?
        @ui.css(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier + label_class).click
        expect(@ui.get(:checkbox , {css: background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier}).set?).not_to eq(original_state)
        @not_found = false
        break
      else
        case action
          when "click"
            @ui.css(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier).click
            @not_found = false
            break
          when "set value"
            @ui.set_input_val(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier, input_value)
            expect(@ui.get(:input , {css: background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier}).value).to eq(input_value)
            @not_found = false
            break
          when "verify present"
            expect(@ui.css(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier)).to be_present
            @not_found = false
            break
          when "verify attribute value includes"
            if @ui.css(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier).visible?
              expect(@ui.css(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier).attribute_value(attribute)).to include(input_value)
              @not_found = false
              break
            end
          when "not visible"
            expect(@ui.css(background_path + " .field:nth-of-type(#{a}) " + element_name_and_identifier)).not_to be_visible
            @not_found = false
            break
        end
      end
    end
  }
end

def verify_self_registration_lookfeel_lhs_elements
  field_labels = Hash[1 => "Company Name:", 2 => "Logo:", 3 => "Background:", 4 => "Color Scheme:", 5 => "Allow sign in with:"]
  (1..5).each { |i|
    search_for_lhs_element_and_perform_action(".field_label", "","verify text", field_labels[i], "")
  }
  verify_present_controls = Hash[1 => "#guestportal_config_lookfeel_companyname", 2 => "#guestportal_config_lookfeel_logobutton", 3 => "#guestportal_config_lookfeel_backgroundbutton"]
  (1..3).each { |i|
    search_for_lhs_element_and_perform_action(verify_present_controls[i], "","verify present", "", "")
    if i != 1
      search_for_lhs_element_and_perform_action(verify_present_controls[i], "","verify text", "Select Image", "")
    end
  }
  (1..7).each do |a|
    search_for_lhs_element_and_perform_action(".colors .color:nth-child(#{a})", "","verify present", "", "")
  end
  not_visible_controls = Hash[1 => ".removeimage a", 2 => ".info_field.image .image_preview"]
  (1..2).each { |i|
    search_for_lhs_element_and_perform_action(not_visible_controls[i], "", "not visible", "", "")
  }
  checkbox_controls = Hash[1 => "#requireMobile", 2 => "#google", 3 => "#facebook", 4 => "#enableToU", 5 => "#requireDisclosure", 6 => "#poweredByXirrus"]
  checkbox_texts = Hash[1 => "Require mobile number collection", 2 => "Google+", 3 => "Facebook", 4 => "Enable Terms of Use", 5 => "Show data disclosure", 6 => 'Show "Powered by Xirrus"']
  (1..6).each { |i|
    search_for_lhs_element_and_perform_action(checkbox_controls[i], "check label", "verify text", checkbox_texts[i], "")
    search_for_lhs_element_and_perform_action(checkbox_controls[i], "check label", "tick", "", "")
  }
  info_field_instructions = Hash[1 => "Logos may be JPG, GIF, or PNG images with a maximum size of 100x100 pixels. Images larger than 100x100 will be resized.", 2 => "Background images may be JPG, GIF, or PNG images with a maximum size of 1600 x 1000 pixels. Larger images will be resized."]
  (1..2).each { |i|
    search_for_lhs_element_and_perform_action(".info_field.instruct", "", "verify text", info_field_instructions[i], "")
  }
  search_for_lhs_element_and_perform_action("#guestportal_config_lookfeel_companyname", "","set value", "TEST", "")
end


def verify_voucher_onetouch_lookfeel_lhs_elements
  field_labels = Hash[1 => "Company Name:", 2 => "Logo:", 3 => "Background:", 4 => "Color Scheme:"]
  (1..4).each { |i|
    search_for_lhs_element_and_perform_action(".field_label", "","verify text", field_labels[i], "")
  }
  verify_present_controls = Hash[1 => "#guestportal_config_lookfeel_companyname", 2 => "#guestportal_config_lookfeel_logobutton", 3 => "#guestportal_config_lookfeel_backgroundbutton"]
  (1..3).each { |i|
    search_for_lhs_element_and_perform_action(verify_present_controls[i], "","verify present", "", "")
    if i != 1
      search_for_lhs_element_and_perform_action(verify_present_controls[i], "","verify text", "Select Image", "")
    end
  }
  (1..7).each do |a|
    search_for_lhs_element_and_perform_action(".colors .color:nth-child(#{a})", "","verify present", "", "")
  end
  not_visible_controls = Hash[1 => ".removeimage a", 2 => ".info_field.image .image_preview"]
  (1..2).each { |i|
    search_for_lhs_element_and_perform_action(not_visible_controls[i], "", "not visible", "", "")
  }
  checkbox_controls = Hash[1 => "#enableToU", 2 => "#poweredByXirrus"]
  checkbox_texts = Hash[1 => "Enable Terms of Use", 2 => 'Show "Powered by Xirrus"']
  (1..2).each { |i|
    search_for_lhs_element_and_perform_action(checkbox_controls[i], "check label", "verify text", checkbox_texts[i], "")
    search_for_lhs_element_and_perform_action(checkbox_controls[i], "check label", "tick", "", "")
  }
  info_field_instructions = Hash[1 => "Logos may be JPG, GIF, or PNG images with a maximum size of 100x100 pixels. Images larger than 100x100 will be resized.", 2 => "Background images may be JPG, GIF, or PNG images with a maximum size of 1600 x 1000 pixels. Larger images will be resized."]
  (1..2).each { |i|
    search_for_lhs_element_and_perform_action(".info_field.instruct", "", "verify text", info_field_instructions[i], "")
  }
  search_for_lhs_element_and_perform_action("#guestportal_config_lookfeel_companyname", "","set value", "TEST", "")
end

def verify_ambassador_lookfeel_lhs_elements
  field_labels = Hash[1 => "Company Name:", 2 => "Logo:", 3 => "Background:", 4 => "Color Scheme:"]
  (1..4).each { |i|
    search_for_lhs_element_and_perform_action(".field_label", "","verify text", field_labels[i], "")
  }
  verify_present_controls = Hash[1 => "#guestportal_config_lookfeel_companyname", 2 => "#guestportal_config_lookfeel_logobutton", 3 => "#guestportal_config_lookfeel_backgroundbutton"]
  (1..3).each { |i|
    search_for_lhs_element_and_perform_action(verify_present_controls[i], "","verify present", "", "")
    if i != 1
      search_for_lhs_element_and_perform_action(verify_present_controls[i], "","verify text", "Select Image", "")
    end
  }
  (1..7).each do |a|
    search_for_lhs_element_and_perform_action(".colors .color:nth-child(#{a})", "","verify present", "", "")
  end
  not_visible_controls = Hash[1 => ".removeimage a", 2 => ".info_field.image .image_preview"]
  (1..2).each { |i|
    search_for_lhs_element_and_perform_action(not_visible_controls[i], "", "not visible", "", "")
  }
  checkbox_controls = Hash[1 => "#requireMobile", 2 => "#poweredByXirrus"]
  checkbox_texts = Hash[1 => "Require mobile number collection", 2 => 'Show "Powered by Xirrus"']
  (1..2).each { |i|
    search_for_lhs_element_and_perform_action(checkbox_controls[i], "check label", "verify text", checkbox_texts[i], "")
    search_for_lhs_element_and_perform_action(checkbox_controls[i], "check label", "tick", "", "")
  }
  info_field_instructions = Hash[1 => "Logos may be JPG, GIF, or PNG images with a maximum size of 100x100 pixels. Images larger than 100x100 will be resized.", 2 => "Background images may be JPG, GIF, or PNG images with a maximum size of 1600 x 1000 pixels. Larger images will be resized."]
  (1..2).each { |i|
    search_for_lhs_element_and_perform_action(".info_field.instruct", "", "verify text", info_field_instructions[i], "")
  }
  search_for_lhs_element_and_perform_action("#guestportal_config_lookfeel_companyname", "","set value", "TEST", "")
end


####################################### US 4342 - EasyPass Portals Configuration #######################################

shared_examples "verify background" do |portal_name, portal_type, image_name_search, add_external_image_path, add_image_name, background_or_logo|
  describe "Verify the background image feature works properly" do
    it_behaves_like "go to look feel tab", portal_name
    it_behaves_like "verify that the portal properly displays the default elements", portal_type
    it_behaves_like "search for an image", image_name_search
    it_behaves_like "add external image", portal_type, add_external_image_path, add_image_name
    it_behaves_like "verify image displayed in preview" , add_image_name, background_or_logo
    it_behaves_like "remove the image", portal_type , add_image_name , background_or_logo
    it_behaves_like "add existing image", portal_type , add_image_name
    #it_behaves_like "delete the used image" , portal_name, portal_type, add_image_name
    it_behaves_like "remove the image", portal_type , add_image_name , background_or_logo
    it_behaves_like "add external image", portal_type, add_external_image_path, add_image_name
    it_behaves_like "set fill screen for background" , portal_type, add_image_name
    it_behaves_like "remove fill screen for background" , portal_type, add_image_name
  end
end

shared_examples "go to look feel tab" do |portal_name|
  describe "Go to the 'Look & Feel' tab" do
    it "Go to the portal named '#{portal_name}' and click the 'Look & Feel' tab button and then verify that the proper url is displayed" do
      navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
      @ui.click('#guestportal_config_tab_lookfeel')
      sleep 0.5
      expect(@browser.url).to include('/config/lookfeel')
      @ui.css('.iframe_preview_overlay').wait_until_present
    end
  end
end

shared_examples "search for an image" do |image_name_search|
  describe "Open the 'ko-gallery' modal and verify that the '#{image_name_search}' image exists" do
    it "Verify that '#{image_name_search}' exists" do
      close_the_preview_window
      search_for_proper_ko_gallery_and_perform_desired_action(image_name_search, "verify image name")
    end
  end
end

shared_examples "verify that the portal properly displays the default elements" do |portal_type|
  describe "Verify that the portal type '#{portal_type}' displays the proper default elements for it's type" do
    it "Verify 'Look & Feel' elements for '#{portal_type}' portal" do
      case portal_type
        when "self_reg"
          verify_self_registration_lookfeel_lhs_elements
        when "voucher", "onetouch"
          verify_voucher_onetouch_lookfeel_lhs_elements
        when "ambassador"
          verify_ambassador_lookfeel_lhs_elements
      end
    end
  end
end

shared_examples "add external image" do |portal_type, add_external_image_path, add_image_name|
  describe "Add the external image from the link '#{add_external_image_path}'" do
    it "Add the image '#{add_image_name}'" do
      search_for_proper_ko_gallery_and_perform_desired_action(add_external_image_path, "new external")
      sleep 0.5
      search_for_proper_ko_gallery_and_perform_desired_action(add_image_name, "add to portal")
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
    end
    it "Verify that the iframe preview displays the image '#{add_image_name}'" do
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      frame.wait_until_present
      img = frame.element(:css => ".wrapper.background")
      img.wait_until_present
      expect(img.style).to include("/gapbackground/" + add_image_name)
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
    end
  end
end

shared_examples "remove the image" do |portal_type , add_image_name , background_or_logo|
  describe "Remove the image from '#{add_image_name}' from the '#{background_or_logo}' container" do
    it "Press the 'Remove Image' link" do
      if background_or_logo == "background"
        @ui.click('#guestportal_config_lookfeel_view .innertab .lhs div:nth-child(4) div .removeimage a')
      elsif background_or_logo == "logo"
        @ui.click('#guestportal_config_lookfeel_view .innertab .lhs div:nth-child(4) div .removeimage a')
      end
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
    end
    it "Verify that the iframe preview and all of the available pages in the portal do not display the image anymore" do
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      frame.wait_until_present
      img = frame.element(:css => ".wrapper.background")
      img.wait_until_present
      expect(img.style).not_to include("/images/" + add_image_name)
#      page_tiles_container_length = @ui.get(:elements , {css: "#guestportal_config_lookfeel_view .innertab .page_tiles_container .ko-hover-scroll .tiles .tile"}).length
#      while page_tiles_container_length >= 0
#        iframe = @ui.get(:iframe, {css: "#guestportal_config_lookfeel_view .innertab .page_tiles_container .ko-hover-scroll .tiles .tile:nth-child(#{page_tiles_container_length}) iframe"})
#        background = @ui.css("#guestportal_config_lookfeel_view .innertab .page_tiles_container .ko-hover-scroll .tiles .tile:nth-child(#{page_tiles_container_length}) iframe .preview_frame .wrapper.background").attribute_value("style")
#        puts background
#        expect(background).not_to include("/images/" + add_image_name)
#        page_tiles_container_length -= 1
#      end
    end
  end
end

shared_examples "add existing image" do |portal_type , add_image_name|
  describe "Add the image named '#{add_image_name}' to the portal" do
    it "Find the image named '#{add_image_name}' and add it to the portal" do
      search_for_proper_ko_gallery_and_perform_desired_action(add_image_name, "add to portal")
      sleep 2
      save_portal_ensure_no_error_is_displayed(portal_type)
      ensure_voucher_portal_is_properly_handled(portal_type)
    end
  end
end

shared_examples "delete the used image" do |portal_name, portal_type, add_image_name|
  describe "Delete the already used image named '' and verify that the portal responds properly" do
    it "Delete the already used image '#{add_image_name}' and save the profile" do
      search_for_proper_ko_gallery_and_perform_desired_action(add_image_name, "delete")
      sleep 0.5
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
    end
    it "Go to the home page and back to the portal" do
      @ui.click("#header_mynetwork_link")
      sleep 1
      navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,false)
      sleep 1
      @ui.click('#guestportal_config_tab_lookfeel')
      sleep 1
      @ui.css('.iframe_preview_overlay').wait_until_present
    end
    it "Verify that the iframe preview and all of the available pages in the portal do not display the image anymore" do
      frame = @ui.get(:iframe, { css: '.iframe_preview' })
      frame.wait_until_present
      img = frame.element(:css => ".wrapper.background")
      img.wait_until_present
      expect(img.style).not_to include("/images/" + add_image_name)
      page_tiles_container = @ui.get(:elements , {css: "#guestportal_config_lookfeel_view .innertab .page_tiles_container .ko-hover-scroll .tiles .tile"})
      page_tiles_container.each { |tile|
        puts tile.html
        puts tile.attribute_value("class")
        background = tile.element(:css => ".preview_frame .wrapper.background")
        expect(background.attribute_value("style")).not_to include("/images/" + add_image_name)
      }
    end
  end
end

shared_examples "set fill screen for background" do |portal_type, add_image_name|
  describe "Verify that the 'Fill screen' option properly displays the image" do
    it "Verify that the 'Fill Screen' tick works as intended and that the picture is displayed as fullscreen on the background of all pages" do
      search_for_lhs_element_and_perform_action("#backgroundFillScreen", "check label", "verify text", "Fill Screen", "")
      search_for_lhs_element_and_perform_action("#backgroundFillScreen", "check label", "tick", "", "")
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      expect(@ui.get(:checkbox, {id: "backgroundFillScreen"}).set?).to eq(true)
    end
  end
end

shared_examples "remove fill screen for background" do |portal_type, add_image_name|
  describe "Verify that the 'Fill screen' option can be properly removed" do
    it "Remove the 'Fill Screen' and verify that the picture is not displayed fullscreen" do
      search_for_lhs_element_and_perform_action("#backgroundFillScreen", "check label", "tick", "", "")
      sleep 1
      save_portal_ensure_no_error_is_displayed(portal_type)
      sleep 1
      ensure_voucher_portal_is_properly_handled(portal_type)
      expect(@ui.get(:checkbox, {id: "backgroundFillScreen"}).set?).to eq(false)
    end
  end
end

shared_examples "verify image displayed in preview" do |add_image_name, background_or_logo|
  describe "Verify that the image preview shows the image '#{add_image_name}'" do
    it "Verify that the '#{background_or_logo} image preview window' displays the proper image" do
      search_for_lhs_element_and_perform_action(".info_field.image .image_preview", "","verify present", "", "")
      if background_or_logo == "background"
        search_for_lhs_element_and_perform_action(".info_field.image .image_preview", "","verify attribute value includes", add_image_name, "src")
      elsif background_or_logo == "logo"
        search_for_lhs_element_and_perform_action(".info_field.image .image_preview", "","verify attribute value includes", add_image_name, "src")
      end
   end
 end
end

shared_examples "verify background for portal" do |portal_name, portal_type, image_name_search, add_external_image_path, add_image_name|
  describe "Verify that the background image can be set and is properly displayed for the portal '#{portal_name}' of type '#{portal_type}'" do
    it "Readd the external new image '#{add_image_name}' twice to verify the confirmation dialogs" do
      search_for_proper_ko_gallery_and_perform_desired_action(add_external_image_path, "new external")
      sleep 0.5
      search_for_proper_ko_gallery_and_perform_desired_action(add_external_image_path, "new external")
    end
    it "Press the 'Remove Image' link and verify that the image is removed and all pages have lost the background" do
      @ui.click('#guestportal_config_tab_general')
      sleep 2
      @ui.click('#guestportal_config_tab_lookfeel')
      sleep 2
      @browser.refresh
      #search_for_lhs_element_and_perform_action(".removeimage a", "", "not visible", "")
      #search_for_lhs_element_and_perform_action(".info_field.image .image_preview", "", "not visible", "")
      page_tiles_container = @ui.get(:elements , {css: "#guestportal_config_lookfeel_view .innertab .page_tiles_container .ko-hover-scroll .tiles .tile"})
      page_tiles_container.each { |tile|
        background = tile.element(:css => ".preview_frame .wrapper.background")
        expect(background.attribute_value("style")).not_to include("/images/" + add_image_name)
      }
    end
    it "Readd the image '#{add_image_name}' to the portal and verify that all pages display the proper image background" do
      search_for_proper_ko_gallery_and_perform_desired_action(add_image_name, "add to portal")
      sleep 2
      save_portal_ensure_no_error_is_displayed(portal_type)
      ensure_voucher_portal_is_properly_handled(portal_type)
      @browser.refresh
      sleep 3
      page_tiles_container = @ui.get(:elements , {css: "#guestportal_config_lookfeel_view .innertab .page_tiles_container .ko-hover-scroll .tiles .tile"})
      page_tiles_container.each { |tile|
        background = tile.element(:css => ".preview_frame .wrapper.background")
        expect(background.attribute_value("style")).to include("/images/" + add_image_name)
      }
   end
  end
end

def search_for_proper_ko_gallery_and_perform_desired_action(image_name, action)
  @ui.click('#guestportal_config_lookfeel_backgroundbutton')
  sleep 2
  @not_found = true
  ko_galleries = @ui.get(:elements, {css: "body .ko-gallery"})
  ko_galleries.each { |ko_gallery|
    ko_gallery_modal = ko_gallery.element(:css => ".ko-gallery-modal")
    if ko_gallery_modal.visible?
      if action == "add to portal" or action == "delete" or action == "verify image name"
        images = ko_gallery_modal.elements(:css => ".content .ko-gallery-list .ko-gallery-item")
        images.each { |image|
          if image.attribute_value("style").include?(image_name)
            if action == "verify image name"
              image.click
              expect(image.attribute_value("style")).to include(image_name)
              @not_found = false
              break
            elsif action == "delete"
              image.click
              image.element(:css => ".xc-icon-delete").click
              confirm_dialog = @ui.css('.dialogOverlay.confirm.top')
              confirm_dialog.wait_until_present
              sleep 0.5
              @ui.click("#_jq_dlg_btn_1")
              confirm_dialog.wait_while_present
              @not_found = false
              break
            elsif action == "add to portal"
              image.click
              sleep 1
              ko_gallery_modal.element(:css => ".content .buttons .button.orange").click
              @not_found = false
              break
            end
          end
        }
      elsif action == "new disk"
        puts "TO CREATE METHOD!!!!!"
      elsif action == "new external"
        new_external_image = ko_gallery_modal.element(:css => ".content .ko-gallery-list .ko-gallery-item.ko-gallery-external")
        new_external_image.click
        external_image_modal = @ui.css(".dialogOverlay.prompt.top")
        external_image_modal.wait_until_present
        @ui.set_input_val('#promptInput', image_name)
        sleep 0.5
        @ui.click("#_jq_dlg_btn_1")
        external_image_modal.wait_while_present
        image_exists_modal = @ui.css(".dialogOverlay.confirm.top")
        if image_exists_modal.exists?
          if image_exists_modal.visible?
            sleep 0.5
            @ui.click("#_jq_dlg_btn_2")
            image_exists_modal.wait_while_present
          end
        end
        @not_found = false
      end
      close_buttons = @browser.elements(:css => ".modal-close")
      close_buttons.each do |close_button|
        if close_button.visible?
          sleep 0.5
          close_button.click
        end
      end
    end
  }
  if @not_found == true
    expect(action + " - " + image_name).to eq("NOT FOUND")
  end
end