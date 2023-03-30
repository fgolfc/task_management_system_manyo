class User < ApplicationRecord
  before_validation { email.downcase! }
  validates :email, uniqueness: true
  has_secure_password
  validates :password, length: { minimum: 6 }
  has_many :tasks

  validates :name, presence: true
  validates :email, presence: true
  validates :password_confirmation, presence: true, if: :password
  validates :password, confirmation: true, if: :password_confirmation
  attribute :is_admin, :boolean, default: false
end