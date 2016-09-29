class SlackController < ApplicationController
  skip_before_filter :verify_authenticity_token

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
    team = 
    render(json: 'ok') if params[:ssl_check]
  end

  def interact
    render(json: 'ok') if params[:ssl_check]
  end
end
