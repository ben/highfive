require 'test_helper'

class SlackAuthControllerTest < ActionDispatch::IntegrationTest
  test 'return from login action' do
    Slack::Web::Client.any_instance.stubs(:oauth_access).returns(
      user: {
        id: 'userid',
        name: 'user name'
      },
      team: {
        id: 'teamid'
      }
    )

    get '/slack_auth', params: { code: 123 }

    assert_equal 'userid', session[:user_id]
    assert_equal 'teamid', session[:team_id]
    assert_not_nil flash[:warning]
  end

  test 'return from add-app action' do
    Slack::Web::Client.any_instance.stubs(:oauth_access).returns(
      team_id: 'teamid',
      access_token: 'token'
    )

    get '/slack_auth', params: { code: 123 }

    team = SlackTeam.find_by_team_id 'teamid'
    assert_equal 'token', team.access_token
  end

  test 'updating team token' do
    SlackTeam.create! team_id: 'teamid', access_token: 'one'
    Slack::Web::Client.any_instance.stubs(:oauth_access).returns(
      team_id: 'teamid',
      access_token: 'two'
    )

    get '/slack_auth', params: { code: 123 }

    team = SlackTeam.find_by_team_id 'teamid'
    assert_equal 'two', team.access_token
  end
end
