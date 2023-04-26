class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      redirect_to user.role == 'admin' ? admin_reports_path : store_index_url
    else
      redirect_to login_url, alert: t('.invalid')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: t('.logged_out')
  end
end
