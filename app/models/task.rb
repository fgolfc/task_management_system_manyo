class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true
  belongs_to :user, dependent: :destroy

  enum priority: { low: 0, medium: 1, high: 2 }, _suffix: true
  enum status: { todo: 0, doing: 1, done: 2 }, _suffix: true

  def self.in_status_order(statuses, status_suffix = :asc)
    statuses = Array(statuses).map(&:to_i).sort.map { |s| s.zero? ? :asc : :desc }
    status_suffix = status_suffix.join(" ") if status_suffix.is_a?(Array)
    status_suffix = Arel.sql(status_suffix.to_s) if status_suffix.is_a?(Symbol)

    if statuses.empty? || statuses == ['todo']
      where(status: statuses)
    else
      values = statuses.unshift(:asc)
      order_by = values.map { |value| "status = ? DESC" }.join(",")
      in_order_of(:status, values, Arel.sql("#{order_by}, #{status_suffix}")).reorder(status: :asc)
    end
  end

  def self.in_order_of(field, values, query)
    order_by = values.map { |value| "#{field} = ?" }.join(",")
    order(Arel.sql("#{order_by}, #{query.to_s}"), *values)
  end
  
  def self.priorities_i18n
    priorities.map { |key, _value| [I18n.t("enums.task.priority_enum.#{key}"), key] }
  end
  
  def self.statuses_i18n
    statuses.map { |key, _value| [I18n.t("enums.task.status_enum.#{key}"), key] }
  end
  
  scope :search_by_title, ->(search_title = nil) { where('title LIKE :search_title', search_title: "%#{search_title.strip}%") if search_title.present? && !search_title.strip.empty? }
  scope :filter_by_status, ->(status) { where(status: status) }
  
  def self.search_tasks(search_title, status)
    tasks = all
    tasks = tasks.search_by_title(search_title) if search_title.present?
    tasks = tasks.filter_by_status(status) if status.present?
    tasks.in_status_order(status).order(created_at: :desc)
  end
end