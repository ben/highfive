class TangoCardJob < ApplicationJob
  queue_as :default
  include SlackClient
  include SlackRecordOwner

  def perform(record_id)
    @record = HighfiveRecord.find(record_id)

    fund_if_necessary

    sender_profile = slack_sender.profile
    recipient_profile = slack_recipient.profile
    resp = tango_client.send_card(
      slack_team.tango_customer_identifier,
      slack_team.tango_account_identifier,
      slack_team.tango_card_token,
      sender_profile&.first_name, sender_profile&.last_name, sender_profile&.email,
      recipient_profile&.first_name, recipient_profile&.last_name, recipient_profile&.email,
      @record.amount, @record.id, email_subject, email_message
    )

    @record.update_attributes(
      tango_reference_order_id: resp['referenceOrderID'],
      card_code: resp['reward']['credentials']['Claim Code']
    )

    GoogleTracker.event category: 'highfive',
                        action: 'sent',
                        label: slack_team.id,
                        value: @record.amount
  end

  def fund_if_necessary
    account_status = tango_client.get_account slack_team.tango_account_identifier
    balance = account_status['currentBalance']
    return if balance >= @record.amount

    fund_amount = (slack_team.award_limit || 150) * 5
    tango_client.fund_account(
      slack_team.tango_customer_identifier,
      slack_team.tango_account_identifier,
      slack_team.tango_card_token,
      fund_amount
    )
  end

  def email_subject
    'High Five!'
  end

  def email_message
    "High five for '#{@record.reason}'"
  end

end
