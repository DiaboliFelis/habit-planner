class DaysController < ApplicationController
  def show
    @date = Date.parse(params[:date])
    @events = Current.user.events.for_date(@date)
  rescue ArgumentError
    redirect_to root_path, alert: "Некорректная дата"
  end
end
