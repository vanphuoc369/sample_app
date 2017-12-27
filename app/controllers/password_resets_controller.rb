class PasswordResetsController < ApplicationController
  before_action :find_user_by_email, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t(:notify_sent_require_reset_pass)
      redirect_to root_url
    else
      flash.now[:danger] = t(:notify_not_found_email)
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(:error_password_empty))
      render :edit
    else
      pass_not_empty
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t(:notify_password_expired)
    redirect_to new_password_reset_url
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def pass_not_empty
    return render :edit unless @user.update_attributes(user_params)
    log_in @user
    flash[:success] = t(:notify_reset_pass_success)
    redirect_to @user
  end
end
