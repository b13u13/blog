class MicropostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy, :edit, :update]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = t('create_post')
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to current_user

  end

  def edit
    @micropost = Micropost.find(params[:id])
  end

  def update
    @micropost = Micropost.find(params[:id])
    @micropost.update(micropost_params)
    if @micropost.errors.present?
      flash.now[:error] = @micropost.errors.full_messages.first
      render 'edit'
    else
      flash[:success] = t('update_mocropost')
      redirect_to current_user
    end

  end




  private

     def micropost_params
       params.require(:micropost).permit(:content)
     end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end



end