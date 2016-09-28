class SlackController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def command
    render json: 'ok'
  end

  def interact
    render json: 'ok'
  end
end
