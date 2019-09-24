require_relative "./local_lib/clients_lib.rb"
require_relative "./local_lib/ap_lib.rb"
require_relative "../environment_variables_library.rb"
require_relative "./local_lib/dashboard_lib.rb"
require_relative "./local_lib/dashboard_tiles_lib.rb"
###########################################################################################
###############TEST CASE: Test the MY NETWORK area - CLIENTS TAB###########################
###########################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - CLIENTS TAB **********" do

  tenant_name = return_proper_value_based_on_the_used_environment($the_environment_used, "/my_network/clients_search_for_entries.rb", "Tenant Name")
  tenant_count = return_proper_value_based_on_the_used_environment($the_environment_used, "/my_network/clients_search_for_entries.rb", "Tenant Count")
  first_client = return_proper_value_based_on_the_used_environment($the_environment_used, "/my_network/clients_search_for_entries.rb", "Clients Hash")["First Client"]
  second_client = return_proper_value_based_on_the_used_environment($the_environment_used, "/my_network/clients_search_for_entries.rb", "Clients Hash")["Second Client"]
  third_client = return_proper_value_based_on_the_used_environment($the_environment_used, "/my_network/clients_search_for_entries.rb", "Clients Hash")["Third Client"]
  fourth_client = return_proper_value_based_on_the_used_environment($the_environment_used, "/my_network/clients_search_for_entries.rb", "Clients Hash")["Fourth Client"]

	include_examples "change to tenant", tenant_name, tenant_count
	include_examples "set filter to All Devices", "MyNetwork / Clients tab"
	include_examples "find a certain client hostname and verify the icon and text on device class cell", first_client["Hostname"], first_client["Device Class"], first_client["Device Icon"], true
	include_examples "find a certain client hostname and verify the icon and text on device class cell", second_client["Hostname"], second_client["Device Class"], second_client["Device Icon"], false
	include_examples "find a certain client hostname and verify the icon and text on device class cell", third_client["Hostname"], third_client["Device Class"], third_client["Device Icon"], false
	include_examples "find a certain client hostname and verify the icon and text on device class cell", fourth_client["Hostname"], fourth_client["Device Class"], fourth_client["Device Icon"], false

end