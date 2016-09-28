class AdminController < ApplicationController
  before_action :requires_login, except: [:login, :slack_callback]

  def index
  end

  def login
  end

  def slack_callback
    auth_hash = request.env['omniauth.auth']
    team_id = auth_hash.team_id
    token = auth_hash.credentials.token
    render json: {team: team_id, token: token}
  end

  def configuration
  end

  private

  def requires_login
    redirect_to '/admin/login' unless logged_in?
  end

  def logged_in?
    false
  end

end
