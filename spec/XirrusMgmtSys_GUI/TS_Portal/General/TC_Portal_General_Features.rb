require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
#######################################################################################
#################TEST CASE: PORTAL - GENERAL FEATURES##################################
#######################################################################################
describe "********** TEST CASE: PORTAL - GENERAL FEATURES **********" do

      include_examples "verify portal list view tile view toggle"
      include_examples "verify new easypass portal modal"

end