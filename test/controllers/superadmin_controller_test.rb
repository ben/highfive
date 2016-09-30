require 'test_helper'

class SuperadminControllerTest < ActionDispatch::IntegrationTest
  fixtures :slack_teams

  setup do
    post '/superadmin/login_attempt', params: { password: ENV['SUPERADMIN_PASSWORD'] }
  end

  test 'impersonating' do
    post '/superadmin/impersonate', params: { team_id: slack_teams(:one).team_id }
    assert_redirected_to '/admin'
    assert_equal session[:team_id], slack_teams(:one).team_id
  end
end
