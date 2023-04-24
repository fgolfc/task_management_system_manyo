class Label < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels

  validates :name, presence: true, length: { maximum: 30 }

  scope :name_cont, ->(name) { where('name LIKE ?', "%#{name}%") if name.present? }
  scope :label_id_is, ->(label_id) { where(id: label_id) if label_id.present? }

  def self.search(params)
    labels = Label.all
    labels = labels.name_cont(params[:name_cont]) if params[:name_cont].present?
    labels = labels.label_id_is(params[:label_id_is]) if params[:label_id_is].present?
    labels
  end

  def task_ids=(ids)
    self.task_labels = ids.map{|id| TaskLabel.new(task_id: id)}
  end

  def task_ids
    self.task_labels.map(&:task_id)
  end
end