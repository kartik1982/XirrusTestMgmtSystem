require_relative "../local_lib/steel_connect_lib.rb"
require_relative "../../environment_variables_library.rb"
############################################################################
##############TEST CASE: STEEL CONNECT - Go Direct to Tenant###############
############################################################################
describe "********** TEST CASE: STEEL CONNECT - Go Direct to Tenant **********" do

  # area_hash = Hash["My Network Map" => Hash["Area URL" => "mynetwork/overview/map", "Area Title" => "My Network"], "Settings My Account" => Hash["Area URL" => "settings/myaccount", "Area Title" => "Settings"], "Reports" => Hash["Area URL" => "reports/reports", "Area Title" => "Reports"], "Analytics" => Hash["Area URL" => "analytics", "Area Title" => "Analytics"], "Contact Us" => Hash["Area URL" => "contact", "Area Title" => "Contact"], "My Network Rogues" => Hash["Area URL" => "mynetwork/rogues", "Area Title" => "My Network"], "Settings Firmware Upgrades" => Hash["Area URL" => "settings/firmwareupgrades", "Area Title" => "Settings"], "My Network Floor Plans" => Hash["Area URL" => "mynetwork/floorplans", "Area Title" => "My Network"]]
  area_hash = Hash["My Network Map" => Hash["Area URL" => "mynetwork/overview/map", "Area Title" => "My Network"], "Settings My Account" => Hash["Area URL" => "settings/myaccount", "Area Title" => "Settings"], "Reports" => Hash["Area URL" => "reports/reports", "Area Title" => "Reports"], "Analytics" => Hash["Area URL" => "analytics", "Area Title" => "Analytics"], "My Network Rogues" => Hash["Area URL" => "mynetwork/rogues", "Area Title" => "My Network"], "Settings Firmware Upgrades" => Hash["Area URL" => "settings/firmwareupgrades", "Area Title" => "Settings"], "My Network Floor Plans" => Hash["Area URL" => "mynetwork/floorplans", "Area Title" => "My Network"]]

  area_hash.keys.each_with_index do |key, index|
    if index.even?
      tenant_id = return_proper_value_based_on_the_used_environment($the_environment_used, "steelconnect/go_directly_to_tenant.rb", nil)["First Tenant ID"]
      tenant_name = return_proper_value_based_on_the_used_environment($the_environment_used, "steelconnect/go_directly_to_tenant.rb", nil)["First Tenant Name"]
    else
      tenant_id = return_proper_value_based_on_the_used_environment($the_environment_used, "steelconnect/go_directly_to_tenant.rb", nil)["Second Tenant ID"]
      tenant_name = return_proper_value_based_on_the_used_environment($the_environment_used, "steelconnect/go_directly_to_tenant.rb", nil)["Second Tenant Name"]
    end
    area_url = area_hash[key]["Area URL"]
    area_title = area_hash[key]["Area Title"]
    if key.include? "Floor Plans"
      tenant_id = tenant_id + "NOT-VALID"
      error = true
    else
      error = false
    end

    include_examples "directly scope to a tenant using the url input of the browser", tenant_id, tenant_name, area_url, area_title, error
  end

end