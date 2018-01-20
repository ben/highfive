class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :ssl_check, :verify_slack_token
  before_action :parse_command, only: :command

  def command
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
    highfive = HighfiveService::Highfive.new slack_team, params
    highfive.commit!
    render json: highfive.message
  end

  def interact
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
    send_card = @json['actions'][0]['value'] === 'yes'
    @record = HighfiveRecord.find(@json['callback_id'])
    render json: send_card ? card_confirmed : card_canceled
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
    @json = JSON.parse(params[:payload] || '"{}"')
    return if @json['token'] == ENV['SLACK_VERIFICATION_TOKEN']
    head :unauthorized
  end

  def parse_command
    # TODO: help output
    return render(json: link) if /help|stats/.match params[:text]
    m = /@(\w+)(?:\s+\$(\S+))?(?:\s+for)?\s+(.*)/.match params[:text]
    return render(json: usage) unless m
    params[:target_user_id] = m[1]
    params[:amount] = m[2]
    params[:reason] = m[3]
  end

  def usage
    {
      text: "Hmm, I couldn't understand that. Try `/highfive @user for (reason)`."
    }
  end

  def link
    {
      text: "Visit the <#{ENV['HOSTNAME']}/admin|Highfive site> for info on your team's activity."
    }
  end

  def post_to_response_url(payload)
    conn = Faraday.post(@record.slack_response_url, JSON.dump(payload))

  end

  def slack_team
    SlackTeam.find_by_team_id params[:team_id]
  end
end
