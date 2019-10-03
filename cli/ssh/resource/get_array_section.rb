module GetArraySection

  def show_policies()
    response=show_json("running-config")
    response["system"]["filterListAll"]["entries"]
  end

  def show_ssids()
    response = show_json("running-config")
    response["system"]["ssidCfg"]["entries"]
  end
  
  def show_country_code()
    response = show_json("running-config", true)
    response["system"]["iapGlbCfg"]["countryCode"]
  end

  def show_system_software()
    response = show_json("running-config", true)
    @device_type.downcase.eql?("aos") ? response["system"]["versionInfo"]["swVersion"] : response["system"]["boardCfg"]["version"]
  end

  def show_location_reporting()
    response = show_json("running-config", true)
    response["system"]["locationCfg"]
  end

  def show_timezone_offset()
    response = show_json("running-config", true)
    if @device_type.downcase == "aos"
      response = "#{response['system']['dateTimeCfg']['offsetHours']}:#{response['system']['dateTimeCfg']['offsetMins']}"
    else
      k = response["system"]["dateTimeCfg"]["timezone"]
      timezone_mappings = JSON.parse(File.read( "#{fixtures_root}/json/aos_light_timezone_string_mapings.json" ))
      response = timezone_mappings[k]
    end
    response
  end
end