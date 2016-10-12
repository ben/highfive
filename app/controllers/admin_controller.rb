class AdminController < ApplicationController
  include AdminTeam
  before_action :requires_login, :fetch_tangocard_info

  def index
    @records = current_team.highfive_records.order(created_at: 'DESC')
    @records.each { |r| r.slack_users_info = slack_users_info }
  end

  def configuration
    @first, @last = current_user_info.real_name.split(' ')
    @email = current_user_info.profile.email
  end

  private

  def fetch_tangocard_info
    @tango_account ||= Tangocard::Client.new.get_account(current_team.tango_account_identifier) \
      if current_team.tango_account_identifier.present?
  rescue Faraday::ConnectionFailed
    {}
  end
end
