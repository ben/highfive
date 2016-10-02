class SlackAuthController < ApplicationController
  def index
    # Just got a callback from Slack; send it to the API to get auth info
    resp = Slack::Web::Client.new.oauth_access(
      client_id: ENV['SLACK_CLIENT_ID'],
      client_secret: ENV['SLACK_CLIENT_SECRET'],
      code: params[:code]
    )

    team_id = resp.try(:team_id) || resp.try(:team).try(:id)
    user_id = resp.try(:user_id) || resp.try(:user).try(:id)

    team = SlackTeam.where(team_id: team_id).first_or_initialize
    team.access_token = resp[:access_token]
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
