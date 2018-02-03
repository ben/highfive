class TangoCardJob < ApplicationJob
  queue_as :default
  include SlackRecordOwner

  def perform(record_id)
    @record = HighfiveRecord.find(record_id)
    @highfive = HighfiveService::Highfive.new(@record)

    unless fund_if_necessary
      post_response @highfive.process!(:funding_failed)
      return
    end

    sender_profile = slack_sender.profile
    recipient_profile = slack_recipient.profile
    puts "INFO: Team #{slack_team.team_id} sending card for #{@record.amount} from #{slack_sender.id} to #{slack_recipient.id}"
    resp = tango_client.send_card(
      slack_team.tango_customer_identifier,
      slack_team.tango_account_identifier,
      slack_team.tango_card_token,
      sender_profile&.first_name, sender_profile&.last_name, sender_profile&.email,
      recipient_profile&.first_name, recipient_profile&.last_name, recipient_profile&.email,
      @record.amount, @record.id, email_subject, email_message
    )

    if resp['errors']
      puts "ERROR: Team #{slack_team.team_id} failed to send card: #{resp}"
      post_response @highfive.process!(:failed_to_send)
    else
      puts "INFO: Team #{slack_team.team_id} card sent!"
      @record.update_attributes(
        tango_reference_order_id: resp['referenceOrderID'],
        card_code: resp['reward']['credentials']['Claim Code']
      )
      post_response @highfive.process!(:sent)
      GoogleTracker.event category: 'highfive',
                          action: 'sent',
                          label: slack_team.id,
                          value: @record.amount
    end
  end

  def fund_if_necessary
    account_status = tango_client.get_account slack_team.tango_account_identifier
    balance = account_status['currentBalance']
    puts "INFO: Team #{slack_team.team_id} has #{balance} in their account"
    return true if balance >= @record.amount

    fund_amount = (slack_team.award_limit || 150) * 5
    puts "INFO: Team #{slack_team.team_id} funding #{fund_amount}..."
    resp = tango_client.fund_account(
      slack_team.tango_customer_identifier,
      slack_team.tango_account_identifier,
      slack_team.tango_card_token,
      fund_amount
    )
    pp resp

    Funding.create!(
      slack_team: slack_team,
      highfive_record: @record,
      amount: fund_amount,
      payload: resp
    )

    if resp['errors']
      Rails.logger.error "ERROR: Team #{slack_team.team_id} failed to fund: #{resp}"
      false
    else
      Rails.logger.info "INFO: Team #{slack_team.team_id} funding succeeded!"
      true
    end
  end

  private

  def email_subject
    'High Five!'
  end

  def email_message
    "High five for ‘#{@record.reason.gsub(/[']/, '')}’"
  end

  def post_response(message)
    conn = Faraday.post(@record.slack_response_url, JSON.dump(message))
  end

end
