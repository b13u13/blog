class UserMailer < ActionMailer::Base
  default from: "aovsiychuk@gmail.com"


  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Активация аккаунта MY BLOG!"
  end


  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Востанвление пароля MY BLOG"
  end
end
