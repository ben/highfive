class AdminController < ApplicationController
  before_action :requires_login, except: [:login, :slack_callback]
  helper_method :slack_user_info

  def index
  end

  def login
  end

  def configuration
  end

  private

  def slack_user_info
    @slack_user_info ||= slack_client.users_info(user: session[:user_id]).user
  rescue Faraday::ConnectionFailed
    nil
  end

  def requires_login
    redirect_to '/admin/login' unless logged_in?
  end

  def logged_in?
    puts session[:team_id]
    session.key? 'team_id'
  end
end
