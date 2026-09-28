class MainController < ApplicationController
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @month_start = @date.beginning_of_month
    @month_end = @date.end_of_month
    @days = (@month_start..@month_end).to_a
    @prev_month = @date.prev_month
    @next_month = @date.next_month
  end
end
