module SlackClient
  @@user_list_cache = {}

  def slack_client(team_id: nil)
    @team_id = team_id || slack_team_id || session[:team_id] || params[:team_id] || @json['team']['id']
    team = SlackTeam.find_by_team_id(@team_id)
    Slack::Web::Client.new(token: team.access_token)
  end

  def slack_user_by_name(name)
    slack_users_list.find { |u| u.name == name }
  end

  def slack_users_list(team_id: @team_id)
    @@user_list_cache[team_id] ||= Rails.cache.fetch("slack/#{@team_id}/users", compress: true, expires_in: 1.minutes) do
      slack_client(team_id: team_id).users_list.members
    end
  end
end
