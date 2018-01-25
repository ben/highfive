class HighfiveRecord < ApplicationRecord
  belongs_to :slack_team
  attr_accessor :slack_users_info
  include SlackClient

  scope :in_last_day, -> { where('created_at > ?', Time.now - 24.hours) }
  scope :sent, -> { where(state: 'sent') }

  def slack_from
    users_info.find { |x| x.id == from } || FakeSlack::UserInfo.new(from)
  end

  def slack_to
    users_info.find { |x| x.id == to } || FakeSlack::UserInfo.new(to)
  end

  private

  def users_info
    @slack_users_info ||= slack_client(team_id: slack_team.team_id).users_list.members
  rescue Faraday::ConnectionFailed
    [FakeSlack::UserInfo.new('jdoe')]
  end
end
