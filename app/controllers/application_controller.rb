class ApplicationController < ActionController::Base
  include SlackClient

  protect_from_forgery with: :exception
  before_action :redirect_to_https

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

  private

  def redirect_to_https
    redirect_to protocol: 'https://' unless (request.ssl? || request.local?)
  end

end
