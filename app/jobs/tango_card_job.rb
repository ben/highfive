class TangoCardJob < ApplicationJob
  queue_as :default
  include SlackClient

  def perform(record_id)
    @record = HighfiveRecord.find(record_id)

    fund_if_necessary

    sender_profile = slack_sender.profile
    recipient_profile = slack_recipient.profile
    resp = tango_client.send_card(
      @slack_team.tango_customer_identifier,
      @slack_team.tango_account_identifier,
      @slack_team.tango_card_token,
      sender_profile&.first_name, sender_profile&.last_name, sender_profile&.email,
      recipient_profile&.first_name, recipient_profile&.last_name, recipient_profile&.email,
      @amount, @record.id, email_subject, email_message
    )

    # TODO: referenceOrderID, reward['credentials']['Claim Code']
    # @record.update_columns {
    # }

    GoogleTracker.event category: 'highfive',
                        action: 'sent',
                        label: @slack_team.id,
                        value: @record.amount
    resp
  end

  def fund_if_necessary
    account_status = tango_client.get_account @slack_team.tango_account_identifier
    balance = account_status['currentBalance']
    return if balance >= @amount

    fund_amount = (@slack_team.award_limit || 150) * 5
    tango_client.fund_account(
      @slack_team.tango_customer_identifier,
      @slack_team.tango_account_identifier,
      @slack_team.tango_card_token,
      fund_amount
    )
  end

  def slack_users_list
    @slack_users_list ||= slack_client(team_id: @slack_team.team_id).users_list.members
  end

  def slack_sender
    slack_users_list.find { |u| @record.sender.in? [u.id, u.name] }
  end

  def slack_recipient
    slack_users_list.find { |u| @recipient.in? [u.id, u.name] }
  end

  def slack_team
    @record.slack_team
  end
end
