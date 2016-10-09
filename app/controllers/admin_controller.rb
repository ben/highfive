class AdminController < ApplicationController
  include AdminTeam
  before_action :requires_login, :fetch_tangocard_info

  def index
    @records = current_team.highfive_records.order(created_at: 'DESC')
    @records.each { |r| r.slack_users_info = slack_users_info }
  end

  def configuration
  end

  private

  def fetch_tangocard_info
    @tango_account = Tangocard::Client.new.get_account(current_team.tango_account_identifier) \
      if current_team.tango_account_identifier.present?
  end
end
