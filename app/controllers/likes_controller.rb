class LikesController < ApplicationController
  def create
    @habit = Current.user.habits.find(params[:habit_id])
    @habit.likes.create!(user: Current.user)
    redirect_to garden_path
  end

  def destroy
    @habit = Current.user.habits.find(params[:habit_id])
    @habit.likes.find_by(user: Current.user)&.destroy
    redirect_to garden_path
  end
end
