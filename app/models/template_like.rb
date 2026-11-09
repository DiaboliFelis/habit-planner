class TemplateLike < ApplicationRecord
  belongs_to :habit_template
  belongs_to :user

  validates :user_id, uniqueness: { scope: :habit_template_id, message: "уже лайкнул" }

  after_create :increment_counter
  after_commit :broadcast_like_update
  after_destroy :decrement_counter

  private

  def increment_counter
    habit_template.increment!(:likes_count)
  end

  def decrement_counter
    habit_template.decrement!(:likes_count)
  end

  def broadcast_like_update
  habit_template.broadcast_replace_to(
    "likes_template_#{habit_template.id}",
    target: "likes_habit_template_#{habit_template.id}", # <-- ИСПРАВЛЕНО
    partial: "habit_templates/likes",
   locals: { template: habit_template }
  )
  end
end
