class SlackAuthController < ApplicationController
  def index
    # Just got a callback from Slack; send it to the API to get auth info
    resp = Slack::Web::Client.new.oauth_access(
      client_id: ENV['SLACK_CLIENT_ID'],
      client_secret: ENV['SLACK_CLIENT_SECRET'],
      code: params[:code]
    )

    user_id = resp[:user_id] || resp[:user][:id]
    team_id = resp[:team_id] || resp[:team][:id]
    team = SlackTeam.where(team_id: team_id).first_or_initialize
    team.access_token = resp[:access_token]

    resp = Slack::Web::Client.new(token: team.access_token).team_info
    team.team_subdomain = resp.team.domain
    team.team_name = resp.team.name

    team.save

    session[:user_id] = user_id
    session[:team_id] = team_id

    redirect_to '/admin'
  end

  private

  def add_app_message
    "I'm having trouble finding your team. Have you " \
    "<a href=\"#{add_app_url}\">added the app</a>?"
  end
end
