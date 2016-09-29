class AdminController < ApplicationController
  before_action :requires_login, except: [:login, :slack_callback]
  helper_method :user_slack_info

  def index
  end

  def login
  end

  def configuration
  end

  private

  def user_slack_info
    @user_slack_info ||= slack_client.users_info(user: session[:user_id]).user
  end

  def requires_login
    redirect_to '/admin/login' unless logged_in?
  end

  def logged_in?
    puts session[:team_id]
    session.key? 'team_id'
  end
end
