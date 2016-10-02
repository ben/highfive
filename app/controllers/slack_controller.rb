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
    # team = SlackTeam.find_by_team_id params[:team_id]

    highfive = HighfiveService::Highfive.new slack_team, params[:user_id], params[:target_user_id], params[:reason], params[:amount]
    render json: highfive.message
  end

  def interact
    # TODO when confirmation is needed
  end

  private

  def ssl_check
    head :ok if params[:ssl_check]
  end

  def verify_slack_token
    head :unauthorized unless params[:token] == ENV['SLACK_VERIFICATION_TOKEN']
  end

  def parse_command
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

  def slack_team
    SlackTeam.find_by_team_id params[:team_id]
  end
end
