require 'test_helper'
require_relative '../../app/services/highfive_service'

module HighfiveService
  class HighfiveServiceTest < ActiveSupport::TestCase
    setup do
      stub_slack_client
      mock_tango_api
    end

    def msg(sender, recipient, reason: 'foo bar baz', amount: '', response_url: nil, team: :one, state: 'initial', input: nil)
      slack_team = slack_teams(team)
      @record = HighfiveRecord.new(
        state: state,
        slack_team: slack_team,
        from: sender.id,
        to: recipient.id,
        reason: reason,
        amount: amount,
        currency: 'USD',
        slack_response_url: response_url
      )
      @highfive = Highfive.new(@record)
      @highfive.process!(input)
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

    test 'confirming a card' do
      response = msg(USERONE, USERTWO, amount: 10, state: 'confirm', input: true)
      assert_equal 'ephemeral', response[:response_type]
      assert_includes response[:text], ":+1:"
      assert_equal 'queued', @record.state
    end

    test 'canceling a card' do
      response = msg(USERONE, USERTWO, amount: 10, state: 'confirm', input: false)
      assert_equal 'ephemeral', response[:response_type]
      assert_includes response[:text], ":disappointed:"
      assert_equal 'canceled', @record.state
    end

    test 'when funding fails' do
      response = msg(USERONE, USERTWO, amount: 10, state: 'queued', input: :funding_failed)
      assert_equal 'ephemeral', response[:response_type]
      assert_includes response[:text], "couldn't fund your account."
      assert_equal 'failed', @record.state
    end

    test 'when sending fails' do
      response = msg(USERONE, USERTWO, amount: 10, state: 'queued', input: :sending_failed)
      assert_equal 'ephemeral', response[:response_type]
      assert_includes response[:text], "couldn't send your card"
      assert_equal 'failed', @record.state
    end

    test 'when sending succeeds' do
      response = msg(USERONE, USERTWO, amount: 10, state: 'queued')
      assert_equal 'in_channel', response[:response_type]
      assert_includes response[:text], "<!channel>"
      assert_equal 'sent', @record.state
    end
  end
end
