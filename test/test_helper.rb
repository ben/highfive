ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest-spec-rails'
require 'webmock/minitest'
require "minitest/unit"
require "mocha/mini_test"

require 'hash_dot'
Hash.use_dot_syntax = true

USERONE = {
  id: 'useroneid',
  team: 'teamone',
  name: 'userone'
}

USERTWO = {
  id: 'usertwoid',
  team: 'teamone',
  name: 'usertwo'
}

def mock_users_list
  Slack::Web::Client
    .any_instance
    .expects(:users_list)
    .at_least(0)
    .returns({members: [USERONE, USERTWO]})
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
