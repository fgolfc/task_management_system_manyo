class Label < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy, foreign_key: 'label_id'
  has_many :tasks, through: :task_labels, source: :task

  validates :name, presence: true

  def label_ids=(ids)
    self.task_ids = ids
  end

  def label_ids
    self.task_ids
  end
end