require_relative "./local_lib/settings_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/guests_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
##############################################################################################
################TEST CASE: SETTINGS AREA - PROVIDER MANAGEMENT TAB############################
##############################################################################################
describe "********** TEST CASE: SETTINGS AREA - PROVIDER MANAGEMENT TAB **********" do

  domain_name = "Child Domain for Portal Second tab"
	provider_name_1 = "Algeria_" + UTIL.ickey_shuffle(5)
  provider_name_2 = "Ecuador_" + UTIL.ickey_shuffle(5)
  provider_name_3 = "Qatar_" + UTIL.ickey_shuffle(5)
  provider_name_4 = "Vietnam_" + UTIL.ickey_shuffle(5)

  include_examples "scope to tenant", domain_name

	include_examples "go to settings then to tab", "Provider Management"

  include_examples "add mobile provider", provider_name_1 , "algeria.com", "Algeria", "TEST", "TEST"
  include_examples "add mobile provider", provider_name_2 , "ecuador.com", "Ecuador", "TEST", "TEST"
  include_examples "add mobile provider", provider_name_3 , "qatar.com", "Qatar", "TEST", "TEST"
  include_examples "add mobile provider", provider_name_4 , "vietnam.com", "Vietnam", "TEST", "TEST"

  portal_name = "TEST PORTAL TO VERIFY ADDING GUESTS - " + UTIL.ickey_shuffle(7)
  portal_description = "TEST DESCRIPTION: " + UTIL.ickey_shuffle(55)
  portal_type = "self_reg"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, portal_description, portal_type

  providers = Hash[1 => provider_name_1, 2 => provider_name_2, 3 => provider_name_3, 4 => provider_name_4]
  countries = Array["Algeria", "Ecuador", "Qatar", "Vietnam"]

  @i = 0

  countries.each do |country|
    @i = @i+=1
    guest_name = "Tester_" + UTIL.ickey_shuffle(6)
    guest_email = guest_name + "@test.com"
    mobile_number = UTIL.ickey_shuffle(12)
    guest_company = "Test Company"
    note = "Random note " + UTIL.ickey_shuffle(16)
    mobile_carrier = providers[@i]

    include_examples "add guest", portal_name, guest_name, guest_email, true, country, mobile_number, mobile_carrier, guest_company, note, false

  end

  include_examples "go to settings then to tab", "Provider Management"

 	include_examples "delete mobile provider", provider_name_1
  include_examples "delete mobile provider", provider_name_2
  include_examples "delete mobile provider", provider_name_3
  include_examples "delete mobile provider", provider_name_4

  include_examples "scope to parent tenant"
end