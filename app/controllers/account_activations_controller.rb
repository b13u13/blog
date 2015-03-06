class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      user.activate
      sign_in user
      flash[:success] = "Аккаунт успешно активирован!"
      redirect_to user
    else
      flash[:danger] = "Неверная ссылка"
      redirect_to root_url
    end
  end
end