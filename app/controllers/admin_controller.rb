class AdminController < ApplicationController
  before_action :requires_login, except: [:login, :slack_callback]
  helper_method :slack_users_info, :current_user_info

  def index
  end

  def configuration
  end

  private

  def slack_users_info
    @slack_user_info ||= slack_client.users_list.members
  rescue Slack::Web::Api::Error => e
    puts "!!! slack error #{e}"
    # Token was probably revoked; clear the DB record and the session, the user will have to auth again
    SlackTeam.where(team_id: session[:team_id]).destroy_all
    session.delete :user_id
    session.delete :team_id
    flash[:error] = "Looks like we can't access your slack team any longer. Please re-authenticate."
    redirect_to slack_login_url
  rescue Faraday::ConnectionFailed
    nil
  end

  def current_user_info
    slack_users_info.find { |u| u.id == session[:user_id] }
  end

  def requires_login
    redirect_to slack_login_url unless logged_in?
  end

  def logged_in?
    session.key? 'team_id'
  end
end
