class AddNotNullConstraintsToTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :title, :string, null: false
    change_column :tasks, :content, :text, null: false
  end
end
