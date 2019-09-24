require_relative "../local_lib/policies_lib.rb"
require_relative "../local_lib/profile_lib.rb"
#####################################################################################################################
############TEST CASE: Test the policies area from a profile - create ALL TYPES of policies##########################
#####################################################################################################################
profile_name = UTIL.random_title.downcase + " - Policies Test"
decription_prefix = "profile description for "


layer_2 = false
rule_protocols = ["ANY-IP","ICMP","IGMP","SRP","TCP","UDP"] #ANY
rule_ports = ["ANY","Numeric","BGP","biff","BOOTPC","BOOTPS","CHARGEN","Daytime","Discard","DNS","DNSIX","echo","Finger","FTP","Gopher","Hostname","HTTP","HTTPS","IPX","IRC","klogin","kshell","LDAP","LPD","nameserver","NetBIOS","NetWare-IP","NNTP","NTP","POP2","POP3","RIP","RSVD","SMTP","SNMP","SSH","SunRPC","syslog","TACACS","TACACS-DS","talk","Telnet","TFTP","UUCP","who","Whois","WWW","XDMCP","XRP"] # "DHCP",
rule_sources = ["Any","IP Address"]
rule_destinations = ["Any","IP Address"]

describe "************TEST CASE: Test the policies area from a profile - create ALL TYPES of policies**********"  do
  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, decription_prefix + profile_name, false

  rule_protocols.each { |rule_protocol|

    rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
    protocol = rule_protocols.sample
    port = rule_ports.sample
    source = rule_sources.sample
    destination = rule_destinations.sample

          include_examples "create a rule for any policy", "Global Policy", "Global Policy", "", "", "firewall", rule_name, true, "allow", "3", protocol, port, source, destination, true, "QoS", "", ""
          include_examples "search for rule and verify it", rule_name, "firewall", "allow", "3", protocol, port, source, destination, true, false, false, ""
  				include_examples "delete rule by name", rule_name, "firewall", false
  }

end