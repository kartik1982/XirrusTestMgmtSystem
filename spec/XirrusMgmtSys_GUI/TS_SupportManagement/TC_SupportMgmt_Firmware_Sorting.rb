require_relative "./local_lib/support_management_lib.rb"
####################################################################################################################
################TEST CASE: SUPPORT MANAGEMENT area - Test the FIRMWARE tab - SORTING of columns#####################
####################################################################################################################
describe  "********** TEST CASE: SUPPORT MANAGEMENT area - Test the FIRMWARE tab - SORTING of columns **********" do
	include_examples "go to support management"
	include_examples "verify descending ascending sorting firmware", "Firmware", "Version"
	include_examples "verify descending ascending sorting firmware", "Firmware", "URL"
  include_examples "verify descending ascending sorting firmware", "Firmware", "Firmware Type"
  #From 9.5.0 following columns are removed from application
  # include_examples "verify descending ascending sorting firmware", "Firmware", "Release Date"
	# include_examples "verify descending ascending sorting firmware", "Firmware", "Enterprise Active"
	# include_examples "verify descending ascending sorting firmware", "Firmware", "Enterprise Beta"
	# include_examples "verify descending ascending sorting firmware", "Firmware", "Cloud Active"
	# include_examples "verify descending ascending sorting firmware", "Firmware", "Cloud Beta"

end