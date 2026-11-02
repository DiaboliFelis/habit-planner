class AddLikesCountToHabits < ActiveRecord::Migration[8.0]
  def change
    add_column :habits, :likes_count, :integer, default: 0
  end
end
