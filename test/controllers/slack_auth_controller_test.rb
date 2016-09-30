require 'test_helper'

class SlackAuthControllerTest < ActionDispatch::IntegrationTest
  test 'index' do
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

    assert_equal 'user name', session[:user_name]
    assert_equal 'userid', session[:user_id]
    assert_equal 'teamid', session[:team_id]
  end
end
