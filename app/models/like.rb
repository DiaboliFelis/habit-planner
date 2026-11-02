class Like < ApplicationRecord
  belongs_to :habit, optional: true
  belongs_to :user

  # Валидация: один пользователь может лайкнуть один раз (для привычки или шаблона)
  validates :user_id, uniqueness: { scope: [ :habit_id ], message: "уже лайкнул" }, if: :habit_id?

  after_create :increment_counters
  after_destroy :decrement_counters

  private

  def increment_counters
    habit&.increment!(:likes_count)
    # Если лайк ставится шаблону, мы могли бы добавить это позже, но пока оставим только для привычек
  end

  def decrement_counters
    habit&.decrement!(:likes_count)
  end
end
