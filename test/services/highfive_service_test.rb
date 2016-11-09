require 'test_helper'
require_relative '../../app/services/highfive_service'

module HighfiveService
  class HighfiveServiceTest < ActiveSupport::TestCase
    fixtures :slack_teams

    setup do
      mock_users_list
      mock_tango_api
    end

    def msg(sender, recipient, reason: 'foo bar baz', amount: nil)
      @highfive = Highfive.new(slack_teams(:one), sender, recipient, reason, amount)
      @highfive.commit!
      @highfive.message
    end

    def card(*args)
      msg(*args)
      @highfive.send_card!
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

    test 'with an amount' do
      response = msg(USERONE.id, USERTWO.name, amount: 20)
      assert_equal 'in_channel', response[:response_type]
      assert_includes response[:text], USERONE.id
      assert_includes response[:text], USERTWO.id
      assert_includes response[:text], 'foo bar baz'
      record = HighfiveRecord.last
      assert_equal record.from, USERONE.id
      assert_equal record.to, USERTWO.id
      assert_equal record.reason, 'foo bar baz'
      assert_equal record.amount, 20.00
    end

    test 'sending a gift card' do
      card(USERONE.id, USERTWO.name, amount: 20)
    end
  end
end
