require_relative "../local_lib/support_management_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
#########################################################################################################
##################TEST CASE: Test the Support Management area - Access Points tab########################
#########################################################################################################
describe "TEST CASE: Test the Support Management area - Access Points tab" do
	include_examples "go to support management"
    #include_examples "verify grid columns on access points tab"
    include_examples "verify descending ascending sorting access points", "Serial Number"
    include_examples "verify descending ascending sorting access points", "Status"
    include_examples "verify descending ascending sorting access points", "Expiration Date"
    include_examples "verify descending ascending sorting access points", "Reported AOS Version"
    include_examples "verify descending ascending sorting access points", "Model"
    include_examples "verify descending ascending sorting access points", "Last Configured Time"
end

