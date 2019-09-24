require_relative "./local_lib/access_control_lib.rb"
require_relative "./local_lib/portal_lib.rb"
require_relative "./local_lib/general_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
#########################################################################################################
###################TEST CASE: PORTAL - MICROSOFT AZURE - ACCESS CONTROL TAB FEATURES#####################
#########################################################################################################
describe "********** TEST CASE: PORTAL - MICROSOFT AZURE - ACCESS CONTROL TAB FEATURES **********" do

  portal_name = "MICROSOFT AZURE - Access Control - " + UTIL.ickey_shuffle(5)
  decription_prefix = "Portal description for: "
  portal_type = "azure"

  include_examples "create portal from header menu", portal_name, decription_prefix + portal_name, portal_type
  include_examples "update azure authorization on", portal_name, portal_type, $azure_user, $azure_password
  include_examples "go to the access control tab", portal_name
  include_examples "verify the access control tab elements", portal_name
  include_examples "create new device entry", "11:11:11:11:11:11", "sad"
  include_examples "verify portal list view tile view toggle"

end