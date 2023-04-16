class User < ApplicationRecord
  before_validation { email.downcase! }
  validates :email, uniqueness: { message: 'はすでに使用されています' }, confirmation: true, presence: true
  has_secure_password
  validates :name, presence: true
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, allow_blank: true
  attribute :admin, :boolean, default: false
  has_many :tasks, dependent: :destroy
end