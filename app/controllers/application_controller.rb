class ApplicationController < ActionController::Base
  include SlackClient

  protect_from_forgery with: :exception

  helper_method :add_app_url, :slack_login_url

  protected

  SCOPES = %w(commands chat:write:bot users:read users:read.email team:read)

  def add_app_url
    'https://slack.com/oauth/authorize' \
    "?client_id=#{ENV['SLACK_CLIENT_ID']}" \
    "&scope=#{SCOPES.join(',')}"
  end

  def slack_login_url
    'https://slack.com/oauth/authorize' \
    "?client_id=#{ENV['SLACK_CLIENT_ID']}" \
    "&redirect_uri=#{ENV['HOSTNAME']}#{url_for '/slack_auth'}" \
    "&scope=#{SCOPES.join(',')}"
  end

  def slack_team_id
    params[:team_id]
  end

  def slack_team
    SlackTeam.find_by_team_id slack_team_id
  end

  def slack_users_list
    @slack_users_list ||= Rails.cache.fetch("slack/#{slack_team_id}/users", expires_in: 1.minutes) do
      slack_client(team_id: slack_team_id).users_list.members
    end
  end
end
