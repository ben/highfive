module SlackClient
  def slack_client(team_id: nil)
    team = SlackTeam.find_by_team_id(team_id || session[:team_id] || params[:team_id] || @json['team']['id'])
    Slack::Web::Client.new(token: team.access_token)
  end
end
