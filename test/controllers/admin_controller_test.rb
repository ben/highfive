require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test 'redirects to /login if not logged in' do
    get '/admin/'
    assert_response :redirect
  end

  test 'highfives.csv sends a file' do
    stub_slack_client
    get '/slack_auth', params: {code: '2345'}
    get '/admin/highfives.csv'
    assert_response :success
    @response.headers['Content-Disposition'].must_match /attachment.*csv/
    @response.body.must_match /date,from,to,reason,amount/
  end

  test 'highfives.xlsx sends a file' do
    stub_slack_client
    get '/slack_auth', params: {code: '2345'}
    get '/admin/highfives.xlsx'
    assert_response :success
    @response.headers['Content-Disposition'].must_match /attachment.*xlsx/
  end

  test 'fundings.csv sends a file' do
    stub_slack_client
    get '/slack_auth', params: {code: '2345'}
    get '/admin/fundings.csv'
    assert_response :success
    @response.headers['Content-Disposition'].must_match /attachment.*csv/
    @response.body.must_match /date,amount,success,response payload/
  end

  test 'fundings.xlsx sends a file' do
    stub_slack_client
    get '/slack_auth', params: {code: '2345'}
    get '/admin/fundings.xlsx'
    assert_response :success
    @response.headers['Content-Disposition'].must_match /attachment.*xlsx/
  end
end
