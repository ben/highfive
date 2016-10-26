class TangocardController < ApplicationController
  include AdminTeam
  layout 'admin'

  before_action :requires_login

  def enable
    tango_client.create_customer customer_identifier

    tango_client.create_account(
      customerIdentifier: customer_identifier,
      accountIdentifier: account_identifier,
      email: current_user_info[:email],
      name: current_user_info[:real_name]
    )

    current_team.update!(
      tango_customer_identifier: customer_identifier,
      tango_account_identifier: account_identifier
    )
    redirect_to controller: :admin, action: :configuration
  end

  def credit_card
    cc_params = params.permit(:accountIdentifier, :customerIdentifier, :label,
                              :number, :expiration, :verificationNumber,
                              :firstName, :lastName, :addressLine1, :addressLine2,
                              :city, :country, :emailAddress, :postalCode, :state)
    cc_params[:ipAddress] = request.ip
    cc = CreditCard.new(cc_params)
    if cc.valid?
      resp = tango_client.create_card cc.to_tango_payload
      if resp['errors']
        flash[:tango_errors] = resp['errors']
      else
        current_team.tango_card_token = resp['token']
        current_team.save!
      end
    else
      flash[:validation_errors] = cc.errors
    end
    redirect_to controller: :admin, action: :configuration
  end

  private

  def tango_client
    Tangocard::Client.new
  end

  def customer_identifier
    to_identifier(current_team.team_subdomain)
  end

  def account_identifier
    to_identifier("#{customer_identifier}-#{current_user_info[:real_name]}")
  end

  def to_identifier(str)
    str.parameterize.gsub(/[^a-zA-Z0-9]/, '')
  end
end
