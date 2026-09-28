class EventsController < ApplicationController
  def create
    @event = Current.user.events.new(event_params)
    if @event.save
      redirect_to day_path(@event.start_time.to_date.strftime("%Y-%m-%d")),
                  notice: "Событие добавлено"
    else
      redirect_to day_path(params[:date] || Date.today.strftime("%Y-%m-%d")),
                  alert: @event.errors.full_messages.join(", ")
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time)
  end
end
