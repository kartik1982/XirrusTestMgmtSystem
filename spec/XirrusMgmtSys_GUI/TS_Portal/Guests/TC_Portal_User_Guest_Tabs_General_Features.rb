require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/guests_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
##############################################################################################################################
###################TEST CASE: PORTALS area - Test the USERS or GUESTS TAB - ALL TYPES OF PORTAL##############################
##############################################################################################################################
describe  "********** TEST CASE: PORTALS area - Test the USERS or GUESTS TAB - ALL TYPES OF PORTAL **********" do

	domain_name = "Child Domain for Portal Second tab"

	include_examples "verify portal list view tile view toggle"

	portal_types = ["self_reg","ambassador","onetouch","onboarding","voucher","personal","google","azure"]
  	portal_types.each do |portal_type|
  		portal_name = portal_type.upcase + " PORTAL - " + UTIL.ickey_shuffle(6)
  		portal_description = "Description text for the portal named " + portal_name

  		include_examples "create portal from header menu", portal_name, portal_description, portal_type
  		include_examples "verify second tab general features", portal_type
  	end

  	# include_examples "scope to parent tenant"
end