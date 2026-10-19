require "test_helper"

class HabitLogTest < ActiveSupport::TestCase
  setup do
    @habit = habits(:one)
  end

  test "лог не сохраняется без даты" do
    log = HabitLog.new(habit: @habit)
    assert_not log.save
  end

  test "статус по умолчанию completed" do
    log = HabitLog.create!(habit: @habit, completed_at: Time.current)
    assert log.completed?
  end
end
