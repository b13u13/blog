class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        sign_in user
        redirect_back_or user
      else
        message  = "Аккаунт не активирован."
        message += "Проверте свою почту на наличие письма для активации!"
        flash[:warning] = message
        redirect_to signin_url
      end
    else
      flash.now[:danger] = 'Неверная комбинация Email/Пароль'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
