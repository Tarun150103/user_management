class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    if params[:role_id].present?
      @users = Role.find(params[:role_id]).users.order(:id)
    else
      @users = User.order(:id)
    end
  end

  def new
    @user = User.new
    @roles = Role.all # Assuming you have a Role model and want to populate roles in the select box
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.with(user: @user).welcome_email.deliver_now
      redirect_to @user, notice: 'User was successfully created.'
    else
      @roles = Role.all
      render :new
    end
  end

  def edit
    @roles = Role.all # Assuming you have a Role model
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      @roles = Role.all
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  def download
    @users = User.all

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "user_details", template: "users/download"
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :role_id, :image)
  end
end
