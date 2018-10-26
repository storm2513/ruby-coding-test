class User < ApplicationRecord
  rolify

  has_paper_trail only: [:email]

  validates :email, uniqueness: true
  validates :email, :first_name, :last_name, presence: true
  validates :email, email: true

  def admin?
    has_role?(:admin)
  end

  def customer?
    has_role?(:customer)
  end
end
