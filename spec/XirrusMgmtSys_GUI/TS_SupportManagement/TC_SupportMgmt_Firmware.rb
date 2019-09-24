require_relative "./local_lib/support_management_lib.rb"
######################################################################################################################################
################TEST CASE: SUPPORT MANAGEMENT area - Test the FIRMWARE tab - Create, edit and delete FIRMWARES########################
######################################################################################################################################
describe  "********** TEST CASE: SUPPORT MANAGEMENT area - Test the FIRMWARE tab - Create, edit and delete FIRMWARES **********" do
	include_examples "go to support management"
	include_examples "create a new firmware", "93.3.3", "2016-02-04", "https://www.google.co.uk", false, true, false, true
	include_examples "create a new firmware", "93.3.4", "2016-02-25", "https://www.google.co.uk", true, false, true, false
	include_examples "create a new firmware", "93.3.5", "2016-02-26", "https://www.test.com", true, false, true, false
	include_examples "create a new firmware", "93.3.6", "2016-02-25", "https://www.qa.org", false, false, false, false
	include_examples "edit a certain firmware", "93.3.4", "93.3.7", "https://www.qatest.edu"

	include_examples "delete a certain firmware with grid delete button", "93.3.3"
	include_examples "delete a certain firmware with delete button from slideout", "93.3.5"
	include_examples "delete a certain firmware with line context button delete", "93.3.6"
	include_examples "delete a certain firmware with line context button delete", "93.3.7"
	include_examples "view details slideout window controls"
end