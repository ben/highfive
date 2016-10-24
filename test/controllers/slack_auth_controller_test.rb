require 'test_helper'

class SlackAuthControllerTest < ActionDispatch::IntegrationTest
  def stub_slack_api(oauth_access_return = nil)
    oauth_access_return ||= {
      user_id: 'userone',
      team_id: 'teamid',
      access_token: 'token',
      scope: 'a,b,c'
    }
    Slack::Web::Client.any_instance.stubs(:oauth_access).returns(oauth_access_return)
    Slack::Web::Client.any_instance.stubs(:team_info).returns(
      team: {
        name: 'team name',
        domain: 'teamdomain'
      }
    )

  end

  test 'return from login action' do
    stub_slack_api(
      user: {
        id: 'userid'
      },
      team: {
        id: 'teamid'
      }
    )

    get '/slack_auth', params: { code: 123 }

    assert_equal 'userid', session[:user_id]
    assert_equal 'teamid', session[:team_id]
  end

  test 'return from add-app action' do
    stub_slack_api

    get '/slack_auth', params: { code: 123 }

    team = SlackTeam.find_by_team_id 'teamid'
    assert_equal 'token', team.access_token
  end

  test 'updating team token' do
    SlackTeam.create! team_id: 'teamid', access_token: 'one'
    stub_slack_api

    get '/slack_auth', params: { code: 123 }

    team = SlackTeam.find_by_team_id 'teamid'
    assert_equal 'token', team.access_token
  end
end
