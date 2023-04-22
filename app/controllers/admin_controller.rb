class AdminController < ApplicationController
  before_action :set_user
  before_action :authenticate_admin!

  def index
    @total_orders = Order.count
  end

  private

  def authenticate_admin!
    redirect_to store_index_path, notice: "You don't have privilege to access this section" unless @user.role == "admin"
  end

  def set_user
    @user = User.find(session[:user_id])
  end
end
