require_relative "../local_lib/switches_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
##############################################################################################################
##############TEST CASE: Swtich Template - Test switch template configuration#################################
##############################################################################################################
describe "********** TEST CASE: Swtich Template - Test switch template configuration **********" do
  profile_name = "Profile_switch_tab_configuration"
  profile_description = "Description for " + profile_name
  
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
  
  
  sw_template_XS6012P={name: "SW_TEMPLATE_XS6012P", description: "Description of SW_TEMPLATE_XS6012P", model: "XS-6012P"}
  sw_template_XS6024MP={name: "SW_TEMPLATE_XS6024MP", description: "Description of SW_TEMPLATE_XS6024MP", model: "XS-6024MP"}
  sw_template_XS6048MP={name: "SW_TEMPLATE_XS6048MP", description: "Description of SW_TEMPLATE_XS6048MP", model: "XS-6048MP"}
  
  #Delete all profiles
  include_examples "delete all profiles when switch present"  
  #Add Profile and configure
  include_examples "Create profile from tile when switch present", profile_name, profile_description, false
  include_examples "perform changes on switch tab of a profile by loading switch template", profile_name, sw_template_XS6012P[:name], sw_template_XS6012P[:model]
  include_examples "perform changes on switch tab of a profile by loading switch template", profile_name, sw_template_XS6024MP[:name], sw_template_XS6024MP[:model]
  include_examples "perform changes on switch tab of a profile by loading switch template", profile_name, sw_template_XS6048MP[:name], sw_template_XS6048MP[:model]

  # #Verify switch templates
  include_examples "verify profile switch tab configuration using port config", profile_name, sw_template_XS6012P[:model], sw_port_config_01, sw_port_config_trunk, {}, {}
  include_examples "verify profile switch tab configuration using port config", profile_name, sw_template_XS6024MP[:model], sw_port_config_01, sw_port_config_02, sw_port_config_trunk, {}
  include_examples "verify profile switch tab configuration using port config", profile_name, sw_template_XS6048MP[:model], sw_port_config_01, sw_port_config_02, sw_port_config_03, sw_port_config_trunk   
end