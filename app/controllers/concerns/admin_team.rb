module AdminTeam
  extend ActiveSupport::Concern

  included do
    helper_method :slack_users_info, :current_user_info, :current_team
  end

  def slack_users_info
    @slack_user_info ||= slack_client.users_list.members
  rescue Slack::Web::Api::Error
    # Token was probably revoked; clear the DB record and the session, the user
    # will have to auth again
    SlackTeam.where(team_id: session[:team_id]).update! access_token: nil,
                                                        team_name: nil,
                                                        team_subdomain: nil
    session.delete :user_id
    session.delete :team_id
    redirect_to slack_login_url
  rescue Faraday::ConnectionFailed
    [FakeSlack::UserInfo.new('jdoe')]
  end

  def current_user_info
    slack_users_info.find { |u| u.id == session[:user_id] } || FakeSlack::UserInfo.new(session[:user_id])
  end

  def current_team
    @current_team ||= SlackTeam.find_by_team_id session[:team_id]
  end

  def requires_login
    redirect_to slack_login_url unless logged_in?
  end

  def logged_in?
    session.key? 'team_id'
  end
end
