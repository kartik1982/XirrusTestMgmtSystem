require_relative "./local_lib/settings_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/guests_lib.rb"
require_relative "../TS_Portal/local_lib/vouchers_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
#######################################################################################
#################TEST CASE: SETTINGS AREA - PROVIDER MANAGEMENT TAB ###################
#######################################################################################
describe "********** TEST CASE: SETTINGS AREA - PROVIDER MANAGEMENT TAB **********" do

  domain_name = "Child Domain for Portal Second tab - Mobile Providers Deactivate ALL " + UTIL.ickey_shuffle(9)

  include_examples "go to commandcenter"
  include_examples "create Domain", domain_name
  include_examples "manage specific domain", domain_name

  countries = ["Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "British Virgin Islands", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Cook Islands", "Costa Rica", "Croatia", "Cuba", "Curaçao", "Cyprus", "Czech Republic", "Democratic Republic of the Congo", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands", "Faroe Islands", "Fiji", "Finland", "France", "French Guiana", "French Polynesia", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Ivory Coast", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn Islands", "Poland", "Portugal", "Puerto Rico", "Qatar", "Republic of the Congo", "Romania", "Russia", "Rwanda", "Réunion", "Saint Helena", "Saint Kitts and Nevis", "Saint Lucia", "Saint Pierre and Miquelon", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Sint Maarten", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "São Tomé and Príncipe", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "United States Virgin Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Wallis and Futuna", "Western Sahara", "Yemen", "Zambia", "Zimbabwe"]

  include_examples "go to settings then to tab", "Provider Management"
  include_examples "deactivate all mobile providers"

  used_providers = []
  used_countries = []

  5.times do
    country = countries.sample
    provider_name = "Mobile Provider " + country + " " + UTIL.ickey_shuffle(9)
    email_domain = country.downcase.gsub(' ','') + ".com"

    include_examples "add mobile provider", provider_name , email_domain, country, "TEST", "TEST"

    used_providers.push(provider_name)
    used_countries.push(country)
  end

  portal_name = "TEST PORTAL TO VERIFY ADDING GUESTS - " + UTIL.ickey_shuffle(9)
  portal_description = "TEST DESCRIPTION: " + UTIL.ickey_shuffle(55)
  portal_type = "self_reg"

  include_examples "create portal from header menu", portal_name, portal_description, portal_type

  used_guests = Hash[]

  5.times do
    country = used_countries.sample
    guest_name = "Tester_" + UTIL.ickey_shuffle(6)
    guest_email = guest_name.downcase + "@test.com"
    mobile_number = UTIL.ickey_shuffle(12)
    guest_company = "Test Company"
    note = "Random note " + UTIL.ickey_shuffle(16)
    mobile_carrier = used_providers.detect {|a| a.include? country}

    include_examples "add guest", portal_name, guest_name, guest_email, true, country, mobile_number, mobile_carrier, guest_company, note, true

    used_guests[guest_name] = [guest_email, country, mobile_number, mobile_carrier]
  end

  include_examples "go to settings then to tab", "Provider Management"

  edit_option = "Verify user slideout"

  used_guests.each do |key, value|

    guest_name = key
    guest_company, note, guest_name_new = nil
    receive_via_sms = true
    guest_email = used_guests[key][0]
    country = used_guests[key][1]
    mobile_number = used_guests[key][2]
    mobile_carrier = used_guests[key][3]

    include_examples "edit guest", portal_name, edit_option, guest_name, guest_name_new, guest_email, receive_via_sms, country, mobile_number, mobile_carrier, guest_company, note, true

  end

  include_examples "go to settings then to tab", "Provider Management"
  include_examples "deactivate all mobile providers"

  used_guests.each do |key, value|

    guest_name = key
    guest_company, note, guest_name_new = nil
    receive_via_sms = true
    guest_email = used_guests[key][0]
    country = nil
    mobile_number = nil
    mobile_carrier = nil

    include_examples "edit guest", portal_name, edit_option, guest_name, guest_name_new, guest_email, receive_via_sms, country, mobile_number, mobile_carrier, guest_company, note, true

  end

  include_examples "go to settings then to tab", "Provider Management"

  used_providers.each do |provider|
    include_examples "delete mobile provider", provider
  end

  include_examples "go to commandcenter"
  include_examples "delete Domain", domain_name

end