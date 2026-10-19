class EventsController < ApplicationController
  def create
    date = Date.parse(params[:date])
    start_time = params[:event][:start_time]
    end_time = params[:event][:end_time]

    parsed_start = Time.zone.parse("#{date} #{start_time}")
    parsed_end = Time.zone.parse("#{date} #{end_time}")

    @event = Current.user.events.new(event_params.merge(
      start_time: parsed_start,
      end_time: parsed_end
    ))

    if @event.save
      redirect_to day_path(date.strftime("%Y-%m-%d")), notice: "Событие добавлено"
    else
      redirect_to day_path(date.strftime("%Y-%m-%d")), alert: @event.errors.full_messages.join(", ")
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description)
  end
end
