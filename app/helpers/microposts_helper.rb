module MicropostsHelper

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  def auto_link_usernames(text)
    text.gsub /@[\w+\-._]+/ do |nick_name|
      user = User.find_by(nick_name: nick_name[1..-1])
      if user
        link_to(nick_name, user_path(user))
      else
        nick_name
      end
    end.html_safe
  end


  private

  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
        text.scan(regex).join(zero_width_space)
  end
end