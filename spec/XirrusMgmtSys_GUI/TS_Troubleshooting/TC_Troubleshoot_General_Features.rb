require_relative "./local_lib/troubleshooting_lib.rb"

describe "********** TEST CASE: Test the TROUBLESHOOTING area - GENERAL FEATURES **********" do
	include_examples "go to the troubleshooting area"
	include_examples "verify main features"
end