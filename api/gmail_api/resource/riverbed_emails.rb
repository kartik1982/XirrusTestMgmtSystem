module RiverbedEmails
  def get_latest_emails_from_riverbed_for_user(user)
    from_user = "noreply@riverbed.com"
    to_user = "xirrusms@gmail.com"
    get_latest_email_for_user(user, from_user, to_user)
  end
  
  def user_received_latest_email_from_riverbed(user)
    get_latest_emails_from_riverbed_for_user(user).size > 0 ? true : false      
  end
  
  def gmail_from_riverbed_today
    from_user = "noreply@riverbed.com"
    gmail_today_from_user(from_user)
  end
end