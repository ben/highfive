require 'test_helper'
require_relative '../../app/services/highfive_service'

USERONE = {
  id: 'useroneid',
  team: 'teamone',
  name: 'userone'
}.to_dot

USERTWO = {
  id: 'usertwoid',
  team: 'teamone',
  name: 'usertwo'
}.to_dot

module HighfiveService
  class HighfiveServiceTest < ActiveSupport::TestCase
    fixtures :slack_teams

    setup do
      mock_users_list
    end

    def msg(sender, recipient, reason = 'foo bar baz')
      Highfive.new(slack_teams(:one), sender, recipient, reason).message
    end

    test 'success' do
      response = msg(USERONE.id, USERTWO.name)
      assert_equal 'in_channel', response[:response_type]
      assert_includes response[:text], USERONE.id
      assert_includes response[:text], USERTWO.id
      assert_includes response[:text], 'foo bar baz'
      record = HighfiveRecord.last
      assert_equal record.from, USERONE.id
      assert_equal record.to, USERTWO.id
      assert_equal record.reason, 'foo bar baz'
    end

    test 'highfiving yourself' do
      assert_includes msg('userone', 'userone')[:text], 'clapping'
      assert_equal 0, HighfiveRecord.where(from: USERONE.id, to: USERONE.id).count
    end
  end
end
