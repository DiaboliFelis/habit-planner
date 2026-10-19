require "test_helper"

class HabitTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @habit = Habit.create!(name: "Бег", frequency: 1, user: @user)
  end

  test "mark_as_completed! создает лог и увеличивает стрик" do
    assert_difference -> { @habit.habit_logs.count }, 1 do
      @habit.mark_as_completed!
    end
    assert_equal 1, @habit.current_streak
  end

  test "completed_today? возвращает true, если выполнена" do
    @habit.mark_as_completed!
    assert @habit.completed_today?
  end

  test "reset_streak! сбрасывает счетчик в 0" do
    @habit.update!(current_streak: 5)
    @habit.reset_streak!
    assert_equal 0, @habit.current_streak
  end
end
