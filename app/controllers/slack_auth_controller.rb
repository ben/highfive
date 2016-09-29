class SlackAuthController < ApplicationController
  def index
    # Just got a callback from Slack; send it to the API to get auth info
    resp = Slack::Web::Client.new.oauth_access(
      client_id: ENV['SLACK_CLIENT_ID'],
      client_secret: ENV['SLACK_CLIENT_SECRET'],
      code: params[:code]
    )
    if 'commands'.in? resp.scope
      byebug
      # TODO: create or find team record from resp.team.id, insert resp.access_token
    elsif 'identity'.in? resp.scope
      session[:user_name] = resp.user.name
      session[:user_id] = resp.user.id
      session[:team_id] = resp.team.id
    else
      flash[:warning] = add_app_message
    end
    redirect_to '/admin'
  end

  private

  def add_app_message
    "I'm having trouble finding your team. Have you " \
    "<a href=\"#{add_app_url}\">added the app</a>?"
  end
end
