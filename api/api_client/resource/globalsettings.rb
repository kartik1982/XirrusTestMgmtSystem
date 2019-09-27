module Globalsettings
  #POST /globalsettings.json/news
  def post_set_whats_new_url_and_message(news_load)
    post_api("globalsettings.json/news", news_load)
  end
end