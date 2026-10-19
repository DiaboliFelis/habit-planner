require "test_helper"

class HabitsFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    @habit = habits(:one)
  end

  # ============================================================
  # HAPPY PATH
  # ============================================================

  test "пользователь может войти и увидеть сад" do
    # 1. Вход
    post session_path, params: { email_address: @user.email_address, password: "password" }
    assert_redirected_to root_path # или куда там редиректит после входа

    # 2. Переход в Сад
    get garden_path
    assert_response :success
    assert_select "h1", text: /Сад привычек/
  end

  test "пользователь может создать привычку и отметить её выполненной" do
    # 1. Вход
    post session_path, params: { email_address: @user.email_address, password: "password" }

    # 2. Создание привычки
    assert_difference "Habit.count", 1 do
      post habits_path, params: { habit: { name: "Новая привычка", frequency: 1 } }
    end
    assert_redirected_to garden_path
    follow_redirect!
    assert_select ".habit-card", text: /Новая привычка/

    # 3. Отметка выполнения
    new_habit = Habit.last
    assert_difference "HabitLog.count", 1 do
      patch complete_habit_path(new_habit)
    end
    assert_redirected_to garden_path
    follow_redirect!
    assert_select ".badge-success", text: /Выполнено/
  end

  test "пользователь видит привычки в расписании дня" do
    # 1. Вход
    post session_path, params: { email_address: @user.email_address, password: "password" }

    # 2. Переход в расписание сегодняшнего дня
    get day_path(Date.today.strftime("%Y-%m-%d"))
    assert_response :success
    assert_select "h2", text: /Мои привычки на сегодня/
  end

  # ============================================================
  # ОТВЕТВЛЕНИЯ (Ошибочные кейсы)
  # ============================================================

  test "неавторизованный пользователь не может зайти в сад" do
    get garden_path
    assert_redirected_to new_session_path
    follow_redirect!
    assert_select "h1", text: /Вход/
  end

  test "нельзя создать привычку с пустым названием" do
    # 1. Вход
    post session_path, params: { email_address: @user.email_address, password: "password" }

    # 2. Попытка создать привычку без названия
    assert_no_difference "Habit.count" do
      post habits_path, params: { habit: { name: "", frequency: 1 } }
    end

    # 3. Редирект обратно с ошибкой
    assert_redirected_to garden_path
    follow_redirect!
    # Проверяем, что на странице есть сообщение об ошибке
    assert_select ".alert", text: /не может быть пустым/
  end

  test "пользователь не может удалить чужую привычку" do
    # 1. Вход от имени первого пользователя
    post session_path, params: { email_address: @user.email_address, password: "password" }

    # 2. Создаём привычку для второго пользователя
    other_habit = @other_user.habits.create!(name: "Чужая привычка", frequency: 1)

    # 3. Пытаемся её удалить
    assert_no_difference "Habit.count" do
      delete habit_path(other_habit)
    end

    # 4. Ожидаем 404 (Not Found), так как привычка не принадлежит текущему пользователю
    assert_response :not_found
  end

  # ============================================================
  # ДОПОЛНИТЕЛЬНЫЕ ОТВЕТВЛЕНИЯ
  # ============================================================

  test "нельзя создать привычку с частотой 0" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_no_difference "Habit.count" do
      post habits_path, params: { habit: { name: "Тест", frequency: 0 } }
    end

    assert_redirected_to garden_path
    follow_redirect!
    assert_select ".alert", text: /должна быть больше 0/
  end

  test "нельзя удалить привычку, если не вошёл" do
    habit = habits(:one)

    assert_no_difference "Habit.count" do
      delete habit_path(habit)
    end

    assert_redirected_to new_session_path
  end

  test "увядание привычки отображается в интерфейсе" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    # Делаем привычку увядшей
    @habit.update!(last_completed_at: 5.days.ago, current_streak: 3)

    get garden_path
    assert_response :success
    assert_select ".habit-card.wilted", count: 1
    assert_select ".habit-card.wilted .plant", text: "🥀"
  end

  test "нельзя редактировать чужую привычку" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    # Пытаемся удалить привычку второго пользователя
    other_habit = @other_user.habits.create!(name: "Чужая", frequency: 1)

    assert_no_difference "Habit.count" do
      delete habit_path(other_habit)
    end

    assert_response :not_found
  end
end
