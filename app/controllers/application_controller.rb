class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_user_language


  private

    def set_user_language
      I18n.locale =  current_user.locale if signed_in?

    end
end
