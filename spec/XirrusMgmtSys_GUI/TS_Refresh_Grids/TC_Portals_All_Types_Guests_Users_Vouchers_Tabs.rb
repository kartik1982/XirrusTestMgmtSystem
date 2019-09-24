require_relative "local_lib/refresh_grids_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
#############################################################################################
##############TEST CASE: TEST ALL GRIDS GENERAL SETTINGS AND REFRESH BUTTON#################
#############################################################################################
describe "TEST CASE: TEST ALL GRIDS GENERAL SETTINGS AND REFRESH BUTTON" do
	domain_name = "Child Domain for Portal Second tab"

	#include_examples "scope to tenant", domain_name
	include_examples "verify portal list view tile view toggle"

	portal_types = ["voucher","onboarding","personal","self_reg","google","ambassador","onetouch","azure"]
	portal_types.each { |portal_type|
		portal_name = UTIL.random_serial + " - #{portal_type}"
		portal_description = UTIL.random_building_title
		if ['ambassador','onboarding','self_reg','voucher'].include?(portal_type)
			include_examples "create portal from header menu", portal_name, portal_description, portal_type
			include_examples "access services guests/users/vouchers tab", portal_name, portal_type
			include_examples "delete portal", portal_name
		elsif ["google","personal","azure"].include?(portal_type)
			include_examples "create portal from header menu", portal_name, portal_description, portal_type
			include_examples "access services verify refresh exists", portal_name, portal_type
			include_examples "delete portal", portal_name
		end
	}

	#include_examples "scope to parent tenant"
end