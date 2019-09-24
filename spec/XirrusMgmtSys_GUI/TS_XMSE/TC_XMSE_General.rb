require_relative "local_lib/xmse_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Portal/local_lib/lookfeel_lib.rb"
#####################################################################################################################
##############TEST CASE: Test the XMS - Enterprise functionality - General Features#################################
#####################################################################################################################
describe "TEST CASE: Test the XMS - Enterprise functionality - General Features" do

  portal_types = ['self_reg','ambassador'] 

  include_examples "verify main window components"
  include_examples "verify contact us tab" #old methodwas "verify contact us"
  include_examples "verify descending ascending sorting on xmse access points", "Serial Number"
  include_examples "verify descending ascending sorting on xmse access points", "Last Configured Time"
  include_examples "verify refresh button on access points tab"
  
#to edit
  #include_examples "confirm guest count on landing"
    
end