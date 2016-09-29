class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :add_app_url, :slack_login_url

  protected

  def add_app_url
    'https://slack.com/oauth/authorize' \
    "?client_id=#{ENV['SLACK_CLIENT_ID']}" \
    '&scope=commands,users:read'
  end

  def slack_login_url
    'https://slack.com/oauth/authorize' \
    "?client_id=#{ENV['SLACK_CLIENT_ID']}" \
    "&redirect_uri=#{ENV['HOSTNAME']}#{url_for '/slack_auth'}" \
    '&scope=users:read'
  end

  def slack_client
    team = SlackTeam.find_by_team_id(session[:team_id] || params[:team_id])
    Slack::Web::Client.new(token: team.access_token)
  end
end
