class TemplateLikesController < ApplicationController
  def create
    @template = HabitTemplate.find(params[:habit_template_id])
    @template.template_likes.create!(user: Current.user)
    redirect_to garden_laboratory_path
  end

  def destroy
    @template = HabitTemplate.find(params[:habit_template_id])
    @template.template_likes.find_by(user: Current.user)&.destroy
    redirect_to garden_laboratory_path
  end
end
