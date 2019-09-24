require_relative "./local_lib/troubleshooting_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
##############################################################################################################
###################TEST CASE: TROUBLESHOOTING AREA - AUDIT TRAIL TAB - EXPORTS##############################
##############################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - AUDIT TRAIL TAB - EXPORTS **********" do
  include_examples "set timezone area to local"
	include_examples "export audit trail", "250"

end