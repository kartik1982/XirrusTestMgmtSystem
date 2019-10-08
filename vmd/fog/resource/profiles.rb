module Profiles
  def add_profile(profile_name, profile_desc, default, readonly)
    execute("addProfile --name #{profile_name} --description '#{profile_desc}' --isDefault #{default} --isReadOnly #{readonly}")
  end  
end