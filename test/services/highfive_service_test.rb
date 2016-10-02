require 'test_helper'
require_relative '../../app/services/highfive_service'

USERONE = {
  id: 'userone',
  team: 'teamone',
  name: 'userone'
}.to_dot

USERTWO = {
  id: 'usertwo',
  team: 'teamone',
  name: 'usertwo'
}.to_dot

module HighfiveService
  class HighfiveServiceTest < ActiveSupport::TestCase
    setup do
      Slack::Web::Client
        .any_instance
        .expects(:users_list)
        .returns([USERONE, USERTWO])
    end

    def msg(sender, recipient, reason='foo bar baz')
      Highfive.new(slack_teams(:one), sender, recipient, reason).message
    end

    test 'highfiving yourself' do
      assert_includes msg('userone', 'userone')[:text], 'clapping'
    end
  end
end
