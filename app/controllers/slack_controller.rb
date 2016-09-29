class SlackController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def command
    render(json: 'ok') if params[:ssl_check]
  end

  def interact
    render(json: 'ok') if params[:ssl_check]
  end
end
