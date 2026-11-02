class AddLikesCountToHabitTemplates < ActiveRecord::Migration[8.0]
  def change
    add_column :habit_templates, :likes_count, :integer, default: 0
  end
end
