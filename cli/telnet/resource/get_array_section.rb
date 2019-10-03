module GetArraySection
  def show_aos_version_info()
    show_json("running-config")["system"]["versionInfo"]
  end

  def show_syslog()
    cmd("show syslog")
  end

  def show_global_settings()
    show_json("running-config")["system"]["iapGlbCfg"]
  end

  def show_dhcp_server_settings()
    show_json("running-config")["system"]["dhcpServerCfg"]["entries"].first
  end

  def show_dhcp_gig_settings(port_type = "gig1")
    show_json("running-config")["system"]["ethCfg"]["entries"].find { |entry| entry["dev"] == port_type }
  end

  def show_running_config_section(section)
    configure
    cmd("show running-config inc-defaults section \"#{section}\"")
  end

  def show_location_reporting()
    show_json("running-config")["system"]["locationCfg"]
  end

  def show_passwords_enable()
    configure
    cmd("show clear-text enable")
  end

  def show
    cmd('show')
  end

  def show_top
    cmd('top')
    cmd('show')
  end

  def show_management
    configure
    management
    show
  end

  def get_crash_log
    cmd('show crash')
  end

  def show_contact_info
    cmd('show contact-info')
  end

  def show_software_image
    #cmd('top')
    configure
    cmd('no more')
    cmd('show software-image')
  end

  def show_dns
    cmd('configure')
    cmd('show dns')
  end

  def show_ntp
    cmd('configure')
    cmd('date-time')
    cmd('show')
  end

  def show_ssids
    cmd('configure')
    cmd('ssid')
    cmd('show')
  end

  def show_ssid(ssid)
    top
    cmd('ssid')
    cmd("show ssid #{ssid}")
  end

  def show_ssid_whitelist(ssid_name)
    top
    cmd('ssid')
    cmd("edit #{ssid_name}")
    cmd('show wpr-whitelist all')
  end

  def show_timezone_offset()
    cmd('configure')
    cmd('date-time')
    cmd('show').get_line("Offset").split(' ')[2].strip
  end

  def show_policy(name)
    show_filter_list
    cmd("edit-list #{name}")
    cmd('show')
  end

  def show_saved_config_section(section)
    configure
    cmd("show saved-config inc-defaults section \"#{section}\"")
  end

  def show_ssids()
    show_json("no-header raw running-config")["system"]["ssidCfg"]["entries"]
  end

  def show_activation_interval()
    show_json("no-header raw running-config")["system"]["extMgmt"]["mgmtCfg"]["activationInterval"]
  end

  def show_system_software()
    show_json("running-config")["system"]["versionInfo"]["swName"]
  end

  def show_policies(_case = "filterListAll")
    show_json("running-config")["system"][_case]["entries"]
  end

  def show_iap_settings(iap_number)
    top
    configure
    cmd('interface iap')
    cmd("iap#{iap_number}")
    cmd('show')
  end

  def show_global_iap_settings
    show_running_config_section("interface iap  ! (global settings)")
  end

  def show_gig(gig_number)
    top
    cmd("interface gig#{gig_number}")
    cmd("show")
  end

  def show_profile_optimizations
    show_json("settings iap-global-ac")
  end

  def show_gig1
    show_gig("1")
  end

  def show_gig2
    show_gig("2")
  end

  def show_led_setting(gig_number)
    gig_settings = self.send(:show_gig, gig_number)
    gig_settings.get_line("LED indicator").split(' ')[2].strip
  end

  def show_filter_list
    cmd('configure')
    cmd('filter')
    cmd('show filter-list')
  end

  def show_global_settings
    top
    configure
    cmd('interface iap')
    cmd('global-settings')
    show
  end

  def show_group(group_name)
    top
    cmd('group')
    cmd("show group #{group_name}")
  end
  
  def show_defaults_by_section(section_type)
     valid_options = ["lldp", "security wep", "syslog", "contact-info", "interface iap"]  # TODO add more types in the future
     raise(ArgumentError, "Section type must be one of : #{valid_options.to_s}") unless valid_options.include?(section_type.delete('\\"'))
     x = cmd("show running-config inc-defaults section #{section_type}")

     section_type = section_type.delete('\\"')
     if section_type == "lldp"
       x = {
         "interval"=> x.get_line("interval").split(' ')[1].strip,
         "hold-time"=> x.get_line("hold-time").split(' ')[1].strip,
         "enable"=> x[x.index{|a|a.include?("hold-time")} + 1...x.index{|a|a.include?("request-power")}].first.strip,
         "request-power"=> x.get_line("request-power").split(' ')[1].strip
       }
     elsif section_type == "security wep"
       x = {"default-key"=> x.get_line("default-key").split(' ')[1].strip}
     elsif section_type == "syslog"
       x = {"enable"=> x[x.index{|a|a.include?("exit")}-1].strip}
     elsif section_type == "contact-info"
       x = {
         "name"=> x.get_line("name").split(' ')[1].strip.delete('\\"'),
         "phone"=> x.get_line("phone").split(' ')[1].strip.delete('\\"'),
         "email"=> x.get_line("email").split(' ')[1].strip.delete('\\"')
       }
     elsif section_type == "interface iap"
       # TODO Add more Global options if needed. For now we just return only multicasts.
       x = {"multicasts" => x.get_lines(/multicast/).map{ |multicast| multicast.split(" ").drop(1).join(" ") } }
     end
      x
   end

end #GetArraySection