class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)
    ActiveRecord::Base.transaction do
      if @user.save
        set_roles
        redirect_to @user, notice: 'User was successfully created.'
      else
        render action: :new
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    ActiveRecord::Base.transaction do
      if @user.update_attributes(user_params)
        set_roles
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render action: :edit
      end
    end
  end

  # DELETE /users/1
  def destroy
    if user_destroyer.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    else
      redirect_to users_url, notice: 'Cannot delete user: user is admin.'
    end
  end

  private

  def user_destroyer
    @user_destroyer ||= UserDestroyerService.new(@user)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin?
    ActiveModel::Type::Boolean.new.cast(params[:user][:admin])
  end

  def customer?
    ActiveModel::Type::Boolean.new.cast(params[:user][:customer])
  end

  def set_roles
    admin?    ? @user.grant(:admin)    : @user.revoke(:admin)
    customer? ? @user.grant(:customer) : @user.revoke(:customer)
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end
end
