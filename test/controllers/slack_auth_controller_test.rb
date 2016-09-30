require 'test_helper'

class SlackAuthControllerTest < ActionDispatch::IntegrationTest
  test 'records login info in session' do
    get '/slack_auth', {
      user: { name: 'user name', id: 'userid' },
      team: { id: 'teamid' }
    }

    assert_equal session[:user_name], 'user name'
    assert_equal session[:user_id], 'userid'
    assert_equal session[:team_id], 'teamid'
  end
  # test "the truth" do
  #   assert true
  # end
end
