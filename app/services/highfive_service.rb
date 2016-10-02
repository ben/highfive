module HighfiveService
  class Highfive
    include SlackClient

    def initialize(slack_team, sender, recipient, reason, amount = nil)
      @slack_team = slack_team
      @sender = sender
      @recipient = recipient
      @reason = reason
      @amount = amount
    end

    def message
      self_rebuke if slack_sender.id == slack_recipient.id
    end

    private

    def slack_users_list
      @slack_users_list ||= slack_client(team_id: @slack_team.team_id).users_list
    end

    def slack_sender
      slack_users_list.find { |u| @sender.in? [u.id, u.name] }
    end

    def slack_recipient
      slack_users_list.find { |u| @recipient.in? [u.id, u.name] }
    end

    def self_rebuke
      { text: "High-fiving yourself is just clapping." }
    end
  end
end
