class Admin::ReportsController < AdminController
  def index
    start_date = params[:from].present? ? DateTime.parse(params[:from]) : 5.days.ago
    end_date = params[:to].present? ? DateTime.parse(params[:to]) : Time.current
    @orders = Order.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
  end
end
