class ApplicationController < ActionController::Base
  include SlackClient

  protect_from_forgery with: :exception

  helper_method :add_app_url, :slack_login_url

  protected

  def add_app_url
    'https://slack.com/oauth/authorize' \
    "?client_id=#{ENV['SLACK_CLIENT_ID']}" \
    '&scope=commands,users:read,team:read'
  end

  def slack_login_url
    'https://slack.com/oauth/authorize' \
    "?client_id=#{ENV['SLACK_CLIENT_ID']}" \
    "&redirect_uri=#{ENV['HOSTNAME']}#{url_for '/slack_auth'}" \
    '&scope=users:read,team:read'
  end
end
