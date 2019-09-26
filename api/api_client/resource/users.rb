module Users
  # GET /users.json
  def get_users
    get_api("users.json")
  end   
  #GET /users.json/global/email/{email}
  def get_global_user_by_email(user_email)
    get_api("users.json/global/email/#{user_email}", {})
  end 
  #PUT /users.json/backoffice/{userId}/password/{password}
  def put_update_user_password_by_userid(user_id, user_password)
    put_api("users.json/backoffice/#{user_id}/password/#{user_password}", {})
  end  
  
end