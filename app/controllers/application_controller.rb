class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :authorize
  before_action :increment_hit_counter
  before_action :check_user_activity_time
  around_action :add_response_time_header

  attr_accessor :last_activity

  protected

  def authorize
    unless current_user
      redirect_to login_url, notice: "Please log in"
    end
  end

  def current_user
    @user_logged_in ||= User.find_by(id: session[:user_id])
  end

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] =
          "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end

  def increment_hit_counter
    session[:hit_counter] ||= 0
    session[:hit_counter] += 1
    @hit_counter = session[:hit_counter]
  end

  def add_response_time_header
    start_time = Time.now
    yield
    time_taken = (Time.now - start_time) * 1000
    response.headers["x-responded-in"] = "#{time_taken}ms"
  end

  def check_user_activity_time
    return unless current_user
    if current_user.last_activity_time < 5.minutes.ago
      session[:user_id] = nil
      redirect_to login_url, alert: "You have been logged out due to inactivity."
    else
      current_user.update_column(:last_activity_time, Time.current)
    end
  end
end
