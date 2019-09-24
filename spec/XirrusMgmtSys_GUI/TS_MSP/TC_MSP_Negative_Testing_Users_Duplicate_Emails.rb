require_relative "./local_lib/msp_lib.rb"
#################################################################################################################
###################TEST CASE: Test the COMMANDCENTER area - NEGATIVE TESTING - USERS############################
#################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - NEGATIVE TESTING - USERS **********"  do
	email = "test" + UTIL.ickey_shuffle(3).to_s + "@negative.com"

	include_examples "create Domain", "Negative testing"
	include_examples "create Domain", "Negative testing 2"
	include_examples "create Domain", "Negative testing 3"
	include_examples "create Administrator from administrator tab", "Test", "Negative", email, "Negative testing"
	#include_examples "create admin from admin tab with the same email address as a previous admin and verify the proper domains", "Negative testing", "Negative testing 2", "Test", "Negative", email
	#include_examples "remove a user from a domain", email, "Negative testing 2", "Negative testing"
	include_examples "create Administrator from administrator tab", "Test", "To edit", "edit@negative.com", "Negative testing 3"
	#include_examples "edit an admin and set a previously used email", "Negative testing", "Test", "To edit", "edit@negative.com", email
	include_examples "delete a certain Administrator", "Test To edit"
	include_examples "delete a certain Administrator", "Test Negative"
	include_examples "delete Domain", "Negative testing"
	include_examples "delete Domain", "Negative testing 2"
	include_examples "delete Domain", "Negative testing 3"

end