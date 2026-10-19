class HabitLog < ApplicationRecord
  belongs_to :habit
  enum :status, { completed: 0, skipped: 1 }
  validates :completed_at, presence: true

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :completed
  end
end
