class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_logs, dependent: :destroy

  validates :name, presence: true
  validates :frequency, numericality: { greater_than: 0 }

  after_initialize :set_default_streak, if: :new_record?

  # проверка на увядание
  def wilted?
    # Если привычку ни разу не выполняли, но она создана давно (например, больше 3 дней назад)
    if last_completed_at.nil?
      created_at < 3.days.ago
    else
      # Если выполняли, но последний раз больше 3 дней назад
      last_completed_at < 3.days.ago
    end
  end

    def plant_emoji
    if wilted?
      "🥀" # Увядший цветок
    else
      case current_streak
      when 0 then "🟤" # Земля
      when 1..3 then "🌱" # Росток
      when 4..7 then "🌿" # Зелёное растение
      when 8..14 then "🌻" # Цветок
      else "🌳" # Дерево
      end
    end
  end

  def mark_as_completed!
    habit_logs.create!(completed_at: Time.current, status: :completed)
    increment!(:current_streak)
    # Обновляем дату последнего выполнения
    update!(last_completed_at: Time.current)
  end

  def completed_today?
    habit_logs.where(completed_at: Time.current.beginning_of_day..Time.current.end_of_day).exists?
  end

  def reset_streak!
    update!(current_streak: 0)
  end

  private

  def set_default_streak
    self.current_streak ||= 0
  end
end
