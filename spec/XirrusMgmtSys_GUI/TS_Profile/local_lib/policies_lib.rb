require_relative "ssids_lib.rb"
require_relative "profile_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"

def get_switch_state(switch_id, switch_value)
 switch_state = @ui.get(:checkbox, {id: "#{switch_id}"}).set?
 expect(switch_state).to eq(switch_value)
end

shared_examples "create a profile and an ssid inside that profile" do |profile_name, profile_description, readonly, ssid_name|
describe "create a profile and an ssid inside that profile" do
      it_behaves_like "create profile from header menu" , profile_name, profile_description, readonly
      it_behaves_like "add profile ssid" , profile_name, ssid_name
  end
end

shared_examples "create a profile and 8 ssids inside that profile" do |profile_name, profile_description, readonly, ssid_name|
describe "create a profile and an ssid inside that profile" do
      it_behaves_like "create profile from header menu" , profile_name, profile_description, readonly
      #it_behaves_like "quick add 8 profile ssids", profile_name, ssid_name
      (1..8).each do |i|
        it_behaves_like "add profile ssid", profile_name, ssid_name + i.to_s
      end
  end
end

def hover_and_verify_ssid_line(policy_name)
  type = @ui.css('.policyField .policiesRowType').text
  name = @ui.css('.policyField .policiesRowName').text
  schedule = @ui.css('.policyField .policiesRowScheduleText')
  expect(type).to eq('SSID')
  expect(name).to eq(policy_name)
  expect(schedule).not_to be_visible
  @ui.css('.policyToggleDiv').when_present.hover
  sleep 1
  edit = @ui.css('.policyToggleDiv .policiesRowHover .policiesRowHoverEdit')
  delete = @ui.css('.policyToggleDiv .policiesRowHover .policiesRowHoverDelete')
  $schedule = @ui.css('.policyToggleDiv .policiesRowHover .policiesRowHoverSchedule')
  expect(edit).to be_visible
  expect(delete).to be_visible
  expect($schedule).to be_visible
end

def verify_policy_type_name_schedule(policy_type, policy_name, schedule_string)
  type = @ui.css('.policyField .policiesRowType').text
  name = @ui.css('.policyField .policiesRowName').text
  schedule = @ui.css('.policyField .policiesRowScheduleText').text
  expect(type).to eq(policy_type)
  expect(name).to eq(policy_name)
  expect(schedule).to eq(schedule_string)
end

def schedule_policy_days_checker_certain(days_string, from_time, to_time, all_day_check)
  label_elements = @ui.css('#scheduleDaypicker').spans
  expect(label_elements.length).to eq(7)
  label_elements.each do |span|
    if days_string.include?span.text
      span.click
      sleep 0.5
    end
  end
  time_picker_contaier = @ui.css('#timePickersContainer')
  expect(time_picker_contaier).to be_present
  @ui.set_input_val("#scheduleStartTime", from_time)
  sleep 1
  @ui.set_input_val("#scheduleEndTime", to_time)
  sleep 1
  if all_day_check == true
    @ui.click('#scheduleAllDay label')
  end
end

def schedule_policy_days_checker_all
  day_picker = @ui.css('#scheduleDaypicker')
  expect(day_picker.labels.length).to eq(7)
  day_picker.labels.each do |label|
    label.click
    sleep 0.5
  end
end

def verify_add_a_rule_modal
  expect(@ui.css('#new_rule_modal')).to be_present
  expect(@ui.css('#new_rule_modal .title_wrap.v-center i').attribute_value("class")).to eq("xcp-icon-circle push-right")
  expect(@ui.css('#new_rule_modal .title_wrap.v-center span').text).to eq("Add a Rule")
  expect(@ui.css('#new_rule_modal div:nth-child(2) .rule-selection-container')).to be_present
  expect(@ui.css('#new_rule_modal div:nth-child(2) .rule-selection-container div').text).to eq("Select a new rule to add to your policy:")

  expect(@ui.css('#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types').lis.length).to eq(3)

  rule_types = Hash[1 => "Firewall", 2 => "Air Cleaner", 3 => "Application Control"]
  rule_types_icons = Hash[1 => "firewall", 2 => "aircleaner", 3 => "application"]
  (1..3).each do |i|
    expect(@ui.css("#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types li:nth-child(#{i}) label i").attribute_value("class")).to eq("rule-type-icon xcp-icon-" + rule_types_icons[i])
    expect(@ui.css("#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types li:nth-child(#{i}) .rule-type-name").text).to eq(rule_types[i])
  end

  @ui.click('#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types li:nth-child(1) label .rule-type-icon.xcp-icon-firewall')

  rule_configurations_string = "#new_rule_modal div:nth-child(2) .rule-configuration"
  expect(@ui.css(rule_configurations_string)).to be_present

  field_labels_comparison_texts = Hash[1 => "Name:", 2 => "Enable:", 3 => "Action:", 4 => "Layer:", 5 => "Protocol:", 6 => "Port:", 7 => "Source:", 8 => "Destination:"]
  checkbox_paths = Hash[1 => "#rule_autoname #rule_autoname_switch", 2 => "#rule_enable #rule_enable_switch", 3 => "#rule_action #rule_action_switch" , 4 => "#rule_layer #rule_layer_switch"]
  dropdownlists_paths = Hash[5 => "#rule_protocol", 6 => "#rule_port", 7 => "#rule_source", 8 => "#rule_destination"]
  (1..9).each do |i|
    if i != 9
      case i
        when 1 , 2 , 3
          if i == 1
            expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) #rule_name").attribute_value("type")).to eq("text")
          end
          expect(@ui.get(:checkbox , {css: rule_configurations_string + " div:nth-child(#{i}) " + checkbox_paths[i]}).set?).to eq(true)
        when 4
          expect(@ui.get(:checkbox , {css: rule_configurations_string + " div:nth-child(#{i}) " + checkbox_paths[i]}).set?).to eq(false)
        when 5 , 6 , 7 , 8
          expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) " + dropdownlists_paths[i])).to exist
          if i < 7
            expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) " + dropdownlists_paths[i] + " .ko_dropdownlist_button .text").text).to eq("ANY")
          else
            expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) " + dropdownlists_paths[i] + " .ko_dropdownlist_button .text").text).to eq("Any")
          end
      end
      expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) .field_label").text).to eq(field_labels_comparison_texts[i])
    else
      expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) #rule_advanced_toggle")).to be_present
    end
  end

  expect(@ui.css('#rule_advanced_toggle')).to be_present
  sleep 0.5
  @ui.click('#rule_advanced_toggle')
  sleep 0.5
  expect(@ui.css(rule_configurations_string + ' .rulesAdvanced')).to be_present

  field_labels_comparison_texts = Hash[1 => "Traffic Shaping:", 2 => "QoS:", 3 => "DSCP:", 4 => "Limit Traffic", 5 => "at"]
  attribute_values_spinner_paths = Hash[2 => "#ruleModalQos", 3 => "#ruleModalDscp", 4 => "#trafficInputContainer #trafficInput"]
  attribute_values_radios_paths = Hash[2 => "#trafficShapingQos", 3 => "#trafficShapingDscp", 4 => "#trafficShapingTraffic"]
  dropdown_lists_paths = ["#trafficTypeSelect", "#trafficSelect"]

  (1..4).each do |i|
    if i != 4
      expect(@ui.css(rule_configurations_string + " .rulesAdvanced div:nth-child(#{i}) .field_label").text).to eq(field_labels_comparison_texts[i])
    else
      expect(@ui.css(rule_configurations_string + " .rulesAdvanced div:nth-child(#{i}) label").text).to eq(field_labels_comparison_texts[i])
      expect(@ui.css(rule_configurations_string + " .rulesAdvanced div:nth-child(#{i}) .field_label.small").text).to eq(field_labels_comparison_texts[5])
      dropdown_lists_paths.each { |dropdown_lists_path|
        expect(@ui.css(rule_configurations_string + " .rulesAdvanced div:nth-child(#{i}) " + dropdown_lists_path).attribute_value("class")).to eq("ko_dropdownlist disabled")
      }
    end
    if i != 1
      expect(@ui.css(rule_configurations_string + " .rulesAdvanced div:nth-child(#{i}) " + attribute_values_radios_paths[i]).attribute_value("type")).to eq("radio")
      expect(@ui.css(rule_configurations_string + " .rulesAdvanced div:nth-child(#{i}) " + attribute_values_spinner_paths[i]).attribute_value("type")).to eq("text")
      expect(@ui.css(rule_configurations_string + " .rulesAdvanced div:nth-child(#{i}) " + attribute_values_spinner_paths[i]).attribute_value("class")).to eq("spinner")
    end
  end

  @ui.click('#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types li:nth-child(2) label .rule-type-icon.xcp-icon-aircleaner')
  expect(@ui.css(rule_configurations_string)).not_to be_present

  @ui.click('#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types li:nth-child(3) label .rule-type-icon.xcp-icon-application')
  expect(@ui.css(rule_configurations_string)).to be_present
  field_labels_comparison_texts = Hash[1 => "Name:", 2 => "Enable:", 3 => "Action:", 4 => "Category:", 5 => "Application:"]
  checkbox_paths = Hash[1 => "#rule_autoname #rule_autoname_switch", 2 => "#rule_enable #rule_enable_switch", 3 => "#rule_action #rule_action_switch"]
  dropdownlists_paths = Hash[4 => "#rule_application", 5 => "#rule_application_option"]
  (1..6).each do |i|
    if i != 6
      case i
        when 1 , 2
          if i == 1
            expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) #rule_name").attribute_value("type")).to eq("text")
          end
          expect(@ui.get(:checkbox , {css: rule_configurations_string + " div:nth-child(#{i}) " + checkbox_paths[i]}).set?).to eq(true)
        when 3
          expect(@ui.get(:checkbox , {css: rule_configurations_string + " div:nth-child(#{i}) " + checkbox_paths[i]}).set?).to eq(false)
        when 4
          expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) " + dropdownlists_paths[i])).to exist
          expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) " + dropdownlists_paths[i] + " .ko_dropdownlist_button .text").text).to eq("Choose a category...")
        when 5
          sleep 0.5
          @ui.set_dropdown_entry('rule_application', "Mail")
          sleep 0.5
          expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) " + dropdownlists_paths[i])).to exist
          expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) " + dropdownlists_paths[i] + " .ko_dropdownlist_button .text").text).to eq("All Mail Apps")
      end
      expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) .field_label").text).to eq(field_labels_comparison_texts[i])
    else
      expect(@ui.css(rule_configurations_string + " div:nth-child(#{i}) #rule_advanced_toggle")).not_to be_present
    end
  end

  buttons_path = '#new_rule_modal div:nth-child(2) .rule-modal-buttons'
  expect(@ui.css(buttons_path + ' #policy-rule-cancel')).to be_present
  expect(@ui.css(buttons_path + ' #policy-rule-submit')).to be_present
end

def verify_rule_components(what_policy_type, what_row, type, name, action, layer, protocol, port, source, destination, enabled)
  case what_policy_type
    when "Global Policy"
      row = 1
    when "SSID Policy"
      row = 2
    when "Personal SSID Policy"
      row = 3
    when "User Group Policy"
      row = 4
    when "Device Policy"
      row = 5
  end
  if name == ""
    name = type
  end
  path = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{row}) div .policy-body .policy-rule-layer-container .policy-rules-container li:nth-child(#{what_row})"
  verify_hash = Hash[1 => what_row + ".", 2 => "policy-rule-icon icon-" + type.downcase, 3 => action + " " + name + " " + what_row, 4 => "Layer: " + layer, 5 => "Protocol: " + protocol, 6 => "Port: " + port, 7 => "Source: " + source, 8 => "Dest: " + destination, 9 => "Allow/Block: " + action.upcase, 10 => enabled, 11 => "policy-rule-menu-btn icon-menu"]
  (1..11).each do |i|
    if i == 2
      control_type = " i"
      expect(@ui.css(path + control_type + ":nth-child(#{i})").attribute_value("class")).to eq(verify_hash[i])
    elsif i == 3
      control_type = " a"
      expect(@ui.css(path + control_type + ":nth-child(#{i})").text).to eq(verify_hash[i])
    elsif i == 10
      control_type = " span"
      expect(@ui.get(:checkbox , {css: path + control_type + ":nth-child(#{i}) input"}).set?).to eq(verify_hash[i])
    elsif i == 11
      control_type = " span"
      expect(@ui.css(path + control_type + ":nth-child(#{i}) i").attribute_value("class")).to eq(verify_hash[i])
    else
      control_type = " span"
      expect(@ui.css(path + control_type + ":nth-child(#{i})").text).to eq(verify_hash[i])
    end
  end
end

def verify_policy_schedule(policy_type, schedule_days, from_time, to_time, all_day_check)
  case policy_type
    when "SSID Policy"
      i = 2
    when "Personal SSID Policy"
      i = 3
    when "User Group Policy"
      i = 4
    when "Device Policy"
      i = 5
  end
  policy_body = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{i}) .policy.greybox .policy-head"
  if policy_type != "Personal SSID Policy"
    if all_day_check == true
      expect(@ui.css(policy_body + " .policy-head-left .policy-schedule").text).to eq(schedule_days + " - All Day")
    else
      expect(@ui.css(policy_body + " .policy-head-left .policy-schedule").text).to eq(schedule_days + " - " + from_time + " - " + to_time)
    end
  else
    expect(@ui.css(policy_body + " .policy-head-left .policy-schedule").text).to eq("")
  end
end

def create_new_policy_type(path, policy_type, policy_icon, policy_name, policy_device_class, policy_device_type, use_x320, user_group_use_dropdown)
  @browser.refresh
  sleep 5
  @browser.execute_script('$("#suggestion_box").hide()')
  @ui.css(path + " .policy-new-icon.xcp-icon-" + policy_icon).click
  sleep 0.5
  if policy_type != "Personal SSID Policy"
    expect(@ui.css('#new_policy_modal')).to be_present
    sleep 0.5
    case policy_type
      when "SSID Policy"
        @ui.set_dropdown_entry("new_policy_ssids_select", policy_name)
      when "User Group Policy"
        @ui.set_input_val("#new_policy_usergroup", policy_name)
        if user_group_use_dropdown != nil
          #@ui.set_input_val("#new_policy_usergroup_radius", policy_name)
          @ui.set_dropdown_entry_by_path("#new_policy_usergroup_radius .ko_dropdownlist_combo", policy_name)
        else
          #@ui.set_input_val("#new_policy_usergroup_radius", policy_name)
          @ui.set_input_val(".ko_dropdownlist_combo_input", policy_name)
        end
        sleep 0.5
        @browser.execute_script('$("#ko_dropdownlist_overlay").hide()')
      when "Device Policy"
        @ui.set_input_val("#new_policy_device_name", policy_name)
        sleep 0.5
        @ui.set_dropdown_entry("new_policy_device_class", policy_device_class)
        if use_x320 != true
          sleep 0.5
          @ui.set_dropdown_entry("new_policy_device_type", policy_device_type)
        end
    end
    sleep 0.5
    @ui.click("#new_policy_submit")
    sleep 0.5
  end
end


################################################################################################################################################################################################################################################################################################
################################################################################################################################################################################################################################################################################################
################################################################################################################################################################################################################################################################################################
################################################################################################################################################################################################################################################################################################

shared_examples "go to the policies tab" do |profile_name|
  describe "go to the policies tab" do
    it "Press the Policies tab icon and ensure the navigation works properly" do
      @ui.goto_profile profile_name
      @ui.click("#profile_config_tab_policies")
      sleep 2
      expect(@browser.url).to include("/config/policies")
    end
  end
end

shared_examples "general policy tab features" do |profile_name|
  describe "Test the general features on the policies tab" do
    it "Verify the Policies icon and button text (on the tab)" do
      @ui.goto_profile profile_name
      sleep 2
      expect(@ui.css('#profile_config_tab_policies div:nth-child(1)').attribute_value("class")).to eq('icon policies')
      expect(@ui.css('#profile_config_tab_policies div:nth-child(2)').attribute_value("data-bind")).to eq('localize:nameKey')
      expect(@ui.css('#profile_config_tab_policies div:nth-child(2)').text).to eq('Policies')
    end
    it "Ensure you are on the policies tab" do
      @ui.click('#profile_config_tab_policies')
      sleep 2
      expect(@browser.url).to include('/config/policies')
    end
    it "Verify the title and subtitle are properly displayed" do
      expect(@ui.css('#profile_config_policies .commonTitle span:nth-child(1)').text).to eq('Policies')
      expect(@ui.css('#profile_config_policies .commonTitle xhelp a span').attribute_value("class")).to eq('koHelpIcon')
      expect(@ui.css('#profile_config_policies .commonTitle xhelp a').attribute_value("href")).to include('docs/help/index.html#ProfilesPolicies')
      expect(@ui.css('#profile_config_policies .commonSubtitle').text).to eq("Applies to access points only. Policies are sets of conditions, constraints, and settings that allow you to decide who can connect to the network, and how or when they are allowed to connect. Note: Layer 2 policy rules will be enforced before Layer 3 rules.")
      if @ui.css('#profile_config_policies .profile-policies-xr320limited.warning').exists? and @ui.css('#profile_config_policies .profile-policies-xr320limited.warning').visible?
        expect(@ui.css('#profile_config_policies .profile-policies-xr320limited.warning').text).to eq("Functionality is limited for XR-320/X2-120 Access Points.\nThere are no Policies for device types (i.e. specific devices such as iPhone), or scheduling of any Policies.")
      end
    end
    it "Verify that there is only one filter gray box that points to the 'View type'" do
      expect(@ui.css('#profile_config_policies .greybox.filter .label').text).to eq("View:")
      expect(@ui.css('#profile_config_policies .greybox.filter #policies-filter')).to exist
      expect(@ui.css('#profile_config_policies .greybox.filter #policies-filter .ko_dropdownlist_button .text').text).to eq("All Policies")
      expect(@ui.css('#profile_config_policies .greybox.filter dl:nth-child(3)')).to exist
    end
    it "Verify that the 'Expand All' link exists" do
      expect(@ui.css('#policy-expand-all')).to be_present
    end
    it "Verify that the policies container displays all 5 types of policies (correct names, icons and buttons)" do
      policy_names = Hash[1 => "Global Policy", 2 => "SSID Policy", 3 => "Personal SSID Policy", 4 => "User Group Policy", 5 => "Device Policy"]
      policy_icons = Hash[1 => "global", 2 => "ssid", 3 => "personal", 4 => "user-group", 5 => "device"]
      (1..5).each do |i|
        puts i
        expect(@ui.css("#profile_config_policies div:nth-child(#{i})")).to exist
        puts @ui.css("#profile_config_policies .policy-type-container:nth-child(#{i}) .policy.greybox .policy-head .policy-head-left .policy-name").text
        expect(@ui.css("#profile_config_policies .policy-type-container:nth-child(#{i}) .policy.greybox .policy-head .policy-head-left .policy-name").text).to eq(policy_names[i])
        expect(@ui.css("#profile_config_policies .policy-type-container:nth-child(#{i}) .policy.greybox .policy-head i:first-child").attribute_value("class")).to eq("policy-icon xcp-icon-" + policy_icons[i])
        if i == 1
          expect(@ui.css("#profile_config_policies .policy-type-container:nth-child(#{i}) .policy.greybox .policy-head .policy-head-right button").attribute_value("class")).to eq("white v-center push-left")
          expect(@ui.css("#profile_config_policies .policy-type-container:nth-child(#{i}) .policy.greybox .policy-head .policy-head-right .policy-rule-count").text).to eq("0 Rules")
        else
          expect(@ui.css("#profile_config_policies .policy-type-container:nth-child(#{i}) .policy.greybox .policy-head .policy-head-right button").attribute_value("class")).to eq("white v-center")
          expect(@ui.css("#profile_config_policies .policy-type-container:nth-child(#{i}) .policy.greybox .policy-head i:nth-child(4)")).to be_visible
          expect(@ui.css("#profile_config_policies .policy-type-container:nth-child(#{i}) .policy.greybox .policy-head i:nth-child(4)").attribute_value("class")).to eq("policy-new-icon xcp-icon-new-policy xcp-icon-" + policy_icons[i])
          expect(@ui.css("#profile_config_policies .policy-type-container:nth-child(#{i}) .policy.greybox .policy-head .policy-head-right .policy-rule-count")).not_to exist
        end
      end
    end
  end
end



shared_examples "create a rule for any policy" do |policy_type, policy_name, policy_device_class, policy_device_type, rule_type, rule_name, enabled, action, layer, protocol, port, source, destination, use_advanced, traffic_shaping_option, rule_category, rule_application, rule_source_device, rule_source_dest|
  describe "Create the rule named '#{rule_name}' for the '#{policy_type}' policy " do
    it "Ensure you are on the 'Policies' tab" do
      if !@browser.url.include?('/config/policies')
        @ui.click('#profile_config_tab_policies')
        sleep 2
        expect(@browser.url).to include('/config/policies')
      end
      sleep 1
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 4
      if @ui.css('#policy-collapse-all').present?
        @ui.css('#policy-collapse-all').click
      end
    end
    it "Create the rule named '#{rule_name}' for the '#{policy_type}' having the name '#{policy_name}' and having the values: type = '#{rule_type}', action = '#{action}', layer = '#{layer}', protocol = '#{protocol}', port = '#{port}', source = '#{source}', destination = '#{destination}', enabled = '#{enabled}', use advanced? = '#{use_advanced}', traffic shping option = '#{traffic_shaping_option}', rule category = '#{rule_category}', rule application = '#{rule_application}', rule source device = '#{rule_source_device}', rule source destination = '#{rule_source_dest}'" do
      case policy_type
        when "Global Policy"
          row = 1
        when "SSID Policy"
          row = 2
          policy_icon = "ssid"
        when "Personal SSID Policy"
          row = 3
          policy_icon = "personal"
        when "User Group Policy"
          row = 4
          policy_icon = "user-group"
        when "Device Policy"
          row = 5
          policy_icon = "device"
      end
      path = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{row}) .policy.greybox .policy-head"
      @browser.execute_script('$("#suggestion_box").hide()')

      policy_containers_same_type = @ui.get(:elements, {css: "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{row}) .policy.greybox"})
      policy_containers_same_type.each_with_index do |policy_container_same_type, index|
        o = index + 1
        path = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{row}) .policy.greybox:nth-child(#{o}) .policy-head"
        if policy_type != "Global Policy"
          user_group_use_dropdown = nil
          if policy_name.class == Array
            policy_name = policy_name[0]
            user_group_use_dropdown = true
          end
          if @ui.css(path + " .policy-head-right .policy-rule-count").present? == false
              puts "PRIMU CASE"
              create_new_policy_type(path, policy_type, policy_icon, policy_name, policy_device_class, policy_device_type, false, user_group_use_dropdown)
              sleep 0.5
              if policy_type == "User Group Policy"
                #if user_group_use_dropdown == nil
                #  expect(@ui.css('#new_policy_usergroup_radius input')).to exist
                #  @ui.set_input_val('#new_policy_usergroup_radius input', policy_name)
                #  #expect(@ui.css('#policy-usergroup-radiusfilterid')).to exist
                #  #@ui.set_input_val('#policy-usergroup-radiusfilterid', policy_name)
                #end
                sleep 1
              end
              @ui.click(path + " .policy-head-right button")
          elsif @ui.css(path + " .policy-head-left .policy-name").text.rstrip == policy_name
              sleep 1
              puts "NAME THE SAME SKIPPED"
              @ui.click(path + " .policy-head-right button")
              break
          elsif @ui.css(path + " .policy-head-left .policy-name").text != policy_name
            if o == policy_containers_same_type.length
              puts "AL TREILEA CHASE"
              create_new_policy_type(path, policy_type, policy_icon, policy_name, policy_device_class, policy_device_type, false, user_group_use_dropdown)
              @ui.click(path + " .policy-head-right button")
            end
          end
        else
          @ui.click(path + " .policy-head-right button")
        end
      end

      sleep 0.5
      expect(@ui.css('#new_rule_modal')).to be_present
      if rule_type == "firewall"
        button_no = 1
      elsif rule_type == "application"
        if @ui.css('#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types').lis.length == 2
          button_no = 2
        else
          button_no = 3
        end
      else
        button_no = 2
      end
      rule_selection_path = "#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types .rule-type:nth-of-type(#{button_no}) label .rule-type-icon.xcp-icon-" + rule_type
      @ui.click(rule_selection_path)
      sleep 0.5
      if rule_type != "aircleaner"
        rule_configuration_path = "#new_rule_modal div:nth-child(2) .rule-configuration"
        if rule_name != ""
          @ui.click('#rule_autoname .switch_label')
          sleep 0.5
          @ui.set_input_val("#rule_name", rule_name)
        end
        sleep 0.5
        if enabled == false
          @ui.click("#rule_enable .switch_label")
        end
        sleep 0.5
        if action == "allow" and rule_type == "application"
          @ui.click("#rule_action .switch_label")
        elsif action == "block" and rule_type == "firewall"
          @ui.click("#rule_action .switch_label")
        end
        sleep 0.5
        if rule_type == "firewall"
          if layer == "2"
            @ui.click("#rule_layer .switch_label")
          end
          sleep 0.5
          @ui.set_dropdown_entry("rule_protocol", protocol)
          sleep 0.5
          if protocol != "ANY"
            @ui.set_dropdown_entry("rule_port", port)
            if port == "Numeric"
              @ui.set_input_val("#rule_port_start", "#{UTIL.ickey_shuffle(3)}")
            end
          end
          sleep 0.5
          @ui.set_dropdown_entry("rule_source", source)
          if source == "IP Address"
            @ui.set_input_val("#rule_source_extra", "#{UTIL.random_ip_address}.#{UTIL.random_ip_address}.#{UTIL.random_ip_address}.#{UTIL.random_ip_address}")
          elsif source == "Device"
            @ui.set_dropdown_entry('rule_source_device', rule_source_device)
          end
          sleep 0.5
          @ui.set_dropdown_entry("rule_destination", destination)
          if destination == "IP Address"
            @ui.set_input_val("#rule_destination_extra", "#{UTIL.random_ip_address}.#{UTIL.random_ip_address}.#{UTIL.random_ip_address}.#{UTIL.random_ip_address}")
          elsif source == "Device"
            @ui.set_dropdown_entry('rule_destination_device', rule_source_dest)
          end
          sleep 0.5
          if use_advanced == true and action != "block" and layer == "3"
            @ui.click("#rule_advanced_toggle")
            sleep 0.5
            case traffic_shaping_option
              when "QoS"
                @ui.click("#new_rule_modal .rulesAdvanced div:nth-child(2) label")
                sleep 0.5
                @ui.set_input_val("#ruleModalQos", "2")
              when "DSCP"
                @ui.click("#new_rule_modal .rulesAdvanced div:nth-child(3) label")
                sleep 0.5
                @ui.set_input_val("#ruleModalDscp", "2")
              when "Limit Traffic"
                @ui.click("#new_rule_modal .rulesAdvanced div:nth-child(4) label")
                sleep 0.5
                @ui.set_input_val("#trafficInput", "20")
            end
          end
          if use_advanced == true and action != "block" and layer == "2"
            @ui.click("#rule_advanced_toggle")
            sleep 0.5
            @ui.click("#new_rule_modal .rulesAdvanced div:nth-child(2) label")
            sleep 0.5
            @ui.set_input_val("#ruleModalQos", "2")
          end
        elsif rule_type == "application"
          # @ui.set_dropdown_entry('app-search', rule_category)
          # sleep 2
          @ui.set_dropdown_entry('app-search', rule_application)
        end
      end
      @ui.click("#new_rule_modal .title_wrap .xcp-icon-circle-plus")
      sleep 0.5
      @ui.css("#policy-rule-submit").hover
      @ui.click("#policy-rule-submit")
      sleep 1
      expect(@ui.css('#new_rule_modal')).not_to be_present
    end
  end
end

shared_examples "search for rule and verify it" do |rule_name, type, action, layer, protocol, port, source, destination, enabled, aircleaner, webtitan, schedule|
  describe "Search for the rule named '#{rule_name}' and verify it has the proper values" do
    it "Ensure you are on the 'Policies' tab then save the profile" do
      if !@browser.url.include?('/config/policies')
        @ui.click('#profile_config_tab_policies')
        sleep 2
        expect(@browser.url).to include('/config/policies')
      end
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 1
      if @ui.css('.error').exists?
        expect(@ui.css('.error')).not_to be_visible
      end
    end
    it "Verify that the rule '#{rule_name}' exists and has the values: type = '#{type}', action = '#{action}', layer = '#{layer}', protocol = '#{protocol}', port = '#{port}', source = '#{source}', destination = '#{destination}', enabled = '#{enabled}', aircleaner = '#{aircleaner}', WebTitan = '#{webtitan}', schedule = '#{schedule}'" do
      if @ui.css("#policy-collapse-all").visible?
        @ui.click("#policy-collapse-all")
        sleep 0.5
        puts "colapse"
      end
        general_path = "#profile_config_policies .policies-container"
        containers_path = general_path + " .policy-type-container"
        expect(@ui.get(:elements , {css: containers_path }).length).to eq(5)
        puts "containers exist"
        continue_loop = true
        (1..5).each do |i|
          if !continue_loop
            break
          end
          if i == 1
            @rule_not_found = true
          end
          puts "POLICY NUMBER =  #{i}"
          policy_containers_same_type = @ui.get(:elements, {css: "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{i}) .policy.greybox"})
          policy_containers_same_type.each_with_index do |policy_container_same_type, index|
            o = index + 1
            policy_path = general_path + " .policy-type-container:nth-of-type(#{i}) .policy.greybox:nth-child(#{o})"
            expect(@ui.css(policy_path)).to be_present
            puts "am ajuns aici"
            rule_count = @ui.css(policy_path + " .policy-head .policy-head-right .policy-rule-count")
            if rule_count.exists? and rule_count.text != "0 Rules"
              @browser.execute_script('$("#suggestion_box").hide()')
              expand_path = policy_path + " .policy-toggle-icon.xcp-icon-triangle"
              expect(@ui.css(expand_path)).to be_present
              @ui.css(expand_path).click
              sleep 0.5
                if @ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(1)').visible?
                  puts "layer 1 visible"
                  layers = 1
                  control = 0
                end
                if @ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(2)').visible?
                  puts "layer 2 visible"
                  layers = 2
                  control = 0
                  if !@ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(1)').visible?
                    puts "layer 1 not visible"
                    control = 2
                  end
                end
                if @ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(3)').visible?
                  puts "layer 3 visible"
                  layers = 3
                  control = 0
                  if !@ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(2)').visible?
                    puts "layer 1 not visible"
                    control = 2
                  elsif !@ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(1)').visible?
                    puts "layer 2 not visible"
                    control = 3
                  end
                end
              while layers >= control
                puts "**** #{layers} layers present"
                if @ui.css(policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(#{layers}) ul:nth-of-type(2)").exists?
                    puts "webtitan exits !!!"
                    body_path = policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(#{layers}) ul:nth-of-type(2)"
                else
                    body_path = policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(#{layers}) ul"
                end
                rules2 = @ui.get(:elements , {css: body_path})
                rules2.each_with_index { |rr, index|
                  @index = index
                }
                if webtitan == true and layers == 2
                  @index = 1
                  body_path = policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(2) ul"
                end
                puts "index = #{@index}"
                while @index > 0
                  puts "#{@index} - row"
                  case type
                    when "firewall"
                      verify_hash = Hash[2 => "policy-rule-icon xcp-icon-" + type.downcase, 3 => rule_name, 4 => "Layer: " + layer, 5 => "Protocol: " + protocol, 6 => "Port: " + port, 7 => "Source: " + source, 8 => "Dest: " + destination, 9 => "Allow/Block: " + action.upcase, 10 => enabled, 11 => "policy-rule-menu-btn xcp-icon-menu"]
                      max_value = 11
                    when "application"
                      verify_hash = Hash[2 => "policy-rule-icon xcp-icon-" + type.downcase, 3 => rule_name, 4 => "Layer: " + layer, 5 => "Category: " + protocol, 6 => "Application: " + port, 7 => "Allow/Block: " + action.upcase, 8 => enabled, 9 => "policy-rule-menu-btn xcp-icon-menu"]
                      max_value = 9
                  end
                  if webtitan == true
                    max_value = 10
                  end

                  (2..max_value).each do |o|
                    if @ui.css(body_path + " li:nth-child(#{@index}) a:nth-child(3)").text == rule_name
                      @rule_not_found = false
                      puts "AM GASIT REGULA !!!"
                      if o == 2
                        if webtitan == true
                          control_type = " div"
                        else
                          control_type = " i"
                        end

                        disabled_icon = ""
                        if enabled == false
                          disabled_icon = " disabled"
                        end
                        if aircleaner == true
                          verify_hash[2] = "policy-rule-icon xcp-icon-aircleaner"
                        end
                        expect(@ui.css(body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{o})").attribute_value("class")).to eq(verify_hash[o] + disabled_icon)
                      elsif o == 3
                        control_type = " a"
                        if verify_hash[o].include?"IP Address"
                          expect(@ui.css(body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{o})").text).not_to eq(verify_hash[o])
                        else
                          expect(@ui.css(body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{o})").text).to eq(verify_hash[o])
                        end
                      elsif o == 10
                        a = o
                        if webtitan == true
                          control_type = " div"
                        elsif schedule != ""
                          control_type = " span"
                          expect(@ui.css(body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{o})").text).to eq(schedule)
                          a = 11
                        else
                          control_type = " span"
                        end
                        expect(@ui.get(:checkbox , {css: body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{a}) input"}).set?).to eq(verify_hash[o])
                      elsif o == 11
                        control_type = " span"
                        if schedule != ""
                          a = 12
                          expect(@ui.css(body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{a}) i").attribute_value("class")).to eq(verify_hash[o])
                        else
                          expect(@ui.css(body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{o}) i").attribute_value("class")).to eq(verify_hash[o])
                        end
                      #elsif type == "application" and o == 6
                      #  puts "SKIPPED DUE TO BUG !!!!!!!!!!!!!"
                      elsif type == "application" and o == 8
                        control_type = " span"
                        a = o
                        if schedule != ""
                          expect(@ui.css(body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{o})").text).to eq(schedule)
                          a = 9
                        end
                        expect(@ui.get(:checkbox , {css: body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{a}) input"}).set?).to eq(verify_hash[o])
                      elsif webtitan == true and o == 9
                        expect(@ui.css(body_path + " li:nth-child(#{@index}) div:nth-child(#{o})").text).to eq(verify_hash[o])
                      elsif type == "application" and o == 9
                        control_type = " span"
                        a = o
                        if schedule != ""
                          a = 10
                        end
                        expect(@ui.css(body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{a}) i").attribute_value("class")).to eq(verify_hash[o])
                      else
                        control_type = " span"
                        if protocol == "ANY" and type == "firewall"
                          verify_hash[6] = "Port: ANY"
                        end
                        if verify_hash[o].include?"IP Address"
                          expect(@ui.css(body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{o})").text).not_to eq(verify_hash[o])
                        else
                          expect(@ui.css(body_path + " li:nth-child(#{@index})" + control_type + ":nth-child(#{o})").text).to eq(verify_hash[o])
                        end
                      end
                      if o == max_value
                        puts "AM VERIFICAT TOT"
                        continue_loop = false
                      end
                    end
                  end
                  @index -= 1
                end
                layers -= 1
              end
            end
          end
        end
      if @rule_not_found == true
        expect(@rule_not_found).to eq(false)
      end
      #end
    end
  end
end

shared_examples "search for policy and delete it" do |policy_type, policy_name|
  describe "Search for the policy named '#{policy_name}' and delete it" do
    it "Ensure you are on the 'Policies' tab then save the profile" do
      if !@browser.url.include?('/config/policies')
        @ui.click('#profile_config_tab_policies')
        sleep 2
        expect(@browser.url).to include('/config/policies')
      end
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 0.5
    end
    it "Find the policy of type '#{policy_type}' and name '#{policy_name}' and delete it" do
      if @ui.css("#policy-collapse-all").visible?
        @ui.click("#policy-collapse-all")
        sleep 1
        puts "colapse"
      end
      policy_found = false
      general_path = "#profile_config_policies .policies-container"
      containers_path = general_path + " .policy-type-container"
      expect(@ui.get(:elements , {css: containers_path }).length).to eq(5)
      case policy_type
        when "SSID Policy"
          i = 2
        when "Personal SSID Policy"
          i = 3
        when "User Group Policy"
          i = 4
        when "Device Policy"
          i = 5
      end
      policy_containers_same_type = @ui.get(:elements, {css: "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{i}) .policy.greybox"})
      policy_containers_same_type.each_with_index do |policy_container_same_type, index|
        o = index + 1
        @policy_path = general_path + " .policy-type-container:nth-of-type(#{i}) .policy.greybox:nth-child(#{o})"
        expect(@ui.css(@policy_path)).to be_present
        puts @ui.css(@policy_path + " .policy-head .policy-head-left .policy-info").text
        puts @ui.css(@policy_path + " .policy-head .policy-head-left .policy-name").text
        puts "am ajuns aici"
        if ["SSID Policy", "Device Policy"].include? policy_type
          if @ui.css(@policy_path + " .policy-head .policy-head-left .policy-info").text == policy_name
            policy_found = true
            break
          end
        else
          if @ui.css(@policy_path + " .policy-head .policy-head-left .policy-name").text == policy_name
            policy_found = true
            break
          end
        end
      end
      expect(policy_found).to be_truthy
      @ui.click(@policy_path + " .policy-head .policy-head-right .policy-menu-container")
      sleep 1
      expect(@ui.css(@policy_path + " .policy-head .policy-head-right .policy-menu-container .xc-dropdown-menu")).to be_present
      @ui.click(@policy_path + " .policy-head .policy-head-right .policy-menu-container .xc-dropdown-menu .xcp-icon-trash")
      sleep 1
      @ui.click('#_jq_dlg_btn_1')
      sleep 3
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 3
    end
    it "Verify that the policy is properly removed" do
       if @ui.css("#policy-collapse-all").visible?
        @ui.click("#policy-collapse-all")
        sleep 0.5
        puts "colapse"
      end
      policy_found = false
      general_path = "#profile_config_policies .policies-container"
      containers_path = general_path + " .policy-type-container"
      expect(@ui.get(:elements , {css: containers_path }).length).to eq(5)
      case policy_type
        when "SSID Policy"
          i = 2
        when "Personal SSID Policy"
          i = 3
        when "User Group Policy"
          i = 4
        when "Device Policy"
          i = 5
      end
      if !@ui.css(containers_path + ":nth-of-type(#{i}) div").attribute_value("class").include?"policy-empty"
        puts "searching"
        policy_containers_same_type = @ui.get(:elements, {css: "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{i}) .policy.greybox"})
        policy_containers_same_type.each_with_index do |policy_container_same_type, index|
          o = index + 1
          policy_path = general_path + " .policy-type-container:nth-of-type(#{i}) .policy.greybox:nth-child(#{o})"
          expect(@ui.css(policy_path)).to be_present
          puts "am ajuns aici"
          if ["SSID Policy", "Device Policy"].include? policy_type
            if @ui.css(policy_path + " .policy-head .policy-head-left .policy-info").text == policy_name
              policy_found = true
              break
            end
          else
            if @ui.css(policy_path + " .policy-head .policy-head-left .policy-name").text == policy_name
              policy_found = true
              break
            end
          end
        end
      end
      expect(policy_found).to be_falsey
    end
  end
end

shared_examples "search for aircleaner rules and verify them" do
  it_behaves_like "search for rule and verify it", "Air-cleaner-mDNS.1", "firewall", "allow", "2", "ANY", "ANY", "Any", "MAC Address", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Arp.1", "firewall", "block", "2", "ARP", "ANY", "IAP", "IAP", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Dhcp.1", "firewall", "block", "2", "UDP", "BOOTPS", "GIG", "MAC Address", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Dhcp.2", "firewall", "block", "2", "UDP", "BOOTPC", "IAP", "MAC Address", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Nbios.1", "firewall", "block", "2", "UDP", "NetBIOS", "Any", "Any", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Mcast.1", "firewall", "block", "2", "ANY", "ANY", "Any", "MAC Address", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Mcast.2", "firewall", "block", "2", "ANY", "ANY", "Any", "MAC Address", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Mcast.3", "firewall", "block", "2", "ANY", "ANY", "Any", "MAC Address", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Bcast.1", "firewall", "allow", "2", "ARP", "ANY", "Any", "MAC Address", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Bcast.2", "firewall", "allow", "2", "UDP", "BOOTPS", "Any", "MAC Address", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Bcast.3", "firewall", "allow", "2", "UDP", "BOOTPC", "Any", "MAC Address", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Bcast.4", "firewall", "allow", "2", "UDP", "XRP", "Any", "MAC Address", true, true, false, ""
  it_behaves_like "search for rule and verify it", "Air-cleaner-Bcast.5", "firewall", "block", "2", "ANY", "ANY", "Any", "MAC Address", true, true, false, ""
end

shared_examples "verify scenario when aicleaner cannot be set" do
  describe "Verify that the aircleaner rules can't be set if the Global Policy already contains 13 other rules" do
    it "Ensure you are on the policies tab" do
      if !@browser.url.include?('/config/policies')
        @ui.click('#profile_config_tab_policies')
        sleep 2
        expect(@browser.url).to include('/config/policies')
      end
      @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Expect that the rule count for 'Global Policy' is '13 Rules', expand it and open the 'Add rule' modal" do
      if @ui.css('#policy-collapse-all').visible?
        @ui.css('#policy-collapse-all').click
        sleep 0.5
      end
      global_policy_path = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy"
      expect(@ui.css(global_policy_path + " .policy-head .policy-head-right .policy-rule-count").text).to eq("13 Rules")
      sleep 0.5
      @ui.click(global_policy_path + " .policy-head .policy-toggle-icon")
      sleep 0.5
      @ui.click(global_policy_path + " .policy-body .policy-footer button")
      sleep 0.5
      expect(@ui.css("#new_rule_modal")).to be_present
    end
    it "Verify that the available rule types are only 'Firewall' and 'Application Control' and that the 'Air Cleaner' is grayed out" do
      expect(@ui.css("#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types").lis.length).to eq(3)
      expect(@ui.css("#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types li:nth-of-type(1)")).to be_present
      expect(@ui.css("#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types li:nth-of-type(2)")).to be_present
      expect(@ui.css("#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types li:nth-of-type(2)").attribute_value("class")).to eq("rule-type disabled")
      expect(@ui.css("#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types li:nth-of-type(3)")).to be_present
      @ui.click('#new_rule_modal_closemodalbtn')
    end
  end
end


shared_examples "verify max 25 rules added for policy" do |profile_name, policy_type, policy_name, firewall2_count, firewall3_count, appcon_count|
  describe "Test that the policy named '#{policy_name}' of the type '#{policy_type}' properly displayes that it has 25 maximum rules added" do
    it "Ensure you are on the policies tab of the profile named '#{profile_name}'" do
      @ui.click('#header_logo')
      sleep 3
      @ui.goto_profile profile_name
      sleep 2
      if !@browser.url.include?('/config/policies')
        @ui.click('#profile_config_tab_policies')
        sleep 2
        expect(@browser.url).to include('/config/policies')
      end
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 0.5
      @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Find the container for the policy type '#{policy_type}' end expect the title to be '#{policy_name}' and the rules count to eq '25 Rules'" do
      general_path = "#profile_config_policies .policies-container"
      containers_path = general_path + " .policy-type-container"
      expect(@ui.get(:elements , {css: containers_path }).length).to eq(5)
      sleep 1
      case policy_type
        when "Global Policy"
          i = 1
        when "SSID Policy"
          i = 2
        when "Personal SSID Policy"
          i = 3
        when "User Group Policy"
          i = 4
        when "Device Policy"
          i = 5
      end
      policy_path = containers_path + ":nth-of-type(#{i})"
      expect(@ui.css(policy_path + " .policy .policy-head .policy-head-left .policy-name").text).to eq(policy_name)
      expect(@ui.css(policy_path + " .policy .policy-head .policy-head-right .policy-rule-count").text).to eq("25 Rules")
    end
    it "Verify that the 'Add a Rule' button is disabled and that the rules grid shows 25 rules spread out as following: Fireawll layer 2 '#{firewall2_count}', Firewall layer 3 '#{firewall3_count}', Application Control layer 7 '#{appcon_count}'" do
      case policy_type
        when "Global Policy"
          i = 1
        when "SSID Policy"
          i = 2
        when "Personal SSID Policy"
          i = 3
        when "User Group Policy"
          i = 4
        when "Device Policy"
          i = 5
      end
      policy_path = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{i})"
      expect(@ui.css(policy_path + " .policy .policy-head .policy-head-right button").attribute_value("disabled")).to eq("true")
      sleep 0.5
      @ui.css(policy_path + " .policy .policy-head .policy-toggle-icon").click
      sleep 0.5
      for container_number in 1..3 do
        bool_skip_look = false
        case container_number
          when 1
            if firewall2_count == 0
              bool_skip_look = true
            end
          when 2
            if firewall3_count == 0
              bool_skip_look = true
            end
          when 3
            if appcon_count == 0
              bool_skip_look = true
            end
        end
        if bool_skip_look != true
          expect(@ui.css(policy_path + " .policy .policy-body .policy-rule-layer-container:nth-of-type(#{container_number})")).to be_present
          sleep 0.5
          body_path = policy_path + " .policy .policy-body .policy-rule-layer-container:nth-of-type(#{container_number}) ul"
          expect(@ui.css(body_path)).to be_present
          rules_length = @ui.get(:elements , {css: body_path})
          rules_length.each_with_index { |rr, index|
            @index = index
          }
          case container_number
            when 1
              expect(@index).to eq(firewall2_count)
            when 2
              expect(@index).to eq(firewall3_count)
            when 3
              expect(@index).to eq(appcon_count)
          end
        end
      end
    end
  end
end

shared_examples "create max available policies" do |profile_name, policy_type, policy_name, device_class, device_type|
  describe "Create the maxim number of policies that the application allows (8)" do
    it "Ensure you are on the policies tab of the profile named '#{profile_name}'" do
      @ui.goto_profile profile_name
      sleep 2
      if !@browser.url.include?('/config/policies')
        @ui.click('#profile_config_tab_policies')
        sleep 2
        expect(@browser.url).to include('/config/policies')
      end
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 0.5
      @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Add 8 policies of the type '#{policy_type}'" do
      (1..8).each_with_index do |rr, index|
        sleep 1
        if index == 0 or index == 1
          a = 1
        else
          a = index
        end
        b = index + 1
        case policy_type
          when "SSID Policy"
            i = 2
          when "User Group Policy"
            i = 4
          when "Device Policy"
            i = 5
        end
        policy_container = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{i}) .policy:nth-of-type(#{a})"
        puts "***** " + policy_container
        expect(@ui.css(policy_container)).to exist
        policy_add_button = policy_container + " .policy-head .policy-new-icon"
        expect(@ui.css(policy_add_button)).to exist
        @ui.css(policy_add_button).click
        sleep 1

        case policy_type
          when "SSID Policy"
            @ui.set_dropdown_entry("new_policy_ssids_select", policy_name + "#{b}")
          when "User Group Policy"
            @ui.set_input_val("#new_policy_usergroup",  policy_name + UTIL.ickey_shuffle(4).to_s)
            sleep 0.5
            @ui.set_input_val("#new_policy_usergroup_radius input", policy_name + UTIL.ickey_shuffle(4).to_s)
          when "Device Policy"
            @ui.set_input_val("#new_policy_device_name", policy_name + UTIL.ickey_shuffle(4).to_s + index.to_s)
            sleep 0.5
            @ui.set_dropdown_entry("new_policy_device_class", device_class)
            sleep 0.5
            @ui.set_dropdown_entry("new_policy_device_type", device_type)
        end
        sleep 0.5
        @ui.click('#new_policy_submit')
        # @ui.css('#new_policy_modal').wait_while_present
        sleep 0.5
        # @ui.click('#profile_config_save_btn')
        press_profile_save_config_no_schedule
        sleep 3
        # @ui.css('.dialogOverlay.success').wait_until_present
        # if @ui.css('.dialogOverlay.success').exists?
          # if @ui.css('.dialogOverlay.success').visible?
            # @ui.css('.dialogOverlay.success').wait_while_present
          # end
        # end
      end
    end
    it "Verify that the policy type '#{policy_type}' has x policies" do
      case policy_type
          when "SSID Policy"
            i = 2
          when "User Group Policy"
            i = 4
          when "Device Policy"
            i = 5
        end
      (1..8).each_with_index do |rr, index|
        a = index + 1
        policy_container = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{i}) .policy:nth-of-type(#{a})"
        expect(@ui.css(policy_container)).to exist
      end
    end
  end
end

shared_examples "schedule rule and verify it" do |rule_name, rule_type, rule_layer, schedule_days, from_time, to_time, all_day_check, webtitan| #, profile_name|
  describe "Schedule the rule named #{rule_name} so that it runs only on the time frame #{schedule_days} and verify the application properly displayes this" do
    it "Ensure you are on the policies tab" do
      #@ui.goto_profile profile_name
      if !@browser.url.include?('/config/policies')
        @ui.click('#profile_config_tab_policies')
        sleep 2
        expect(@browser.url).to include('/config/policies')
      end
      sleep 0.5
      @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Find the rule named '#{rule_name}' and set the schedule to '#{schedule_days} - #{from_time} to #{to_time}' or verify that layer 2 rules can't be scheduled" do
        if @ui.css("#policy-collapse-all").visible?
          @ui.click("#policy-collapse-all")
          sleep 0.5
          puts "colapse"
        end
          general_path = "#profile_config_policies .policies-container"
          containers_path = general_path + " .policy-type-container"
          expect(@ui.get(:elements , {css: containers_path }).length).to eq(5)
          puts "containers exist"
          (1..5).each do |i|
            if i == 1
              @rule_not_found = true
            end
            puts "POLICY NUMBER =  #{i}"
            policy_path = general_path + " .policy-type-container:nth-of-type(#{i}) div"
            expect(@ui.css(policy_path)).to be_present
            rule_count = @ui.css(policy_path + " .policy-head .policy-head-right .policy-rule-count")
            if rule_count.exists? and rule_count.text != "0 Rules"
              @browser.execute_script('$("#suggestion_box").hide()')
              expand_path = policy_path + " .policy-toggle-icon.xcp-icon-triangle"
              expect(@ui.css(expand_path)).to be_present
              @ui.css(expand_path).click
              sleep 0.5
                if @ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(1)').visible?
                  puts "layer 1 visible"
                  layers = 1
                  control = 0
                end
                if @ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(2)').visible?
                  puts "layer 2 visible"
                  layers = 2
                  control = 0
                  if !@ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(1)').visible?
                    puts "layer 1 not visible"
                    control = 2
                  end
                end
                if @ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(3)').visible?
                  puts "layer 3 visible"
                  layers = 3
                  control = 0
                  if !@ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(2)').visible?
                    puts "layer 1 not visible"
                    control = 2
                  elsif !@ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(1)').visible?
                    puts "layer 2 not visible"
                    control = 3
                  end
                end
              while layers >= control
                puts "**** #{layers} layers present"
                if @ui.css(policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(#{layers}) ul:nth-of-type(2)").exists?
                    puts "webtitan exits !!!"
                    body_path = policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(#{layers}) ul:nth-of-type(2)"
                else
                    body_path = policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(#{layers}) ul"
                end

                rules2 = @ui.get(:elements , {css: body_path})
                rules2.each_with_index { |rr, index|
                  @index = index
                }
                if webtitan == true and layers == 2
                  @index = 3
                  body_path = policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(2) .webtitan-rules-container"
                end
                puts "index = #{@index}"
                while @index > 0
                  puts "#{@index} - row"
                  case rule_type
                    when "firewall"
                      max_value = 11
                    when "application"
                      max_value = 9
                  end
                  if webtitan == true
                    max_value = 10
                  end
                  (2..max_value).each do |o|
                    if @ui.css(body_path + " li:nth-child(#{@index}) a:nth-child(3)").text == rule_name
                      if o == max_value
                        @rule_not_found = false
                        puts "AM GASIT REGULA !!!"
                        puts max_value
                        elipsis_control = body_path + " li:nth-child(#{@index}) span:nth-child(#{max_value})"
                        expect(@ui.css(elipsis_control)).to exist
                        @ui.css(elipsis_control + " i").click
                        sleep 2
                        expect(@ui.css(elipsis_control + " ul").lis.length).to eq(3)
                        expect(@ui.css(elipsis_control + " ul li:first-child")).to be_present
                        expect(@ui.css(elipsis_control + " ul li:first-child").attribute_value("class")).to eq("xcp-icon-schedule")
                        expect(@ui.css(elipsis_control + " ul li:nth-child(2)").attribute_value("class")).to eq("xcp-icon-trash")
                        expect(@ui.css(elipsis_control + " ul li:nth-child(3)").attribute_value("class")).to eq("xcp-icon-expand")
                        sleep 1
                        @ui.css(elipsis_control + " ul li:first-child").click
                        sleep 0.3
                        if rule_layer == "2"
                          expect(@ui.css('.dialogOverlay.temperror')).to be_present
                          expect(@ui.css('.dialogOverlay.temperror .title span').text).to eq("Cannot Schedule Rule")
                          expect(@ui.css('.dialogOverlay.temperror .msgbody div').text).to eq("Policy rules that use Layer 2 cannot be scheduled.")
                        else
                          schedule_policy_days_checker_certain(schedule_days, from_time, to_time, all_day_check)
                          sleep 1
                          @ui.click('#scheduleModalSubmit')
                          sleep 1

                          if rule_type == "firewall"
                            sched = 10
                          elsif rule_type == "application"
                            sched = 8
                          end
                          if all_day_check == true
                            expect(@ui.css(body_path + " li:nth-child(#{@index}) span:nth-child(#{sched})").text).to eq(schedule_days + " - All Day")
                          else
                            expect(@ui.css(body_path + " li:nth-child(#{@index}) span:nth-child(#{sched})").text).to eq(schedule_days + " - " + from_time + " - " + to_time)
                          end
                        end
                      end
                    end
                  end
                  @index -= 1
                end
                layers -= 1
              end
            end
          end
        if @rule_not_found == true
          expect(@rule_not_found).to eq(false)
        end
      sleep 1
      # @ui.click("#profile_config_save_btn")
      press_profile_save_config_no_schedule
    end
  end
end

shared_examples "create schedule for all policy types" do |policy_type, policy_name, policy_device_class, schedule_days, schedule_from, schedule_to, all_day_check|
  describe "Create schedule for all policy types available" do
    it "Ensure you are on the policies tab" do
    # @ui.goto_profile profile_name
     if !@browser.url.include?('/config/policies')
       @ui.click('#profile_config_tab_policies')
       sleep 2
       expect(@browser.url).to include('/config/policies')
     end
     sleep 0.5
     @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Create the policy '#{policy_name}' of type '#{policy_type}'" do
      policies_container = "#profile_config_policies .policies-container"
      (1..5).each do |i|
        expect(@ui.css(policies_container + " .policy-type-container:nth-of-type(#{i})")).to be_present
      end
      case policy_type
        when "SSID Policy"
          i = 2
        when "Personal SSID Policy"
          i = 3
        when "User Group Policy"
          i = 4
        when "Device Policy"
          i = 5
      end
      policy_container = policies_container + " .policy-type-container:nth-of-type(#{i}) .policy.greybox .policy-head"
      if policy_type == "Global Policy"
        expect(@ui.css(policy_container + " .policy-new-icon")).not_to be_visible
      else
        expect(@ui.css(policy_container + " .policy-new-icon")).to be_visible
        @ui.click(policy_container + " .policy-new-icon")
        sleep 0.5
        if policy_type != "Personal SSID Policy"
          expect(@ui.css('#new_policy_modal')).to be_present
          sleep 0.5
          case policy_type
            when "SSID Policy"
              @ui.set_dropdown_entry("new_policy_ssids_select", policy_name)
            when "User Group Policy"
              @ui.set_input_val("#new_policy_usergroup", policy_name)
              sleep 0.5
              @browser.execute_script('$("#ko_dropdownlist_overlay").hide()')
              @ui.set_input_val("#new_policy_usergroup_radius input", policy_name)
            when "Device Policy"
              @ui.set_input_val("#new_policy_device_name", policy_name)
              sleep 0.5
              @ui.set_dropdown_entry("new_policy_device_class", policy_device_class)
          end
          sleep 0.5
          @ui.click("#new_policy_submit")
          sleep 0.5
          #@browser.execute_script('$("#ko_dropdownlist_overlay").show()')
        end
      end
    end
    it "Create a schedule for the day period '#{schedule_days}' and time period: '#{schedule_from}' to '#{schedule_to}'" do
      case policy_type
        when "SSID Policy"
          i = 2
        when "Personal SSID Policy"
          i = 3
        when "User Group Policy"
          i = 4
        when "Device Policy"
          i = 5
      end
      policy_body = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{i}) .policy.greybox .policy-head"
      @ui.click(policy_body + " .policy-head-right .policy-menu-container .xcp-icon-menu")
      sleep 0.5
      expect(@ui.css(policy_body + " .policy-head-right .policy-menu-container .xc-dropdown-menu")).to be_visible
      if policy_type != "Personal SSID Policy"
        expect(@ui.css(policy_body + " .policy-head-right .policy-menu-container .xc-dropdown-menu .xcp-icon-edit")).to be_visible
        expect(@ui.css(policy_body + " .policy-head-right .policy-menu-container .xc-dropdown-menu .xcp-icon-schedule")).to be_visible
        expect(@ui.css(policy_body + " .policy-head-right .policy-menu-container .xc-dropdown-menu .xcp-icon-trash")).to be_visible
        sleep 0.5
        @ui.click(policy_body + " .policy-head-right .policy-menu-container .xc-dropdown-menu .xcp-icon-schedule")
        sleep 0.5
        schedule_policy_days_checker_certain(schedule_days, schedule_from, schedule_to, all_day_check)
        sleep 0.5
        @ui.click('#scheduleModalSubmit')
      else
        expect(@ui.css(policy_body + " .policy-head-right .policy-menu-container .xc-dropdown-menu .xcp-icon-edit")).not_to be_visible
        expect(@ui.css(policy_body + " .policy-head-right .policy-menu-container .xc-dropdown-menu .xcp-icon-schedule")).not_to be_visible
        expect(@ui.css(policy_body + " .policy-head-right .policy-menu-container .xc-dropdown-menu .xcp-icon-trash")).to be_visible
      end
    end
    it "Verify that the policy named '#{policy_name}' of type '#{policy_type}' display the proper schedule information ('#{schedule_days}' , '#{schedule_from}' and '#{schedule_to}')" do
      verify_policy_schedule(policy_type, schedule_days, schedule_from, schedule_to, all_day_check)
    end
    it "Press the <SAVE ALL> button and reverify the policy properly displays the schedule information" do
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 1
      verify_policy_schedule(policy_type, schedule_days, schedule_from, schedule_to, all_day_check)
    end
  end
end


shared_examples "quick add and delete application rule for policy" do |rule_name, enable, action, category_input, application_input|
  describe "Quickly add, verify then delete an application rule for the global policy" do
    it "Create then verify that the rule has proper values: '#{rule_name}' - '#{enable} (enabled)' - '#{category_input} (category)' - '#{application_input} (application)'" do
      policy_head = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy.greybox .policy-head"
      if @ui.css("#ko_dropdownlist_overlay").visible?
        @browser.refresh
      end
      if !@ui.css(policy_head + " .policy-head-right .policy-rule-count").visible?
        expect(@ui.css(policy_head + " .policy-new-icon")).to be_visible
        @ui.click(policy_head + " .policy-new-icon")
        sleep 0.5
        if policy_type != "Personal SSID Policy"
          expect(@ui.css('#new_policy_modal')).to be_present
          sleep 0.5
          case policy_type
            when "SSID Policy"
              @ui.set_dropdown_entry("new_policy_ssids_select", policy_name)
            when "User Group Policy"
              @ui.set_input_val("#new_policy_usergroup", policy_name)
              sleep 0.5
              @browser.execute_script('$("#ko_dropdownlist_overlay").hide()')
              @ui.set_input_val("#new_policy_usergroup_radius input", policy_name)
            when "Device Policy"
              @ui.set_input_val("#new_policy_device_name", policy_name)
              sleep 0.5
              @ui.set_dropdown_entry("new_policy_device_class", policy_device_class)
          end
          sleep 0.5
          @ui.click("#new_policy_submit")
          sleep 0.5
          #@browser.execute_script('$("#ko_dropdownlist_overlay").show()')
        end
      end
      add_rule_button = policy_head + " .policy-head-right button"
      @ui.click(add_rule_button)
      sleep 0.5
      expect(@ui.css('#new_rule_modal')).to be_present
      rule_type_application = "#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types .rule-type:nth-of-type(3) label .xcp-icon-application"
      @ui.click(rule_type_application)
      rule_configuration_container = "#new_rule_modal .rule-configuration"
      @ui.click(rule_configuration_container + " #rule_autoname label")
      @ui.set_input_val(rule_configuration_container + " #rule_name", rule_name)
      if enable != true
        @ui.click("#rule_enable .switch_label")
      end
      if action == "allow"
        @ui.click("#rule_action .switch_label")
      end
      # Comment out old implementation and use new one
      #@ui.set_dropdown_entry("rule_application", category_input)
      #@ui.set_dropdown_entry("rule_application_option", application_input)
      @ui.set_dropdown_entry("app-search", application_input)
      @ui.click("#policy-rule-submit")
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(false)
      sleep 3
      if !@ui.css(policy_head + ' .policy-toggle-icon').attribute_value("class").include?("active")
        @ui.click(policy_head + ' .policy-toggle-icon')
        sleep 1
      end
      policy_body = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy.greybox .policy-body"
      layer_7 = policy_body + " .policy-rule-layer-container:nth-of-type(3) .policy-rules-container"
      rule_path = layer_7 + " .policy-rule:nth-of-type(1)"

      verify_hash = Hash[2 => "policy-rule-icon xcp-icon-application", 3 => rule_name, 4 => "Layer: 7", 5 => "Category: " + category_input, 6 => "Application: " + application_input, 7 => "Allow/Block: " + action.upcase, 8 => enable, 9 => "policy-rule-menu-btn xcp-icon-menu"]
      max_value = 9

      (2..max_value).each do |o|
        if @ui.css(rule_path + " a:nth-child(3)").text == rule_name
          @rule_not_found = false
          puts "AM GASIT REGULA !!!"
          if o == 2
            disabled_icon = ""
            if enable == false
              disabled_icon = " disabled"
            end
            expect(@ui.css(rule_path + " i:nth-child(#{o})").attribute_value("class")).to eq(verify_hash[o] + disabled_icon)
          elsif o == 3
            expect(@ui.css(rule_path + " a:nth-child(#{o})").text).to eq(verify_hash[o])
          elsif o == 8
            expect(@ui.get(:checkbox , {css: rule_path + " span:nth-child(#{o}) input"}).set?).to eq(verify_hash[o])
          elsif o == 9
            expect(@ui.css(rule_path + " span:nth-child(#{o}) i").attribute_value("class")).to eq(verify_hash[o])
          else
            expect(@ui.css(rule_path + " span:nth-child(#{o})").text).to eq(verify_hash[o])
          end
          if o == max_value
            puts "AM VERIFICAT TOT"
          end
        end
      end
      if @rule_not_found == true
        expect(@rule_not_found).to eq(false)
      end
      sleep 0.5
      @ui.click(rule_path + " span:nth-child(9) i")
      @ui.click(rule_path + " span:nth-child(9) ul .xcp-icon-trash")
      sleep 0.5
      @ui.click("#_jq_dlg_btn_1")
      sleep 0.5
      if @ui.css('#policy-collapse-all').present?
        @ui.click('#policy-collapse-all')
      end
    end
  end
end

shared_examples "verify appcon false can not create app control policies" do |use_x320|
  describe "Verify that a tenant that has 'appcon' set to 'false' can't create App Control policies" do
    it "Ensure you are on the policies tab" do
     if !@browser.url.include?('/config/policies')
      if @browser.url.include?("/#profiles/") and @browser.url.include?("/aps")
       @ui.click("#profile_tab_config")
       sleep 2
      end
       @ui.click('#profile_config_tab_policies')
     end
     sleep 2
     expect(@browser.url).to include('/config/policies')
     sleep 0.5
     @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Verify the accepted values for Device Policies 'class' and 'type' options" do
      @ui.click("#profile_config_policies .policies-container .policy-type-container:nth-of-type(5) .policy.greybox .policy-head .policy-new-icon.xcp-icon-device")
      sleep 0.5
      expect(@ui.css('#new_policy_modal')).to be_present
      expect(@ui.css('#new_policy_modal .title_wrap .commonTitle').text).to eq("New Device Policy")
      expect(@ui.css("#new_policy_device_name").attribute_value("type")).to eq("text")
      expect(@ui.css("#new_policy_device_name").attribute_value("maxlength")).to eq("20")
      expect(@ui.css("#new_policy_device_class .ko_dropdownlist_button .text.ddlCaption").attribute_value("title")).to eq("Choose device class...")
      sleep 0.5
      @ui.click("#new_policy_device_class .ko_dropdownlist_button .arrow")
      sleep 0.5
      verify_device_policy_modal_features(use_x320)
      sleep 0.5
      @ui.click("#new_policy_modal_closemodalbtn")
      sleep 1.5
      expect(@ui.css('#new_policy_modal')).not_to be_present
    end
    it "Verify the user can't create 'App Control' policies for any policy type" do
      verify_app_control_policies(use_x320)
    end
    it "Exit the profile without saving the changes" do
      @ui.click("#profile_tab_arrays")
      sleep 1.5
      @ui.click("#_jq_dlg_btn_0")
    end
  end
end

def verify_device_policy_modal_features(used_x320)
  device_class_elments_verify = Hash[1 => "Access Point", 2 => "Appliance", 3 => "Car", 4 => "Desktop", 5 => "Game", 6 => "Notebook", 7 => "Phone", 8 => "Player", 9 => "Tablet", 10 => "Watch"]
  all_device_class_elements = @ui.get(:elements, {css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul li"})
  all_device_class_elements.each_with_index do |device_class_element, index|
    if index != 0
      expect(device_class_element.attribute_value("data-value")).to eq(device_class_elments_verify[index])
    end
    if index == all_device_class_elements.length - 1
      device_class_element.click
    end
  end

  if used_x320 == false
    device_type_appliance_verify = Hash[1 => "All Appliance Types", 2 => "Thermostat"]
    device_type_game_verify = Hash[1 => "All Game Types", 2 => "Nintendo", 3 => "PlayStation", 4 => "Wii", 5 => "Xbox"]
    device_type_nootbook_verify = Hash[1 => "All Notebook Types", 2 => "Mac", 3 => "Windows", 4 => "Linux", 5 => "ChromeOS"]
    device_type_phone_verify = Hash[1 => "All Phone Types", 2 => "Android", 3 => "BlackBerry", 4 => "Danger", 5 => "DoCoMo", 6 => "Ericsson", 7 => "iPhone", 8 => "KDDI", 9 => "PalmOS", 10 => "Samsung", 11 => "Symbian", 12 => "Vodafone", 13 => "WebOS", 14 => "Win Mobile"]
    device_type_player_verify = Hash[1 => "All Player Types", 2 => "AppleTV", 3 => "DirecTV", 4 => "GoogleTV", 5 => "iPod"]
    device_type_tablet_verify = Hash[1 => "All Tablet Types", 2 => "Android", 3 => "Archos", 4 => "BlackBerry", 5 => "iPad", 6 => "Kindle", 7 => "Nokia", 8 => "WebOS", 9 => "Windows"]

    sleep 1
    @ui.click("#new_policy_device_class .ko_dropdownlist_button .arrow")
    sleep 0.5
    all_device_class_elements.each_with_index do |device_class_element, index|
      if index != 0
        puts index
        if index != 1
          @ui.click("#new_policy_device_class .ko_dropdownlist_button .arrow")
          sleep 0.5
        end
        if device_class_element.attribute_value("data-value") == device_class_elments_verify[index]
          device_class_element.click
          sleep 0.5
          expect(@ui.css("#new_policy_device_type")).to be_present
          sleep 0.5
          @ui.click("#new_policy_device_type .ko_dropdownlist_button .arrow")
          all_device_type_elements = @ui.get(:elements, {css: ".ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul li"})
          all_device_type_elements.each_with_index do |device_type_element, index2|
            a = index2 + 1
            case index
              when 1
                expect(device_type_element.attribute_value("data-value")).to eq("All Access Point Types")
              when 2
                expect(device_type_element.attribute_value("data-value")).to eq(device_type_appliance_verify[a])
              when 3
                expect(device_type_element.attribute_value("data-value")).to eq("All Car Types")
              when 4
                expect(device_type_element.attribute_value("data-value")).to eq("All Desktop Types")
              when 5
                expect(device_type_element.attribute_value("data-value")).to eq(device_type_game_verify[a])
              when 6
                expect(device_type_element.attribute_value("data-value")).to eq(device_type_nootbook_verify[a])
              when 7
                expect(device_type_element.attribute_value("data-value")).to eq(device_type_phone_verify[a])
              when 8
                expect(device_type_element.attribute_value("data-value")).to eq(device_type_player_verify[a])
              when 9
                expect(device_type_element.attribute_value("data-value")).to eq(device_type_tablet_verify[a])
              when 10
                expect(device_type_element.attribute_value("data-value")).to eq("All Watch Types")
            end
            sleep 0.5
            if a == all_device_type_elements.length
              device_type_element.click
            end
          end
        end
      end
    end
  else
    sleep 1
    @ui.click("#new_policy_device_class .ko_dropdownlist_button .arrow")
    sleep 0.5
    all_device_class_elements.each_with_index do |device_class_element, index|
      if index != 0
        puts index
        if index != 1
          @ui.click("#new_policy_device_class .ko_dropdownlist_button .arrow")
          sleep 0.5
        end
        if device_class_element.attribute_value("data-value") == device_class_elments_verify[index]
          device_class_element.click
          sleep 0.5
          expect(@ui.css("#new_policy_device_type")).not_to be_present
        end
      end
    end
  end
end

def verify_app_control_policies(use_x320)
  (1..5).each do |row|
    path = "#profile_config_policies .policies-container .policy-type-container:nth-of-type(#{row}) .policy.greybox .policy-head"
    @browser.execute_script('$("#suggestion_box").hide()')
    case row
      when 2
        create_new_policy_type(path, "SSID Policy", "ssid", "SSID", "", "", use_x320, nil)
      when 3
        create_new_policy_type(path, "Personal SSID Policy", "personal", "", "", "", use_x320, nil)
      when 4
        create_new_policy_type(path, "User Group Policy", "user-group", "UG", "", "", use_x320, nil)
      when 5
        create_new_policy_type(path, "Device Policy", "device", "Access Point", "Access Point", "All Access Point Types", use_x320, nil)
    end
    sleep 0.5
    if row != 1
      policy_context_menu_items_verify = Hash[1 => "xcp-icon-edit", 2 => "xcp-icon-schedule", 3 => "xcp-icon-trash"]
      @ui.click(path + " .policy-head-right .policy-menu-container .policy-menu-btn")
      sleep 0.5
      expect(@ui.css(path + " .policy-head-right .policy-menu-container .policy-menu.xc-dropdown-menu")).to be_present
      context_menu_items = @ui.get(:elements, {css: path + " .policy-head-right .policy-menu-container .policy-menu.xc-dropdown-menu li"})
      context_menu_items.each_with_index do |context_menu_item, index|
        a = index + 1
          expect(context_menu_item.attribute_value("class")).to eq(policy_context_menu_items_verify[a])
          if use_x320 != true
            if row != 3
              expect(context_menu_item).to be_present
            else
              if a == 3
                expect(context_menu_item).to be_present
              end
            end
          else
            if row != 3
              if a == 1 or a == 3
                expect(context_menu_item).to be_present
              end
            else
              if a == 3
                expect(context_menu_item).to be_present
              end
            end
          end
        #end
      end
      sleep 0.5
    end
    @ui.click(path + " .policy-head-right button")
    sleep 0.5
    expect(@ui.css('#new_rule_modal')).to be_present
    sleep 0.5
    if row == 1
      expect(@ui.get(:elements, {css: '#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types .rule-type'}).length).to eq(2)
      expect(@ui.css('#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types .rule-type:nth-child(1) label input').attribute_value("value")).to eq("firewall")
      expect(@ui.css('#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types .rule-type:nth-child(2) label input').attribute_value("value")).to eq("aircleaner")
    else
      expect(@ui.get(:elements, {css: '#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types .rule-type'}).length).to eq(1)
      expect(@ui.css('#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types .rule-type:nth-child(1) label input').attribute_value("value")).to eq("firewall")
    end
    sleep 0.5
    @ui.click('#policy-rule-cancel')
  end
end

shared_examples "delete aircleaner rules all" do |profile_name, added_rules, how_many_aicleaner_rules|
  describe "Delete all the AirCleaner rules using the special delete button" do
    it "Ensure you are on the policies tab" do
     #@ui.goto_profile profile_name
    # sleep 3
     if !@browser.url.include?('/config/policies')
      if @browser.url.include?("/#profiles/") and @browser.url.include?("/aps")
       @ui.click("#profile_tab_config")
       sleep 2
      end
       @ui.click('#profile_config_tab_policies')
     end
     sleep 2
     expect(@browser.url).to include('/config/policies')
     sleep 0.5
     @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Open the 'Global Policy' container and verify the added rule number as '#{added_rules}'" do
      path = '#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy:nth-of-type(1)'
      while !@ui.css(path + ' .policy-head .policy-toggle-icon').attribute_value("class").include? "active"
        @ui.click(path + ' .policy-head .policy-toggle-icon')
        sleep 2
      end
      expect(@ui.css(path + ' .policy-body .policy-rule-layer-container:nth-of-type(1)')).to be_visible
      sleep 1
      policies_length = @ui.get(:elements , {css: path + ' .policy-body .policy-rule-layer-container:nth-of-type(1) .policy-rules-container .policy-rule'}).length
      expect(policies_length).to eq(added_rules)
    end
    it "Verify that the 'Clear all Air Cleaner rules' link exists and is visible" do
      path = '#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy:nth-of-type(1) .policy-body .policy-rule-layer-container:nth-of-type(1)'
      expect(@ui.css(path + ' .fl_right')).to be_present
      expect(@ui.css(path + ' .fl_right').text).to eq("Clear all Air Cleaner rules")
    end
    it "Press the 'Clear all Air Cleaner rules' link" do
      @ui.click('#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy:nth-of-type(1) .policy-body .policy-rule-layer-container:nth-of-type(1) .fl_right')
    end
    it "Verify the confirmation prompt displays the proper information" do
      expect(@ui.css('.dialogOverlay.confirm .dialogBox .title span').text).to eq("Remove All Air Cleaners")
      expect(@ui.css('.dialogOverlay.confirm .dialogBox .msgbody div:nth-child(1)').text).to eq("Are you sure you want to remove all Air Cleaner rules?")
      expect(@ui.css('#_jq_dlg_btn_0')).to be_present
      expect(@ui.css('#_jq_dlg_btn_1')).to be_present
    end
    it "Click the 'Yes' button" do
      @ui.click('#_jq_dlg_btn_1')
    end
    it "Verify that the rule number now displays '#{added_rules-how_many_aicleaner_rules}'" do
      path = '#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy:nth-of-type(1)'
      policies_length = @ui.get(:elements , {css: path + ' .policy-body .policy-rule-layer-container:nth-of-type(1) .policy-rules-container .policy-rule'}).length
      expect(policies_length).to eq(added_rules-how_many_aicleaner_rules)
    end
    it "Save the profile" do
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
    end
    it "Verify that the rule number still displays '#{added_rules-how_many_aicleaner_rules}'" do
      path = '#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy:nth-of-type(1)'
      @ui.click(path + ' .policy-head .policy-toggle-icon')
      sleep 1
      policies_length = @ui.get(:elements , {css: path + ' .policy-body .policy-rule-layer-container:nth-of-type(1) .policy-rules-container .policy-rule'}).length
      expect(policies_length).to eq(added_rules-how_many_aicleaner_rules)
    end
  end
end

shared_examples "delete rule by name" do |rule_name, rule_type, webtitan|
  describe "Delete the rule named '#{rule_name}'" do
    it "Ensure you are on the policies tab" do
     if !@browser.url.include?('/config/policies')
      if @browser.url.include?("/#profiles/") and @browser.url.include?("/aps")
       @ui.click("#profile_tab_config")
       sleep 2
      end
       @ui.click('#profile_config_tab_policies')
     end
     sleep 2
     expect(@browser.url).to include('/config/policies')
     sleep 0.5
     @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Delete the rule named '#{rule_name}' of type '#{rule_type}'" do
      if @ui.css("#policy-collapse-all").visible?
        @ui.click("#policy-collapse-all")
        sleep 0.5
      end
      general_path = "#profile_config_policies .policies-container"
      containers_path = general_path + " .policy-type-container"
      expect(@ui.get(:elements , {css: containers_path }).length).to eq(5)
      (1..5).each do |i|
        if i == 1
          @rule_not_found = true
        end
        puts "POLICY NUMBER =  #{i}"
        policy_path = general_path + " .policy-type-container:nth-of-type(#{i}) div"
        expect(@ui.css(policy_path)).to be_present
        rule_count = @ui.css(policy_path + " .policy-head .policy-head-right .policy-rule-count")
        if rule_count.exists? and rule_count.text != "0 Rules"
          @browser.execute_script('$("#suggestion_box").hide()')
          expand_path = policy_path + " .policy-toggle-icon.xcp-icon-triangle"
          expect(@ui.css(expand_path)).to be_present
          @ui.css(expand_path).click
          sleep 0.5
            if @ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(1)').visible?
              puts "layer 1 visible"
              layers = 1
              control = 0
            end
            if @ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(2)').visible?
              puts "layer 2 visible"
              layers = 2
              control = 0
              if !@ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(1)').visible?
                puts "layer 1 not visible"
                control = 2
              end
            end
            if @ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(3)').visible?
              puts "layer 3 visible"
              layers = 3
              control = 0
              if !@ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(2)').visible?
                puts "layer 1 not visible"
                control = 2
              elsif !@ui.css(policy_path + ' .policy-body .policy-rule-layer-container:nth-of-type(1)').visible?
                puts "layer 2 not visible"
                control = 3
              end
            end
          while layers >= control
            puts "**** #{layers} layers present"
            if @ui.css(policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(#{layers}) ul:nth-of-type(2)").exists?
                puts "webtitan exits !!!"
                body_path = policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(#{layers}) ul:nth-of-type(2)"
            else
                body_path = policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(#{layers}) ul"
            end
            rules2 = @ui.get(:elements , {css: body_path})
            rules2.each_with_index { |rr, index|
              @index = index
            }
            if webtitan == true and layers == 2
              @index = 3
              body_path = policy_path + " .policy-body .policy-rule-layer-container:nth-of-type(2) .webtitan-rules-container"
            end
            puts "index = #{@index}"
            while @index > 0
              puts "#{@index} - row"
              case rule_type
                when "firewall"
                  max_value = 11
                when "application"
                  max_value = 9
              end
              if webtitan == true
                max_value = 10
              end
              (2..max_value).each do |o|
                if @ui.css(body_path + " li:nth-child(#{@index}) a:nth-child(3)").text == rule_name
                  if o == max_value
                    @rule_not_found = false
                    puts "AM GASIT REGULA !!!"
                    puts max_value
                    elipsis_control = body_path + " li:nth-child(#{@index}) span:nth-child(#{max_value})"
                    expect(@ui.css(elipsis_control)).to exist
                    @ui.css(elipsis_control + " i").click
                    sleep 2
                    expect(@ui.css(elipsis_control + " ul").lis.length).to eq(3)
                    expect(@ui.css(elipsis_control + " ul li:nth-child(2)").attribute_value("class")).to eq("xcp-icon-trash")
                    sleep 1
                    @ui.css(elipsis_control + " ul li:nth-child(2)").click
                    sleep 1
                    expect(@ui.css('.dialogOverlay .dialogBox .title span').text).to eq('Delete Rule')
                    sleep 1
                    @ui.click('#_jq_dlg_btn_1')
                    sleep 1
                  end
                end
              end
              @index -= 1
            end
            layers -= 1
          end
        end
      end
      if @rule_not_found == true
        expect(@rule_not_found).to eq(false)
      end
    end
    it "Save the profile" do
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
    end
  end
end

shared_examples "save the profile" do
  describe "Save the profile changes" do
    it "Press the 'SAVE ALL' button" do
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
    end
  end
end


shared_examples "set policy advanced settings" do |policy_type, default_qos, traffic_limit_on_ap, unit_meassure_1, traffic_per_client, unit_meassure_2, client_count, client_count_number, external_captive_portal_config, portal_type, external_url, redirect_secret, authentication_type, primary_host_ip, port, shared_secret, called_station_id, station_mac_format|
  describe "Set the policy advanced settings for the policy type '#{policy_type}'" do
    it "Ensure you are on the policies tab" do
     if !@browser.url.include?('/config/policies')
      if @browser.url.include?("/#profiles/") and @browser.url.include?("/aps")
       @ui.click("#profile_tab_config")
       sleep 2
      end
       @ui.click('#profile_config_tab_policies')
     end
     sleep 2
     expect(@browser.url).to include('/config/policies')
     sleep 0.5
     @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Open the advanced container to expose the appropriate controls and set the advanced values" do
      case policy_type
        when "Global Policy"
          container_no = 1
        when "SSID Policy"
          container_no = 2
        when "Personal SSID Policy"
          container_no = 3
        when "User Group Policy"
          container_no = 4
        when "Device Policy"
          container_no = 5
      end
      path = ".policies-container .policy-type-container:nth-child(#{container_no}) .policy .policy-body"
      @ui.click(path + " .v-center .policy-show-advanced")
      sleep 1
      expect(@ui.css(path + " .policiesAdvanced")).to be_present
      path = path + " .policiesAdvanced"
      sleep 0.5
      if default_qos != ""
        @ui.set_input_val(path + " .defaultQosInput", default_qos)
        sleep 0.5
      end
      if traffic_limit_on_ap != ""
        @ui.set_input_val(path + " .trafficPerArrayInput", traffic_limit_on_ap)
        sleep 0.5
        @ui.set_dropdown_entry_by_path(path + " .trafficPerArraySelect", unit_meassure_1)
        sleep 0.5
      end
      if traffic_per_client != ""
        @ui.set_input_val(path + " .trafficPerStationInput", traffic_per_client)
        sleep 0.5
        @ui.set_dropdown_entry_by_path(path + " .trafficPerStationSelect", unit_meassure_2)
        sleep 0.5
      end
      if client_count != false
        @ui.click(path + " .stationCountUnlimitedSwitch .switch_label .right")
        sleep 0.5
        @ui.set_input_val(path + " .stationCountLimitInput", client_count_number)
        sleep 0.5
      end
      if external_captive_portal_config != false
        @ui.click('#externalCaptivePortalBtn')
        sleep 1
        expect(@ui.css('#ssid_captiveportal_modal')).to be_present
        if portal_type == "Basic Login Page"
          @ui.click(".type.CaptivePortalType_LOGIN")
        elsif portal_type == "Splash Page"
          @ui.click(".type.CaptivePortalType_SPLASH")
        end
        sleep 0.5
        @ui.click('#ssid_modal_captiveportal_btn_next')
        sleep 0.5
        if portal_type == "Splash Page"
          path = "#ssid_captiveportal_modal .content .config div:nth-child(3) "
          @ui.set_input_val(path + "#landingpage1", external_url)
          sleep 0.5
          @ui.set_input_val(path + "#externalsplash_redirect", redirect_secret)
          sleep 0.5
          @ui.set_input_val(path + "#externalsplash_confirmredirect", redirect_secret)
          sleep 0.5
        elsif portal_type == "Basic Login Page"
          path = "#ssid_captiveportal_modal .content .config div:nth-child(5) "
          @ui.set_input_val(path + "#landingpage2", external_url)
          sleep 0.5
          @ui.set_input_val(path + "#externallogin_redirect", redirect_secret)
          sleep 0.5
          @ui.set_input_val(path + "#externallogin_confirmredirect", redirect_secret)
          sleep 0.5
          @ui.set_dropdown_entry_by_path(path + "#captiveportal_authtype", authentication_type)
          sleep 0.5
          @ui.set_input_val(path + "#captiveportal_radius_ip2", primary_host_ip)
          sleep 0.5
          @ui.set_input_val(path + "#captiveportal_radius_port2", port)
          sleep 0.5
          @ui.set_input_val(path + "#captiveportal_radius_secret2", shared_secret)
          sleep 0.5
          @ui.set_input_val(path + "#captiveportal_radius_confirmsecret2", shared_secret)
          sleep 0.5
          @ui.set_dropdown_entry_by_path(path + "#captiveportal-calledStaIdFormat", called_station_id)
          sleep 0.5
          @ui.set_dropdown_entry_by_path(path + "#captiveportal-staMacFormat", station_mac_format)
          sleep 0.5
        end
        @ui.click("#ssid_modal_captiveportal_btn_save")
      end
    end
    it "Save the profile and verify the values" do
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 2
      case policy_type
        when "Global Policy"
          container_no = 1
        when "SSID Policy"
          container_no = 2
        when "Personal SSID Policy"
          container_no = 3
        when "User Group Policy"
          container_no = 4
        when "Device Policy"
          container_no = 5
      end
      path = ".policies-container .policy-type-container:nth-child(#{container_no}) .policy .policy-body"
      @ui.click(path + " .v-center .policy-show-advanced")
      sleep 1
      expect(@ui.css(path + " .policiesAdvanced")).to be_present
      path = path + " .policiesAdvanced"
      sleep 0.5
      if default_qos != ""
        expect(@ui.css(path + " .defaultQosInput").value).to eq(default_qos)
      end
      if traffic_limit_on_ap != ""
        expect(@ui.css(path + " .trafficPerArrayInput").value).to eq(traffic_limit_on_ap)
      end
      if traffic_per_client != ""
        expect(@ui.css(path + " .trafficPerStationInput").value).to eq(traffic_per_client)
      end
      if client_count != false
        expect(@ui.css(path + " .stationCountLimitInput").value).to eq(client_count_number)
      end
      if external_captive_portal_config != false
        if portal_type == "Basic Login Page"
          expect(@ui.css("#externalCaptivePortalVal").text).to eq("Basic Login Page")
        elsif portal_type == "Splash Page"
          expect(@ui.css("#externalCaptivePortalVal").text).to eq("Splash Page")
        end
      end
    end
  end
end


shared_examples "configure and verify policy advanced settings" do |advance_config|
  describe "configure the policy advanced settings for the policy type '#{advance_config[:policy_type]}'" do
    it "Ensure you are on the policies tab" do
     if !@browser.url.include?('/config/policies')
      if @browser.url.include?("/#profiles/") and @browser.url.include?("/aps")
       @ui.click("#profile_tab_config")
       sleep 2
      end
       @ui.click('#profile_config_tab_policies')
     end
     sleep 2
     expect(@browser.url).to include('/config/policies')
     sleep 0.5
     @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Open the advanced container to expose the appropriate controls and set the advanced values" do
      case advance_config[:policy_type]
        when "Global Policy"
          container_no = 1
        when "SSID Policy"
          container_no = 2
        when "Personal SSID Policy"
          container_no = 3
        when "User Group Policy"
          container_no = 4
        when "Device Policy"
          container_no = 5
      end
      path = ".policies-container .policy-type-container:nth-child(#{container_no}) .policy .policy-body"
      @ui.click(path + " .v-center .policy-show-advanced")
      sleep 1
      expect(@ui.css(path + " .policiesAdvanced")).to be_present
      path = path + " .policiesAdvanced"
      sleep 0.5
      if advance_config[:default_Qos] != ""
        @ui.set_input_val(path + " .defaultQosInput", advance_config[:default_Qos])
        sleep 0.5
      end
      if advance_config[:traffic_per_ap] != ""
        @ui.set_input_val(path + " .trafficPerArrayInput", advance_config[:traffic_per_ap])
        sleep 0.5
        @ui.set_dropdown_entry_by_path(path + " .trafficPerArraySelect", advance_config[:traffic_per_ap_unit])
        sleep 0.5
      end
      if advance_config[:traffic_per_client] != ""
        @ui.set_input_val(path + " .trafficPerStationInput", advance_config[:traffic_per_client])
        sleep 0.5
        @ui.set_dropdown_entry_by_path(path + " .trafficPerStationSelect", advance_config[:traffic_per_client_unit])
        sleep 0.5
      end
      if advance_config[:client_count_limit] != "Unlimited"
        @ui.click(path + " .stationCountUnlimitedSwitch .switch_label .right")
        sleep 0.5
        @ui.set_input_val(path + " .stationCountLimitInput", advance_config[:client_count])
        sleep 0.5
      end
      if advance_config[:content_filter] != ""
        @ui.click(path + " .webTitanSwitch .switch_label .left")
        sleep 0.5
      end
      if advance_config[:station_traffic] != ""
        @ui.click(path + " .blockStationToStationSwitch .switch_label .left")
        sleep 0.5
      end
    end
    it "Save the profile and verify the values" do
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 2
      case advance_config[:policy_type]
        when "Global Policy"
          container_no = 1
        when "SSID Policy"
          container_no = 2
        when "Personal SSID Policy"
          container_no = 3
        when "User Group Policy"
          container_no = 4
        when "Device Policy"
          container_no = 5
      end
      path = ".policies-container .policy-type-container:nth-child(#{container_no}) .policy .policy-body"
      @ui.click(path + " .v-center .policy-show-advanced")
      sleep 1
      expect(@ui.css(path + " .policiesAdvanced")).to be_present
      path = path + " .policiesAdvanced"
      sleep 0.5
      if advance_config[:default_Qos] != ""
        expect(@ui.get(:input, {css: path + " .defaultQosInput"}).value).to eq(advance_config[:default_Qos])
      end
      if advance_config[:traffic_per_ap] != ""
        expect(@ui.get(:input, {css: path + " .trafficPerArrayInput"}).value).to eq(advance_config[:traffic_per_ap])
      end
      if advance_config[:traffic_per_client] != ""
        expect(@ui.get(:input, {css: path + " .trafficPerStationInput"}).value).to eq(advance_config[:traffic_per_client])
      end
      if advance_config[:client_count_limit] != "Unlimited"
        expect(@ui.get(:input, {css: path + " .stationCountLimitInput"}).value).to eq(advance_config[:client_count])
      end
     if advance_config[:content_filter] != ""
      if @ui.get(:checkbox, {css: path + " #policies-webTitanChk-0"}).set?
        expect("Off").to eq(advance_config[:client_count])
       else
         expect("On").to eq(advance_config[:client_count])
       end
      end      
     if advance_config[:station_traffic] != ""
          if @ui.get(:checkbox, {css: path +" .blockStationToStationSwitch .switch_checkbox"}).set?
            expect("Block").to eq(advance_config[:station_traffic])
          else
             expect("Allow").to eq(advance_config[:station_traffic])
          end
       end
    end
  end
end


shared_examples "delete ug policy external captive portal" do |portal_type|
  describe "Delete the External Captive Portal from a certain User Group Policy" do
    it "Ensure you are on the policies tab" do
       if !@browser.url.include?('/config/policies')
        if @browser.url.include?("/#profiles/") and @browser.url.include?("/aps")
         @ui.click("#profile_tab_config")
         sleep 2
        end
         @ui.click('#profile_config_tab_policies')
       end
       sleep 2
       expect(@browser.url).to include('/config/policies')
       sleep 0.5
       @browser.execute_script('$("#suggestion_box").hide()')
       # @ui.click('#profile_config_save_btn')
       press_profile_save_config_no_schedule
       sleep 3
    end
    it "Open the advanced container to expose the appropriate controls and verify the value of the External Captive Portal" do
      if @ui.css("#externalCaptivePortalBtn").visible? != true
        @ui.click(".policies-container .policy-type-container:nth-child(4) .policy .policy-body .v-center .policy-show-advanced")
      end
      sleep 1
      if portal_type == "Basic Login Page"
        expect(@ui.css("#externalCaptivePortalVal").text).to eq("Basic Login Page")
      elsif portal_type == "Splash Page"
        expect(@ui.css("#externalCaptivePortalVal").text).to eq("Splash Page")
      end
    end
    it "Delete the External Captive Portal" do
      @ui.click("#externalCaptivePortalRemoveBtn")
      sleep 1
      @ui.click("#_jq_dlg_btn_1")
      sleep 0.5
    end
    it "Save the profile and verify that the External Captive Portal isn't displayed anymore" do
      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 2
      if @ui.css("#externalCaptivePortalBtn").visible? != true
        @ui.click(".policies-container .policy-type-container:nth-child(4) .policy .policy-body .v-center .policy-show-advanced")
      end
      sleep 1
      expect(@ui.css("#externalCaptivePortalVal")).not_to exist
    end
  end
end

def action_on_content_filtering_switch(status)
  path = ".policies-container .policy-type-container:nth-child(2) .policy .policy-body .policiesAdvanced .policiesRuleAdvanced "
  if @ui.get(:checkbox , {css: path + ".webTitanSwitch input"}).set? != status
    @ui.click(path + ".webTitanSwitch .switch_label")
    sleep 1
    # @ui.click('#profile_config_save_btn')
    press_profile_save_config_no_schedule
    sleep 3
    path = ".policies-container .policy-type-container:nth-child(2) .policy .policy-body "
    expect(@ui.css(path + ".v-center .policy-show-advanced")).to exist
    @ui.click(path + ".v-center .policy-show-advanced")
    sleep 1
    expect(@ui.css(path + ".policiesAdvanced").attribute_value("style")).to eq("")
  end
  path = ".policies-container .policy-type-container:nth-child(2) .policy .policy-body .policiesAdvanced .policiesRuleAdvanced "
  expect(@ui.get(:checkbox , {css: path + ".webTitanSwitch input"}).set?).to eq(status)
end

shared_examples "verify ssid policy content filtering" do |status, action|
  describe "Verify the SSID Policy Content Filtering feature" do
    it "Ensure you are on the policies tab" do
       if !@browser.url.include?('/config/policies')
        if @browser.url.include?("/#profiles/") and @browser.url.include?("/aps")
         @ui.click("#profile_tab_config")
         sleep 2
        end
         @ui.click('#profile_config_tab_policies')
       end
       sleep 2
       expect(@browser.url).to include('/config/policies')
       sleep 0.5
       @browser.execute_script('$("#suggestion_box").hide()')
       # @ui.click('#profile_config_save_btn')
       press_profile_save_config_no_schedule
       sleep 3
    end
    it "Open the 'Show Advaced' container for the 'SSID Policy'" do
      path = ".policies-container .policy-type-container:nth-child(2) .policy .policy-body "
      expect(@ui.css(path + ".v-center .policy-show-advanced")).to exist
      if @ui.css(path + '.policiesAdvanced').attribute_value("style") != ""
        @ui.click(path + ".v-center .policy-show-advanced")
        sleep 1
      end
      expect(@ui.css(path + '.policiesAdvanced').attribute_value("style")).to eq("")
    end
    it "Verify the 'Content Filtering' " do
      path = ".policies-container .policy-type-container:nth-child(2) .policy .policy-body .policiesAdvanced .policiesRuleAdvanced "
      expect(@ui.css(path + ".webTitanField .webTitanLabel").text).to eq("Content Filtering:")
      expect(@ui.css(path + ".webTitanField .webTitanSwitch")).to be_visible
      #expect(@ui.css(path + ".webTitanField .icon.asteriskIcon")).to be_visible
      if status == "disabled"
        #expect(@ui.css(path + ".webTitanField .webTitanLabel.disabled")).to be_visible
        expect(@ui.get(:input , {css: path + ".webTitanField .webTitanSwitch input"}).disabled?).to eq(true)
        sleep 0.5
        @ui.css(path + ".webTitanField .webTitanSwitch").hover
        sleep 1
        expect(@ui.css('.ko_tooltip_content_template .ko_tooltip_content').text).to eq("Content Filtering must be configured in the Add-on Solutions page to be enabled.")
        #expect(@ui.css('.ko_tooltip_content_teplate .ko_tooltip_content').text).to eq("This feature is only available on Technology firmware.\nTo enable use of Technology firmware click here to go to firmware settings.")
      elsif status == "enabled"
        expect(@ui.css(path + ".webTitanField .webTitanLabel")).to be_visible
        expect(@ui.css(path + ".webTitanField .webTitanLabel.disabled")).not_to exist
      end
    end
    if status == "enabled" and action == "on"
      it "Enable the 'Content Filtering' feature, save the profile and verify the switch has the proper value" do
        action_on_content_filtering_switch(true)
      end
    elsif status == "enabled" and action == "off"
      it "Disable the 'Content Filtering' feature, save the profile and verify the switch has the proper value" do
        action_on_content_filtering_switch(false)
      end
    end
  end
end