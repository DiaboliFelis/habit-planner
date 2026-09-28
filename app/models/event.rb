class Event < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  scope :for_date, ->(date) {
    where(start_time: date.beginning_of_day..date.end_of_day)
      .order(:start_time)
  }
end
