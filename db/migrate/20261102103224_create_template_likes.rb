class CreateTemplateLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :template_likes do |t|
      t.references :habit_template, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
