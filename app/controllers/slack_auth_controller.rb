class SlackAuthController < ApplicationController
  def index
    # Just got a callback from Slack; send it to the API to get auth info
    resp = Slack::Web::Client.new.oauth_access(
      client_id: ENV['SLACK_CLIENT_ID'],
      client_secret: ENV['SLACK_CLIENT_SECRET'],
      code: params[:code]
    )
    if resp.key? :team_id
      # Return flow from "add application" action; record team ID and token
      team = SlackTeam.where(team_id: resp[:team_id]).first_or_initialize
      team.access_token = resp[:access_token]
      team.save
    elsif resp.key? :team
      # Return flow from login action; store user info in session
      session[:user_name] = resp[:user][:name]
      session[:user_id] = resp[:user][:id]
      session[:team_id] = resp[:team][:id]

      unless SlackTeam.find_by_team_id(resp[:team][:id])
        flash[:warning] = add_app_message
      end
    end
    redirect_to '/admin'
  end

  private

  def add_app_message
    "I'm having trouble finding your team. Have you " \
    "<a href=\"#{add_app_url}\">added the app</a>?"
  end
end
