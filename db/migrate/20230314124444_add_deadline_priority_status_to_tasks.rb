class AddDeadlinePriorityStatusToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :deadline, :date
    add_column :tasks, :priority, :integer
    add_column :tasks, :status, :integer
  end
end
