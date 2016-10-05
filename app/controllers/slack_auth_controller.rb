class SlackAuthController < ApplicationController
  def index
    # Just got a callback from Slack; send it to the API to get auth info
    resp = Slack::Web::Client.new.oauth_access(
      client_id: ENV['SLACK_CLIENT_ID'],
      client_secret: ENV['SLACK_CLIENT_SECRET'],
      code: params[:code]
    )

    team_id = resp[:team_id] || resp[:team][:id]
    user_id = resp[:user_id] || resp[:user][:id]

    team = SlackTeam.where(team_id: team_id).first_or_initialize
    team.access_token = resp[:access_token]
    team.team_name = resp[:team_name]
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
