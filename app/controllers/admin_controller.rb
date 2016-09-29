class AdminController < ApplicationController
  before_action :requires_login, except: [:login, :slack_callback]

  def index
  end

  def login
  end

  def slack_callback
    session[:team_id] = request.env['omniauth.auth'].team_id
    flash[:warning] = add_app_message unless session[:team_id]
    redirect_to '/admin'
  end

  def configuration
  end

  private

  def requires_login
    redirect_to '/admin/login' unless logged_in?
  end

  def logged_in?
    false
  end

  def add_app_message
    "I'm having trouble finding your team. Have you <a href=\"#{add_app_url}\">added the app</a>?"
  end
end
