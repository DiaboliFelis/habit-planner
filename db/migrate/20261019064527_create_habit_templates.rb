class CreateHabitTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :habit_templates do |t|
      t.string :name
      t.text :description
      t.text :benefits
      t.string :icon

      t.timestamps
    end
  end
end
