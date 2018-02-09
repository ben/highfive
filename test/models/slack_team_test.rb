require 'test_helper'

describe SlackTeam do
  describe :daily_total do
    before do
      @team = slack_teams(:one)
      HighfiveRecord.create! slack_team: @team, amount: 30, created_at: 12.hours.ago, state: :sent
      HighfiveRecord.create! slack_team: @team, amount: 30, created_at: 48.hours.ago, state: :sent
    end

    it 'only includes records in the last 24 hours' do
      @team.daily_total.must_equal 45 # including the fixture
    end
  end

  describe :tangocard? do
    it 'reflects whether a team has tangocard configured' do
      slack_teams(:one).tangocard?.must_equal true
      slack_teams(:two).tangocard?.must_equal false
    end
  end
end
