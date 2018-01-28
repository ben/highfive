# Assumes exisntence of @record
module SlackRecordOwner
  include SlackClient

  def slack_sender
    slack_users_list(team_id: @record.slack_team.team_id).find { |u| @record.from == u.id }
  end

  def slack_recipient
    slack_users_list(team_id: @record.slack_team.team_id).find { |u| @record.to == u.id }
  end

  def slack_team
    @record.slack_team
  end

  def tango_client
    @tango_client ||= Tangocard::Client.new
  end
end
