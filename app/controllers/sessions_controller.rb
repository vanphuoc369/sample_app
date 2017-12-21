class SessionsController < ApplicationController
  before_action :set_user, only: [:create]
  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == Settings.checkbox_remember_1.to_s ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = t(:notify_session)
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def set_user
    @user = User.find_by email: params[:session][:email].downcase
  end
end
