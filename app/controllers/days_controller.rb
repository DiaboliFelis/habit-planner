class DaysController < ApplicationController
  def show
    @date = Date.parse(params[:date])
    @events = Current.user.events.for_date(@date)
    @habits = Current.user.habits
  rescue ArgumentError
    redirect_to root_path, alert: "Некорректная дата"
  end
end
