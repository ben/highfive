require 'test_helper'
require_relative '../../app/services/highfive_service'

module HighfiveService
  class HighfiveServiceTest < ActiveSupport::TestCase
    fixtures :slack_teams

    setup do
      mock_users_list
      mock_tango_api
    end

    def msg(sender, recipient, reason: 'foo bar baz', amount: '', response_url: nil)
      @highfive = Highfive.new(
        slack_teams(:one),
        user_id: sender.id,
        target_user_id: recipient.id,
        reason: reason,
        amount: amount,
        response_url: response_url
      )
      @highfive.commit!
      @highfive.message
    end

    def card(*args)
      msg(*args)
      @highfive.send_card!
    end

    test 'success' do
      response = msg(USERONE, USERTWO)
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
      assert_includes msg(USERONE, USERONE)[:text], 'clapping'
      assert_equal 0, HighfiveRecord.where(from: USERONE.id, to: USERONE.id).count
    end

    test 'with an amount' do
      response = msg(USERONE, USERTWO, amount: 20)
      assert_equal 'ephemeral', response[:response_type]
      assert_includes response[:text], USERTWO.id
      assert_includes response[:text], 'about to send'
      record = HighfiveRecord.last
      assert_equal record.from, USERONE.id
      assert_equal record.to, USERTWO.id
      assert_equal record.reason, 'foo bar baz'
      assert_equal record.amount, 20.00
    end
  end
end
