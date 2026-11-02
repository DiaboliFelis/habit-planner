class GardenController < ApplicationController
  def index
    @habits = Current.user.habits
  end

  def laboratory
    @templates = HabitTemplate.order(likes_count: :desc)
  end

  def almanac
    @habits = Current.user.habits
    @templates = HabitTemplate.all
  end
end
