class User < ApplicationRecord
  before_validation { email.downcase! }
  validates :email, uniqueness: { message: 'はすでに使用されています' }, confirmation: true, presence: true
  has_secure_password
  validates :name, presence: true
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, allow_blank: true
  attribute :admin, :boolean, default: false
  has_many :tasks, dependent: :destroy

  before_destroy do
    if admin? && User.where(admin: true).count == 1
      errors.add(:admin, '権限を持つユーザが1人しかいないため、削除できません')
      throw :abort
    end
  end
  
  before_update do
    if admin_changed? && admin_was && User.where(admin: true).count == 1
      errors.add(:admin, '権限を持つユーザが1人しかいないため、更新できません')
      throw :abort
    end
  end
end