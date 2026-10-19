require "test_helper"

class EventsFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @date = Date.today.strftime("%Y-%m-%d")
  end

  # HAPPY PATH
  test "пользователь может создать событие в расписании" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_difference "Event.count", 1 do
      post events_path, params: {
        date: @date,
        event: { title: "Лекция", start_time: "09:00", end_time: "10:30" }
      }
    end

    assert_redirected_to day_path(@date)
    follow_redirect!
    assert_select ".event-card", text: /Лекция/
  end

  # ОТВЕТВЛЕНИЯ
  test "нельзя создать событие без названия" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_no_difference "Event.count" do
      post events_path, params: {
        date: @date,
        event: { title: "", start_time: "09:00", end_time: "10:30" }
      }
    end

    assert_redirected_to day_path(@date)
    follow_redirect!
    assert_select ".alert", text: /Название не может быть пустым/
  end

  test "неавторизованный пользователь не может создать событие" do
    assert_no_difference "Event.count" do
      post events_path, params: {
        date: @date,
        event: { title: "Лекция", start_time: "09:00", end_time: "10:30" }
      }
    end

    assert_redirected_to new_session_path
  end

  test "пользователь не видит события другого пользователя" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    # Создаём событие для второго пользователя
    other_event = @other_user.events.create!(
      title: "Чужое событие",
      start_time: Time.current,
      end_time: 1.hour.from_now
    ) if @other_user

    get day_path(@date)
    assert_response :success
    assert_select ".event-card", text: /Чужое событие/, count: 0
  end
end
