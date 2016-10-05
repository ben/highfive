class AdminController < ApplicationController
  include AdminTeam
  before_action :requires_login, except: [:login, :slack_callback]

  def index
    @records = current_team.highfive_records.order(created_at: 'DESC')
    @records.each { |r| r.slack_users_info = slack_users_info }
  end

  def configuration
  end

  def tangocard
  end

  private

end
