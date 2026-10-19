class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_logs, dependent: :destroy

  validates :name, presence: true
  validates :frequency, numericality: { greater_than: 0 }

  after_initialize :set_default_streak, if: :new_record?

  # 🥀 Проверка на увядание
  def wilted?
    if last_completed_at.nil?
      created_at < 3.days.ago
    else
      last_completed_at < 3.days.ago
    end
  end

  # 🌿 Выбор эмодзи
  def plant_emoji
    if wilted?
      "🥀"
    else
      case current_streak
      when 0 then "🟤"
      when 1..3 then "🌱"
      when 4..7 then "🌿"
      when 8..14 then "🌻"
      else "🌳"
      end
    end
  end

  # ✅ Отметить выполнение
  def mark_as_completed!
    # 1. Проверяем, не нужно ли сбросить стрик из-за пропуска
    reset_streak_if_missed!

    # 2. Создаем лог и увеличиваем стрик
    habit_logs.create!(completed_at: Time.current, status: :completed)
    increment!(:current_streak)
    update!(last_completed_at: Time.current)
  end

  # 🕒 Проверка "выполнено ли сегодня"
  def completed_today?
    habit_logs.where(completed_at: Time.current.beginning_of_day..Time.current.end_of_day).exists?
  end

  # 🔄 Сброс стрика в 0
  def reset_streak!
    update!(current_streak: 0)
  end

  private

  def set_default_streak
    self.current_streak ||= 0
  end

  # 🧠 Бизнес-логика сброса: если последнее выполнение было не вчера и не сегодня
  def reset_streak_if_missed!
    return if last_completed_at.nil?

    if last_completed_at.to_date < Date.yesterday
      reset_streak!
    end
  end
end
