class Admin::ReportsController < AdminController
  def index
    if params[:from].present? && params[:to].present?
      start_date = Date.parse(params[:from])
      end_date = Date.parse(params[:to])
      @orders = Order.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    else
      @orders = Order.where(created_at: 5.days.ago..Time.current)
    end
  end
end
