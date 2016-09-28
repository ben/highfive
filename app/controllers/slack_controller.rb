class SlackController < ApplicationController
  def admin_login
    render json: params
  end

  def incoming_event
  end
end
