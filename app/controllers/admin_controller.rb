class AdminController < ApplicationController
  include AdminTeam
  before_action :requires_login, :fetch_tangocard_info

  def index
    @records = current_team.highfive_records.sent.order(created_at: 'DESC').paginate(page: params[:page], per_page: 30)
    @records.each { |r| r.slack_users_info = slack_users_info }

    respond_to do |format|
      format.html
      format.csv { send_data @records.to_csv, filename: "highfives-#{Date.today}.csv" }
    end
  end

  def configuration
    @first, @last = current_user_info.real_name.split(' ')
    @email = current_user_info.profile.email
    current_team.award_limit ||= 150
    current_team.daily_limit ||= 500
    current_team.double_rate ||= 10
    current_team.boomerang_rate ||= 10
  end

  private

  def fetch_tangocard_info
    @tango_account ||= Tangocard::Client.new.get_account(current_team.tango_account_identifier) \
      if current_team.tango_account_identifier.present?
  rescue Faraday::ConnectionFailed
    {}
  end
end
