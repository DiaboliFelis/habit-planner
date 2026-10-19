class AddLastCompletedAtToHabits < ActiveRecord::Migration[8.1]
  def change
    add_column :habits, :last_completed_at, :datetime
  end
end
