# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    per_page = params[:per_page] || 10
    if params[:role_id].present?
      role = Role.find(params[:role_id])
      @users = role.users.order(:id).paginate(page: params[:page], per_page: per_page)
    else
      @users = User.order(:id).paginate(page: params[:page], per_page: per_page)
    end
  end

  def new
    @user = User.new
    @roles = Role.all
  end

  def edit
    @roles = Role.all
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
        render pdf: 'user_details', template: 'users/download'
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
