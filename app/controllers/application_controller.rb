class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  def hello
    render html: "hello, world!"
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t(:notify_login)
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_user_by_id user_id: params[:id]
    @user = User.find_by id: user_id
  end
end
