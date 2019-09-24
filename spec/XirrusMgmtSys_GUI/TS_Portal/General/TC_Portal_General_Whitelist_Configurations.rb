require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
########################################################################################################
#################TEST CASE: PORTAL - {random type} - VERIFY THE WHITELIST CONFIGURATIONS###############
########################################################################################################
describe "********** TEST CASE: PORTAL - {random type} - VERIFY THE WHITELIST CONFIGURATIONS **********" do

  portal_types = ["self_reg"] # "onetouch", "ambassador", "voucher", "google", "azure", "onboarding"]
  portal_type = portal_types.sample

  portal_name = "#{portal_type.upcase} Portal - #{UTIL.ickey_shuffle(9)}"
  portal_description = "Some random text for the portal description value."

  login_domain = "domain.org"
  landing_page = sponsor = max_devices = nil

   whitelist_element = "*.test.co.uk"

  include_examples "create portal from header menu", portal_name, portal_description, portal_type
  if portal_type == "google"
    include_examples "update login domains dont delete", portal_name, portal_type, login_domain
  elsif portal_type == "azure"
    include_examples "update azure authorization on", portal_name, portal_type, "adinte@alexxirrusoutlook.onmicrosoft.com", "XirrusRo!2345"
  end
  include_examples "show advanced"

  if ["azure", "google"].include? portal_type
    how_many_whitelist_elements = 63
  else
    how_many_whitelist_elements = 64
  end

  whitelist_elements = []
  how_many_whitelist_elements.times do
    domain_prefix = ["*", "www"]
    domain_body = ["somedomain", "random", "qa.verify", "loongstring#{UTIL.ickey_shuffle(9)}", "test", "string", "#{UTIL.ickey_shuffle(5)}", "text", "somerandomtext", "abcdefghij", "no.more.imagination", "morerandomtext", "somethingwritten"]
    domain_sufix = ["com", "org", "net", "int", "edu", "gov", "mil", "arpa", "museum", "jobs", "cat", "post", "ac", "ad", "ae", "af", "ag", "ar", "ba", "bb", "bg", "bj", "bm", "cf", "ch", "cn", "cy", "de", "eh", "er", "eu", "fi", "gb", "gg", "gn", "hr", "hu", "ht", "ie", "ir", "jp", "km", "kp", "md", "ne", "no", "pl", "re", "ro", "ru", "se", "ss", "tw", "ug", "uk", "um", "us", "va", "wf", "ye", "zw"]
    whitelist_element = domain_prefix.sample + "." + domain_body.sample + UTIL.ickey_shuffle(3) + "." + domain_sufix.sample
    whitelist_elements.push(whitelist_element)
  end

  include_examples "comprehensive portal whitelist tests", portal_name, portal_type, true, "Add", whitelist_elements
  include_examples "go to portal", portal_name
  include_examples "comprehensive portal whitelist tests", portal_name, portal_type, false, "Delete All", nil
  include_examples "delete portal from tile", portal_name

end