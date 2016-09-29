class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :ssl_check, :verify_slack_token

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
    # team = SlackTeam.find_by_team_id params[:team_id]

    render json: {
      text: "<!channel> <@#{params[:user_id]}> is high-fiving!"
    }
  end

  def interact
  end

  private

  def ssl_check
    head :ok if params[:ssl_check]
  end

  def verify_slack_token
    puts "!!! #{params[:token]}"
    head :unauthorized unless params[:token] == ENV['SLACK_VERIFICATION_TOKEN']
  end
end
