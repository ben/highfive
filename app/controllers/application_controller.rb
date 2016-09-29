class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :add_app_url, :slack_login_url

  protected

  def add_app_url
    "https://slack.com/oauth/authorize?scope=commands&client_id=#{ENV['SLACK_CLIENT_ID']}"
  end

  def slack_login_url
    'https://slack.com/oauth/authorize' \
    "?client_id=#{ENV['SLACK_CLIENT_ID']}" \
    "&redirect_uri=#{ENV['HOSTNAME']}#{url_for '/slack_auth'}" \
    '&scope=identity.basic'
  end
end
