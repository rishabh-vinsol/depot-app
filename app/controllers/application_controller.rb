class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  before_action :authorize
  before_action :increment_hit_counter
  before_action :set_start_time
  # before_action :check_session_timeout
  # before_action :update_last_activity_at
  after_action :add_response_time

  attr_accessor :last_activity

  protected

  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
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

  def set_start_time
    @start_time = Time.now
  end

  def add_response_time
    time_taken = (Time.now - @start_time) * 1000
    response.headers["x-responded-in"] = "#{time_taken}ms"
  end

  # def update_last_activity_at
  #   debugger
  #   session["last_activity_time"] = Time.now
  # end

  # def check_session_timeout
  #   debugger
  #   # if session['last_activity_time'] && session['last_activity_time'] < 10.seconds.ago
  #   #   redirect_to sessions_destroy_path
  #   # end
  # end
end
