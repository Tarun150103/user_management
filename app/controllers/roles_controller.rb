# frozen_string_literal: true

# app/controllers/roles_controller.rb
class RolesController < ApplicationController
  before_action :set_role, only: %i[show edit update destroy]

  def index
    per_page = params[:per_page] || 10
    @roles = Role.all.paginate(page: params[:page], per_page: per_page)
      @role_user_counts = Role.includes(:users).map { |role| [role.id, role.users.count] }.to_h
  end

  def show; end

  def new
    @role = Role.new
  end

  def edit; end

  def create
    @role = Role.new(role_params)

    if @role.save
      redirect_to @role, notice: 'Role was successfully created.'
    else
      render :new
    end
  end

  def update
    if @role.update(role_params)
      redirect_to @role, notice: 'Role was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @role.destroy
    redirect_to roles_url, notice: 'Role was successfully destroyed.'
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name)
  end
end
