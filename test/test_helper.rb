ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest-spec-rails'
require 'webmock/minitest'
require "minitest/unit"
require "mocha/mini_test"

require 'hash_dot'
Hash.use_dot_syntax = true

class FakeUser
  attr_reader :id, :team, :name, :is_bot, :profile

  def initialize(id, name, team: 'teamone', is_bot: false, email: nil)
    @id = id
    @name = name
    @team = team
    @is_bot = is_bot
    @profile = {
      first_name: name,
      last_name: name,
      email: email || "#{@name}@example.com"
    }.to_dot
  end
end

USERONE = FakeUser.new 'useroneid', 'userone'
USERTWO = FakeUser.new 'usertwoid', 'usertwo'

def mock_users_list
  Slack::Web::Client
    .any_instance
    .expects(:users_list)
    .at_least(0)
    .returns({members: [USERONE, USERTWO]})
end

def mock_tango_api(balance: 200)
  @currentBalance = balance
  stub_request(:get, "http://example.com/accounts/").
    to_return(body: {currentBalance: @currentBalance}.to_json)
  stub_request(:post, "http://example.com/creditCardDeposits").
    to_return(lambda { |request|
      body = JSON.parse(request.body)
      @currentBalance += body['amount']
      {ok: true}.to_json
    })
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
