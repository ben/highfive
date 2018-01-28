class HighfiveRecord < ApplicationRecord
  belongs_to :slack_team
  attr_accessor :slack_users_info
  include SlackClient

  scope :in_last_day, -> { where('created_at > ?', Time.now - 24.hours) }
  scope :sent, -> { where(state: 'sent') }

  def slack_from
    slack_users_list(team_id: slack_team.team_id).find { |x| x.id == from } || FakeSlack::UserInfo.new(from)
  end

  def slack_to
    slack_users_list(team_id: slack_team.team_id).find { |x| x.id == to } || FakeSlack::UserInfo.new(to)
  end

  def to_name
    name_fallback slack_to
  end

  def from_name
    name_fallback slack_from
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << %w(date from to reason amount)

      all.each do |r|
        csv << [
          r.created_at.utc,
          r.slack_from.profile.email,
          r.slack_to.profile.email,
          r.reason,
          r.amount&.to_s(:currency) || '',
        ]
      end
    end
  end

  private

  def users_info
    @slack_users_info ||= slack_client(team_id: slack_team.team_id).users_list.members
  rescue Faraday::ConnectionFailed
    [FakeSlack::UserInfo.new('jdoe')]
  end

  def name_fallback(slack_user)
    slack_user.real_name.blank? ? slack_user.name : slack_user.real_name
  end
end
