require 'test_helper'
require_relative '../../app/services/highfive_service'

module HighfiveService
  class HighfiveServiceTest < ActiveSupport::TestCase
    fixtures :slack_teams

    setup do
      stub_slack_client
      mock_tango_api
    end

    def msg(sender, recipient, reason: 'foo bar baz', amount: '', response_url: nil, team: :one)
      slack_team = slack_teams(team)
      @record = HighfiveRecord.new(
        state: 'initial',
        slack_team: slack_team,
        from: sender.id,
        to: recipient.id,
        reason: reason,
        amount: amount,
        currency: 'USD',
        slack_response_url: response_url
      )
      @highfive = Highfive.new(@record)
      @highfive.process!
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
      assert_equal 'invalid', @record.state
    end

    test 'with an amount but tango disabled' do
      response = msg(USERONE, USERTWO, amount: 20, team: :two)
      assert_includes response[:text], 'not enabled'
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

    test 'with too large an amount' do
      response = msg(USERONE, USERTWO, amount: 1000)
      assert_equal 'ephemeral', response[:response_type]
      assert_includes response[:text], "can't send cards for more than $100."
      assert_equal 'invalid', @record.state
    end
  end
end
