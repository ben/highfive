require 'test_helper'

class SlackControllerTest < ActionDispatch::IntegrationTest
  def body
    JSON.parse response.body
  end

  setup do
    mock_users_list
  end

  test 'ssl check' do
    post '/slack/command', params: { ssl_check: true }
    assert_response :success
  end

  test 'slack token check for command' do
    post '/slack/command', params: {
      token: 'not a match'
    }
    assert_response :unauthorized
  end

  test 'slack token check for interaction' do
    post '/slack/interact', params: {
      payload: JSON.dump(token: 'not a match')
    }
    assert_response :unauthorized
  end

  test 'happy path for command' do
    post '/slack/command', params: {
      token: ENV['SLACK_VERIFICATION_TOKEN'],
      user_id: 'useroneid',
      text: '@usertwo for bar',
      team_id: slack_teams(:one).team_id
    }
    assert_equal 'in_channel', body['response_type']
    assert_includes body['text'], '<!channel>'
    assert_includes body['text'], '<@usertwoid>'
  end

  test 'badly formatted command' do
    post '/slack/command', params: {
      token: ENV['SLACK_VERIFICATION_TOKEN'],
      user_id: 'userid',
      text: 'what is this thing'
    }
    assert_includes [nil, 'ephemeral'], body['response_type']
    assert_includes body['text'], '`/highfive @user for (reason)`'
  end

  test 'stats command' do
    ['stats', 'admin'].each do |cmd|
      post '/slack/command', params: {
        token: ENV['SLACK_VERIFICATION_TOKEN'],
        user_id: 'userid',
        text: 'stats'
      }
      assert_includes [nil, 'ephemeral'], body['response_type']
      assert_includes body['text'], '/admin'
    end
  end
end
