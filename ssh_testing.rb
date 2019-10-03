require_relative 'cli/ssh/ssh_session.rb'
# require_relative 'cli/telnet/telnet_session.rb'

# ssh = CLI::SshSession.new({ip: "10.100.188.67", device_type: "aoslite"})
ssh = CLI::SshSession.new({ip: "10.100.244.103", device_type: "aos"})
# telnet = CLI::Telnet.new({ip: "10.100.244.103"})
# telnet.cmd("configure")
# telnet.cmd("more off")
# aos=telnet.show_aos_version_info
# puts telnet.activation_done?
# puts telnet.show_ssid_whitelist("Kartik_Prev_Google")
# puts telnet.show_ssids
# puts ssh.show_system_software
# puts ssh.show_policies
# puts ssh.show_location_reporting
puts ssh.show_timezone_offset