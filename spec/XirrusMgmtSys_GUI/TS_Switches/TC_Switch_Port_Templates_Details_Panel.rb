require_relative "./local_lib/switches_lib.rb"
#############################################################################################################
##############TEST CASE: MY NETWORK area - Test SWITCH Details and Port details panel#####################
#############################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test SWITCH Details and Port details panel **********" do
  port_template_name = "switch_port_template_01"
  port_template_desc = "Description for "+port_template_name
  include_examples "General Switch Port Template general tab", port_template_name, port_template_desc
  include_examples "General Switch Port Template configuration tab", port_template_name
end