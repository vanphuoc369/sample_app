class UsersController < ApplicationController
  before_action :logged_in_user, expect: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :find_user_by_id, expect: [:index, :new, :create]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    return unless @user.nil?
    flash[:danger] = t(:err_find_user)
    redirect_to signup_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t(:notify_success)
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t(:notify_update_success)
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t(:notify_del_success)
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
