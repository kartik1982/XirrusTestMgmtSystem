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
  #POST /users.json
  def post_add_user(user_load)
    post_api("users.json", user_load)
  end
  #GET /users.json/backoffice/news/reset
  def get_reset_news_all_users
    get_api("users.json/backoffice/news/reset", {})
  end
  #DELETE /users.json/{userId}
  def delete_user_using_userid(user_id)
    delete_api("users.json/#{user_id}")
  end
  #PUT /users.json/{userId}
  def put_update_user(user_id, user_load)
    put_api("users.json/#{user_id}", user_load)
  end
end