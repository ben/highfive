module SlackRecordOwner
  def slack_users_list
    @slack_users_list ||= slack_client(team_id: slack_team.team_id).users_list.members
  end

  def slack_sender
    slack_users_list.find { |u| @record.from == u.id }
  end

  def slack_recipient
    slack_users_list.find { |u| @record.to == u.id }
  end

  def slack_team
    @record.slack_team
  end

  def tango_client
    @tango_client ||= Tangocard::Client.new
  end
end
