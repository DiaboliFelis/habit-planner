class HabitsController < ApplicationController
  def create
    @habit = Current.user.habits.new(habit_params)
    if @habit.save
      redirect_to garden_path, notice: "Привычка создана!"
    else
      redirect_to garden_path, alert: @habit.errors.full_messages.join(", ")
    end
  end

    def complete
    @habit = Current.user.habits.find(params[:id])
    @habit.mark_as_completed!
    # Если пришел параметр return_to (с какой страницы пришли), возвращаем туда
    if params[:return_to].present?
      redirect_to params[:return_to], notice: "Отлично! Привычка выполнена."
    else
      redirect_to garden_path, notice: "Отлично! Привычка выполнена."
    end
  end

    def destroy
    @habit = Current.user.habits.find(params[:id])
    @habit.destroy
    redirect_to garden_path, notice: "Привычка удалена."
  end

  private

  def habit_params
    params.require(:habit).permit(:name, :goal, :frequency)
  end
end
