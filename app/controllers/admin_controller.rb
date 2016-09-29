class AdminController < ApplicationController
  before_action :requires_login, except: [:login, :slack_callback]

  def index
  end

  def login
  end

  def configuration
  end

  private

  def requires_login
    redirect_to '/admin/login' unless logged_in?
  end

  def logged_in?
    puts session[:team_id]
    session.key? 'team_id'
  end
end
