class UsersController < ApplicationController
  before_action :signed_in_user, only:  [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end


  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user =User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = t('profile_update')
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Для активации аккаунта проверте свою почту!"
      redirect_to root_url
    else
      render 'new'
    end
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('user_delete')
    redirect_to users_url
  end

  def following
    @title = t('following')
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = t('followers')
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private

     def user_params
       params.require(:user).permit(:name, :email, :password, :password_confirmation, :locale, :avatar, :nick_name)
     end


    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: t('please_sign_in')
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
