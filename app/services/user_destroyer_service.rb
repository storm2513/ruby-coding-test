class UserDestroyerService
  def initialize(user)
    @user = user
  end

  def destroy
    return false if @user.admin?
    @user.destroy
  end
end
