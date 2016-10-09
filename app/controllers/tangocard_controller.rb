class TangocardController < ApplicationController
  include AdminTeam
  layout 'admin'

  before_action :requires_login

  def enable
    tango_client = Tangocard::Client.new
    customer_identifier = to_identifier(current_team.team_subdomain)
    account_identifier = to_identifier(current_user_info[:real_name])

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
    cc.validate!
    redirect_to controller: :admin, action: :configuration
  end

  private

  def to_identifier(str)
    str.parameterize.gsub(/[^a-zA-Z0-9]/, '')
  end
end
