class GardenController < ApplicationController
  def index
    @habits = Current.user.habits
  end

  def laboratory
  end

  def almanac
  end
end
