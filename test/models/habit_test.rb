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

  # --- (на увядание и рост) ---

  test "wilted? возвращает false, если привычку выполняли недавно" do
    @habit.update!(last_completed_at: 1.day.ago)
    assert_not @habit.wilted?
  end

  test "wilted? возвращает true, если привычку не выполняли 4 дня" do
    @habit.update!(last_completed_at: 4.days.ago)
    assert @habit.wilted?
  end

  test "wilted? возвращает true, если привычка создана давно и не выполнялась" do
    # Симулируем, что привычка создана 5 дней назад, и last_completed_at = nil
    @habit.update!(created_at: 5.days.ago, last_completed_at: nil)
    assert @habit.wilted?
  end

  test "plant_emoji возвращает росток (🌱), если стрик 1-3 дня" do
    @habit.update!(current_streak: 2, last_completed_at: Time.current)
    assert_equal "🌱", @habit.plant_emoji
  end

  test "plant_emoji возвращает увядший цветок (🥀), если привычка увяла" do
    @habit.update!(current_streak: 5, last_completed_at: 4.days.ago)
    assert_equal "🥀", @habit.plant_emoji
  end

  # --- (на валидации) ---

  test "привычка не сохраняется без названия" do
    habit = Habit.new(frequency: 1, user: @user)
    assert_not habit.save
    assert_includes habit.errors[:name], "не может быть пустым"
  end

  test "привычка не сохраняется с частотой 0" do
    habit = Habit.new(name: "Тест", frequency: 0, user: @user)
    assert_not habit.save
  end
end
