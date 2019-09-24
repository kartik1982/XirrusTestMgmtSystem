require_relative "../local_lib/switches_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
##############################################################################################################
##############TEST CASE: Swtich Port Template - Test switch port template configuration#######################
##############################################################################################################
describe "********** TEST CASE: Swtich Port Template - Test switch port template configuration **********" do
  sw_port_temp_01_name = "Switch port access laptop template"
  sw_port_temp_01_desc = "Description of "+sw_port_temp_01_name
  sw_port_temp_02_name = "Switch port access server template"
  sw_port_temp_02_desc = "Description of "+sw_port_temp_02_name
  sw_port_temp_03_name = "Switch port access satellite-dish2 template"
  sw_port_temp_03_desc = "Description of "+sw_port_temp_03_name
  sw_port_temp_trunk_name = "Switch port trunk template"
  sw_port_temp_trunk_desc = "Description of "+sw_port_temp_trunk_name

  sw_port_config_01 = {name: sw_port_temp_01_name, description: sw_port_temp_01_desc, icon: "laptop", portenable: "enabled", speed: "Auto", type: "Access", native_vlan: "200", member_vlans: "", poe: "enabled", poe_priority: "Critical", stp_guard: "enabled", access_security: "disabled", auth_mode: ""}
  sw_port_config_02 = {name: sw_port_temp_02_name, description: sw_port_temp_02_desc, icon: "server", portenable: "enabled", speed: "Auto", type: "Access", native_vlan: "300", member_vlans: "", poe: "disabled", poe_priority: "", stp_guard: "disabled", access_security: "enabled", auth_mode: "802.1x MAC Based"}
  sw_port_config_03 = {name: sw_port_temp_03_name, description: sw_port_temp_03_desc, icon: "satellite-dish2", portenable: "enabled", speed: "Auto", type: "Access", native_vlan: "400", member_vlans: "", poe: "disabled", poe_priority: "", stp_guard: "disabled", access_security: "enabled", auth_mode: "802.1x MAC Based"}
  sw_port_config_trunk = {name: sw_port_temp_trunk_name, description: sw_port_temp_trunk_desc, icon: "cloud6", portenable: "enabled", speed: "Auto", type: "Trunk", native_vlan: "100", member_vlans: "200,300,400,500", poe: "disabled", poe_priority: "", stp_guard: "enabled", access_security: "disabled", auth_mode: ""}
  #Delete all templates
  include_examples "delete all switch port templates"
  #Add and confiure switch port templates Access and Trunk
  include_examples "create switch port template", sw_port_temp_01_name, sw_port_temp_01_desc
  include_examples "configure switch port template", sw_port_config_01 
  include_examples "create switch port template", sw_port_temp_02_name, sw_port_temp_02_desc
  include_examples "configure switch port template", sw_port_config_02 
    include_examples "create switch port template", sw_port_temp_03_name, sw_port_temp_03_desc
  include_examples "configure switch port template", sw_port_config_03
  include_examples "create switch port template", sw_port_temp_trunk_name, sw_port_temp_trunk_desc
  include_examples "configure switch port template", sw_port_config_trunk 
  #verify switch port template
  include_examples "verify switch port template configuration", sw_port_config_01
  include_examples "verify switch port template configuration", sw_port_config_02
  include_examples "verify switch port template configuration", sw_port_config_03
  include_examples "verify switch port template configuration", sw_port_config_trunk
end