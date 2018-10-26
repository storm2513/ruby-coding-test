class EmailHistoryController < ApplicationController
  before_action :set_user

  def index
    @versions = @user.versions
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
