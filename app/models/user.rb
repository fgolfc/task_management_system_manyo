class User < ApplicationRecord
  before_destroy :check_last_admin
  before_update :check_last_admin_change
  before_validation { email.downcase! }
  validates :email, uniqueness: { message: ' そのアドレスは使用できません' }, confirmation: true
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :name, presence: true
  validates :email, presence: true
  validates :password_confirmation, presence: true, if: :password
  validates :password, confirmation: true, if: :password_confirmation
  attribute :admin, :boolean, default: false
  has_many :tasks, dependent: :destroy
  before_destroy :check_last_admin
  before_update :check_last_admin_change

  def check_last_admin
    if self.admin? && User.where(admin: true).count == 1
      errors.add(:base, "最後の管理者ユーザーは削除できません")
      throw :abort
    end
  end

  def check_last_admin_change
    if self.admin_changed? && self.admin? && User.where(admin: true).count == 1
      errors.add(:base, "最後の管理者ユーザーは変更できません")
      throw :abort
    end
  end
end