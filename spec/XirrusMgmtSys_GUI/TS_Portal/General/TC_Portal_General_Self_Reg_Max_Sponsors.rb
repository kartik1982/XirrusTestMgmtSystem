require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
########################################################################################################
#################TEST CASE: PORTAL - SELF REGISTRATION - GENERAL TAB FEATURES###########################
########################################################################################################
describe "********** TEST CASE: PORTAL - SELF REGISTRATION - GENERAL TAB FEATURES **********" do

  portal_name = "SELF REGISTRATION - General - "  + UTIL.ickey_shuffle(5)
  decription_prefix = "Portal description for: "
  portal_type = "self_reg"
  sponsor_emails = []
  100.times do
    domain_body = ["somedomain", "random", "qaverify", "loongstring#{UTIL.ickey_shuffle(9)}", "test", "string", "a#{UTIL.ickey_shuffle(5)}", "text", "somerandomtext", "abcdefghij", "nomoreimagination", "morerandomtext", "somethingwritten"]
    domain_sufix = ["com", "org", "net", "int", "edu", "gov", "mil", "arpa", "museum", "jobs", "cat", "post", "ac", "ad", "ae", "af", "ag", "ar", "ba", "bb", "bg", "bj", "bm", "cf", "ch", "cn", "cy", "de", "er", "eu", "fi", "gb", "gg", "gn", "hr", "hu", "ht", "ie", "ir", "jp", "km", "kp", "md", "ne", "no", "pl", "re", "ro", "ru", "se", "tw", "ug", "uk", "us", "va", "wf", "ye", "zw"]
    sponsor_email = UTIL.ickey_shuffle(9) + domain_body.sample + UTIL.ickey_shuffle(3) + "@" + domain_body.sample + UTIL.ickey_shuffle(9) + "." + domain_sufix.sample
    sponsor_emails.push(sponsor_email)
  end
  sponsor_type = "Auto-Confirmation"

  include_examples "create portal from header menu", portal_name, decription_prefix + portal_name, portal_type
  include_examples "update portal sponsor", portal_name, portal_type, sponsor_emails, sponsor_type

  sponsor_emails_second = []
  100.times do
    domain_body = ["somedomain", "random", "qaverify", "loongstring#{UTIL.ickey_shuffle(9)}", "test", "string", "a#{UTIL.ickey_shuffle(5)}", "text", "somerandomtext", "abcdefghij", "nomoreimagination", "morerandomtext", "somethingwritten"]
    domain_sufix = ["com", "org", "net", "int", "edu", "gov", "mil", "arpa", "museum", "jobs", "cat", "post", "ac", "ad", "ae", "af", "ag", "ar", "ba", "bb", "bg", "bj", "bm", "cf", "ch", "cn", "cy", "de", "er", "eu", "fi", "gb", "gg", "gn", "hr", "hu", "ht", "ie", "ir", "jp", "km", "kp", "md", "ne", "no", "pl", "re", "ro", "ru", "se", "tw", "ug", "uk", "us", "va", "wf", "ye", "zw"]
    sponsor_email = UTIL.ickey_shuffle(9) + domain_body.sample + UTIL.ickey_shuffle(3) + "@" + domain_body.sample + UTIL.ickey_shuffle(9) + "." + domain_sufix.sample
    sponsor_emails_second.push(sponsor_email)
  end
  sponsor_type = "Manual Confirmation"

  include_examples "update portal sponsor", portal_name, portal_type, sponsor_emails_second, sponsor_type

end