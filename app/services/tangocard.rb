module Tangocard
  class Client
    def initialize
      @conn = Faraday.new ENV['TANGOCARD_ROOTURL'] || 'http://example.com'
      @conn.basic_auth ENV['TANGOCARD_PLATFORM_NAME'], ENV['TANGOCARD_PLATFORM_KEY']
    end

    def create_customer(name)
      resp = @conn.post do |req|
        req.url 'customers'
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          displayName: name,
          customerIdentifier: name.parameterize
        }.to_json
      end
      JSON.parse resp.body
    end

    def create_account(customerIdentifier: '', accountIdentifier: '', email: '', name: '')
      resp = @conn.post do |req|
        req.url "customers/#{customerIdentifier}/accounts"
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          accountIdentifier: accountIdentifier,
          contactEmail: email,
          currencyCode: 'USD',
          displayName: "#{customerIdentifier} - #{name}"
        }.to_json
      end
      JSON.parse resp.body
    end

    def get_account(identifier)
      resp = @conn.get "accounts/#{identifier}"
      JSON.parse resp.body
    end

    def create_card(payload)
      resp = @conn.post do |req|
        req.url 'creditCards'
        req.headers['Content-Type'] = 'application/json'
        req.body = payload.to_json
      end
      JSON.parse resp.body
    end

    def fund_account(customer_id, account_id, card_token, amount)
      resp = @conn.post do |req|
        req.url 'creditCardDeposits'
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          customerIdentifier: customer_id,
          accountIdentifier: account_id,
          creditCardToken: card_token,
          amount: amount
        }.to_json
      end
      JSON.parse resp.body
    end

    def send_card(customer_id, account_id,
                  sender_fn, sender_ln, sender_email,
                  recipient_fn, recipient_ln, recipient_email,
                  amount, record_id, subject, message)
      resp = @conn.post do |req|
        req.url 'creditCardDeposits'
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          customerIdentifier: customer_id,
          accountIdentifier: account_id,
          sendEmail: true,
          utid: 'U157189', # AMZN US
          amount: amount,
          externalRefID: record_id.to_s,
          sender: {
            email: sender_email,
            firstName: sender_fn,
            lastName: sender_ln
          },
          recipient: {
            email: recipient_email,
            firstName: recipient_fn,
            lastName: recipient_ln
          },
          emailSubject: subject,
          message: message
        }.to_json
      end
      JSON.parse resp.body
    end
  end
end
