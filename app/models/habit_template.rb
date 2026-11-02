class HabitTemplate < ApplicationRecord
  has_many :template_likes, dependent: :destroy
  has_many :liked_by_users, through: :template_likes, source: :user

  broadcasts_to ->(template) { "likes_template_#{template.id}" }
end
