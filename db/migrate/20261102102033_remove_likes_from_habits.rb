class RemoveLikesFromHabits < ActiveRecord::Migration[8.0]
  def change
    remove_column :habits, :likes_count, :integer
    drop_table :likes
  end
end
