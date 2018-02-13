require 'test_helper'

describe TangoCardJob do
  describe 'when funding is necessary' do
    before do
      mock_tango_api balance: 5
      stub_slack_client
      stub_request(:post, %r(https://example.com/slack_response/.*)).
        to_return(status: 200, body: "", headers: {})
      TangoCardJob.perform_now highfive_records(:one).id
      end

    it 'funds the account' do
      assert_tango_api_requested :post, '/creditCardDeposits'
    end

    it 'sends the card' do
      assert_tango_api_requested :post, '/orders'
    end

    it 'saves the tangocard payload' do
      HighfiveRecord.last.tango_payload.must_match /"ok":true/
    end

    it 'posts to slack' do
      assert_requested :post, %r(https://example.com/slack_response/.*)
    end
  end

  describe 'when the account has enough funds' do
    before do
      mock_tango_api balance: 500
      stub_slack_client
      stub_request(:post, %r(https://example.com/slack_response/.*)).
        to_return(status: 200, body: "", headers: {})
      TangoCardJob.perform_now highfive_records(:one).id
      end

    it 'does not call the funding api' do
      refute_tango_api_requested :post, '/creditCardDeposits'
    end

    it 'sends the card' do
      assert_tango_api_requested :post, '/orders'
    end

    it 'posts to slack' do
      assert_requested :post, %r(https://example.com/slack_response/.*)
    end
  end
end
