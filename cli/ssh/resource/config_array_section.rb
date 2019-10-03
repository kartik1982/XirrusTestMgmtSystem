module ConfigArraySection
  def country_code_reset
    cmd(["interface iap", "country-code-reset", "quit", "quit"])
  end

  def configure_date_time()
    cmd(["date-time", "ntp enable", "dst-adjust enable", "timezone -8:00", "exit", "quit"])
  end

  def set_country_code(code)
    cmd(["interface iap", "country-code #{code}", "exit", "quit"])
  end

  def configure_dns_servers(s_1="10.100.1.10", s_2="10.100.2.10", s_3="8.8.8.8")
    cmd(["dns", "server1 #{s_1}", "server2 #{s_2}", "server3 #{s_3}", "exit", "quit"])
  end
end