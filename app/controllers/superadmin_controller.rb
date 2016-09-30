class SuperadminController < ApplicationController
  before_action :requires_login, except: [:login, :login_attempt]

  def index
    @teams = SlackTeam.all
  end

  def login
  end

  def login_attempt
    if params[:password] == (ENV['SUPERADMIN_PASSWORD'] || '')
      session[:superadmin] = true
    end
    redirect_to '/superadmin'
  end

  def impersonate
    team = SlackTeam.find_by_team_id params[:team_id]
    session[:team_id] = team.team_id
    redirect_to '/admin'
  end

  private

  def requires_login
    redirect_to '/superadmin/login' unless logged_in?
  end

  def logged_in?
    session[:superadmin] == true
  end
end
