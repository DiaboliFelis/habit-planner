class CreateHabitLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :habit_logs do |t|
      t.datetime :completed_at
      t.integer :status
      t.references :habit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
