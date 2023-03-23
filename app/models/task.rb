class Task < ApplicationRecord
  enum priority: { low: 0, medium: 1, high: 2 }, _suffix: true
  enum status: { todo: 0, doing: 1, done: 2 }, _suffix: true

  def self.in_order_of(attribute, values, suffix = :asc)
    order_clause = values.map { |value| "#{attribute}=? DESC" }.join(",")
    order(sanitize_sql_array(["#{order_clause}, #{attribute}_suffix #{suffix}", *values]))
  end

  scope :in_status_order, ->(statuses, status_suffix = :asc) {
    statuses = statuses.map(&:to_i).sort.map { |s| s.zero? ? :asc : :desc }
    status_suffix = status_suffix.join(" ") if status_suffix.is_a?(Array)
    status_suffix = status_suffix.to_sym if status_suffix.is_a?(String)
    if statuses.empty?
      in_order_of(:status, %w[todo doing done], status_suffix)
    else
      in_order_of(:status, statuses.unshift(:asc), status_suffix).reorder(status: :asc)
    end
  }

  def self.priorities_i18n
    priorities.map { |key, _value| [I18n.t("enums.task.priority_enum.#{key}"), key] }
  end

  def self.statuses_i18n
    statuses.map { |key, _value| [I18n.t("enums.task.status_enum.#{key}"), key] }
  end

  def self.search_by_title(search_title)
    where("title LIKE ?", "%#{search_title}%")
  end

  def self.search_tasks(search_title, status)
    tasks = Task.all
    tasks = tasks.search_by_title(search_title) if search_title.present?
    tasks = tasks.in_status_order(status.split(',').map(&:strip)) if status.present?
    tasks.order(deadline: :asc, created_at: :desc)
  end
end