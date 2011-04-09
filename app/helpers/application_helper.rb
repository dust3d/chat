module ApplicationHelper
  def auto_image msg
    unless msg.blank?
      img_url = /(^https?:\/\/(?:[a-z\-]+\.)+[a-z]{2,6}(?:\/[^\/#?]+)+\.(?:jpe?g|gif|png))/
      msg.gsub img_url, link_to('<img src="\\1" alt="image" />'.html_safe, '\\1', :target => "_blank")
    end
  end
  
  def auto_mention msg
    unless msg.blank?
      login = /(@[\S]+)/
      msg.gsub login, '<mark>\\1</mark>'
    end
  end
end
