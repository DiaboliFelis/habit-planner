class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_logs, dependent: :destroy

  validates :name, presence: true
  validates :frequency, numericality: { greater_than: 0 }

  # Добавляем значение по умолчанию, если его нет
  after_initialize :set_default_streak, if: :new_record?

  def mark_as_completed!
    habit_logs.create!(completed_at: Time.current, status: :completed)
    increment!(:current_streak)
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
