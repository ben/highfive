require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test 'redirects to /login if not logged in' do
    get '/admin/'
    assert_response :redirect
  end
end
