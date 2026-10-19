class GardenController < ApplicationController
  def index
    @habits = Current.user.habits
  end

  def laboratory
    @templates = HabitTemplate.all
  end

  def almanac
    @habits = Current.user.habits
  end
end
