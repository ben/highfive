class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :add_app_url

  protected

  def add_app_url
    "https://slack.com/oauth/authorize?scope=commands&client_id=#{ENV['SLACK_CLIENT_ID']}"
  end
end
