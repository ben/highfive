PAGE_SIZE = 30

class AdminController < ApplicationController
  include AdminTeam
  before_action :requires_login, :fetch_tangocard_info

  def index
    @records = current_team.highfive_records.sent.order(created_at: :desc).paginate(page: params[:highfives_page], per_page: PAGE_SIZE)
    @records.each { |r| r.slack_users_info = slack_users_info }
    @fundings = current_team.fundings.order(created_at: :desc).paginate(page: params[:fundings_page], per_page: PAGE_SIZE)
  end

  def highfives
    @records = current_team.highfive_records.sent.order(created_at: :desc)
    respond_to do |format|
      format.csv { send_data @records.to_csv, filename: "highfives-#{Date.today}.csv" }
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"highfives-#{Date.today}.xlsx\""
      }
    end
  end

  def fundings
    @fundings = current_team.fundings.order(created_at: :desc)
    respond_to do |format|
      format.csv { send_data @fundings.to_csv, filename: "funding-#{Date.today}.csv" }
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=\"funding-#{Date.today}.xlsx\""
      end
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
