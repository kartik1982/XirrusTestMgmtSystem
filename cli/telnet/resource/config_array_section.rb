module ConfigArraySection
  def configure_date_time()
    cmd("configure")
    cmd("date-time")
    cmd("dst-adjust enable")
    cmd("ntp enable")
    cmd("timezone -8")
    cmd("exit")
    cmd("exit")
  end

  def configure_dns_servers(s_1="10.100.1.10", s_2="10.100.2.10")
    cmd("configure")
    cmd("dns")
    cmd("server1 #{s_1}")
    cmd("server2 #{s_2}")
    cmd("exit")
    cmd("exit")
  end

  def enable_backdoor(env)
    cmd("configure")
    cmd("boot-env")
    cmd("set bootargs console=ttyS0,115200n8 root=/dev/ram rw quiet ACTIVATION_URL=https://activate-#{env}.cloud.xirrus.com CLIOPTS=b")
    cmd("exit")
    cmd("exit")
  end

  def change_filter_state(filter_name, state)
    valid_options = ["enable", "disable"]
    raise(ArgumentError, "Filter State option must be one of : #{valid_options.to_s}") unless valid_options.include?(state)
    cmd('configure')
    cmd('filter')
    cmd("edit-list #{filter_name}")
    cmd(state)
    cmd("exit")
    cmd("exit")
    cmd("exit")
  end

  def country_code_reset
    configure
    cmd("interface iap")
    cmd("global-settings")
    cmd("country-code-reset")#{|c| print c}
  end

  def set_country_code(code)
    configure
    cmd("interface iap")
    cmd("global-settings")
    cmd("country-code #{code}")
    cmd("exit")
    cmd("exit")
  end
end