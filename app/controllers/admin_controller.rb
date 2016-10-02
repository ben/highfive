class AdminController < ApplicationController
  before_action :requires_login, except: [:login, :slack_callback]
  helper_method :slack_users_info, :current_user_info

  def index
  end

  def login
  end

  def configuration
  end

  private

    @slack_user_info ||= slack_client.users_info(user: session[:user_id]).user
  def slack_users_info
  rescue Faraday::ConnectionFailed
    nil
  end

  def current_user_info
    slack_users_info.find { |u| u.id == session[:user_id] }
  end

  def requires_login
    redirect_to '/admin/login' unless logged_in?
  end

  def logged_in?
    puts session[:team_id]
    session.key? 'team_id'
  end
end
