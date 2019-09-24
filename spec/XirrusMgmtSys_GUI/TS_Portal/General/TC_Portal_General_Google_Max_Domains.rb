require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
########################################################################################################
#################TEST CASE: PORTAL - GOOGLE LOGIN - GENERAL TAB FEATURES##############################
########################################################################################################
describe "********** TEST CASE: PORTAL - GOOGLE LOGIN - GENERAL TAB FEATURES **********" do

  portal_name = "GOOGLE LOGIN - General - " + UTIL.ickey_shuffle(5)
  decription_prefix = "Portal description for: "
  portal_type = "google"

  login_domain_elements = []
  101.times do
    domain_body = ["somedomain", "random", "qa.verify", "loongstring#{UTIL.ickey_shuffle(9)}", "test", "string", "#{UTIL.ickey_shuffle(5)}", "text", "somerandomtext", "abcdefghij", "no.more.imagination", "morerandomtext", "somethingwritten"]
    domain_sufix = ["com", "org", "net", "int", "edu", "gov", "mil", "arpa", "museum", "jobs", "cat", "post", "ac", "ad", "ae", "af", "ag", "ar", "ba", "bb", "bg", "bj", "bm", "cf", "ch", "cn", "cy", "de", "eh", "er", "eu", "fi", "gb", "gg", "gn", "hr", "hu", "ht", "ie", "ir", "jp", "km", "kp", "md", "ne", "no", "pl", "re", "ro", "ru", "se", "ss", "tw", "ug", "uk", "um", "us", "va", "wf", "ye", "zw"]
    login_domain = "www." + domain_body.sample + UTIL.ickey_shuffle(3) + "." + domain_sufix.sample
    login_domain_elements.push(login_domain)
  end

  include_examples "create portal from header menu", portal_name, decription_prefix + portal_name, portal_type
  include_examples "update login domains add dont delete", portal_name, portal_type, login_domain_elements

end