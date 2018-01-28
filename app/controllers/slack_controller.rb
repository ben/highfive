class SlackController < ApplicationController
  include SlackClient

  skip_before_action :verify_authenticity_token
  before_action :ssl_check, :verify_slack_token
  before_action :parse_command, only: :command

  def command
    # Payload from Slack API:
    # {
    #   "token"=>"QPzHTgsdiAM54POxbTdu5evY",
    #   "team_id"=>"T0HAGP0J2",
    #   "team_domain"=>"straubandfriends",
    #   "channel_id"=>"C2FJ4DZCN",
    #   "channel_name"=>"highfive",
    #   "user_id"=>"U0HAGH3AB",
    #   "user_name"=>"ben",
    #   "command"=>"/highfive",
    #   "text"=>"@ben $50 for stuff",
    #   "response_url"=>"https://hooks.slack.com/commands/T0HAGP0J2/85579917141/ToVvZJbtRCua2FVFjPihSSmf"
    # }
    amount = nil
    begin
      amount = Integer(params[:amount])
    rescue TypeError, ArgumentError
    end
    record = HighfiveRecord.create!(
      state: 'initial',
      slack_team: slack_team,
      from: params[:user_id],
      to: params[:target_user_id],
      reason: params[:reason],
      currency: 'USD',
      amount: amount,
      slack_response_url: params[:response_url],
    )
    highfive = HighfiveService::Highfive.new record
    render json: highfive.process!
    # render json: highfive.message
  end

  def interact
    # Payload from Slack API:
    # {
    #   "actions"=>[{"name"=>"confirm", "type"=>"button", "value"=>"yes"}],
    #   "callback_id"=>"66",
    #   "team"=>{"id"=>"T2SLQPU2W", "domain"=>"highfive-chat"},
    #   "channel"=>{"id"=>"C2SLJPMRD", "name"=>"general"},
    #   "user"=>{"id"=>"U2SLE6X2R", "name"=>"ben"},
    #   "action_ts"=>"1497494424.959961",
    #   "message_ts"=>"1497494263.000002",
    #   "attachment_id"=>"1",
    #   "token"=>"QPzHTgsdiAM54POxbTdu5evY",
    #   "is_app_unfurl"=>false,
    #   "response_url"=>"https://hooks.slack.com/actions/T2SLQPU2W/197985545363/RCqSzDbACOqeOvlj8o091dtd"
    # }
    record = HighfiveRecord.find(@json['callback_id'])
    highfive = HighfiveService::Highfive.new record
    send_card = @json['actions'][0]['value'] == 'yes'
    render json: highfive.process!(send_card)
    # render json: send_card ? card_confirmed : card_canceled
  end

  private

  def card_confirmed
    TangoCardJob.perform_later @record.id
    post_to_response_url(
      channel: @json['channel']['id'],
      response_type: 'in_channel',
      text: HighfiveService::Highfive::gif_response_for_record(@record)
    )
    {
      text: ':+1:'
    }
  end

  def card_canceled
    {
      text: ':disappointed: ok'
    }
  end

  def ssl_check
    head :ok if params[:ssl_check]
  end

  def verify_slack_token
    return if params[:token] == ENV['SLACK_VERIFICATION_TOKEN']
    @json = JSON.parse(params[:payload] || '{}')
    return if @json['token'] == ENV['SLACK_VERIFICATION_TOKEN']
    head :unauthorized
  end

  def parse_command
    command_regex = /@(\w+)(?:\s+\$(\S+))?(?:\s+for)?\s+(.*)/
    cards_enabled = slack_team.tangocard?
    return render(json: SlackMessages.usage(cards_enabled)) if params[:text].chomp.downcase == 'help'
    return render(json: SlackMessages.stats_link) if params[:text].chomp.downcase == 'stats'
    m = command_regex.match params[:text]
    return render(json: SlackMessages.unrecognized) unless m
    params[:target_user_id] = slack_user_by_name(m[1]).id
    params[:amount] = m[2]
    params[:reason] = m[3]
  end

end
