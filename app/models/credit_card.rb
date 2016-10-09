class CreditCard
  include ActiveModel::Model

  # root-level fields
  attr_accessor :accountIdentifier, :customerIdentifier, :ipAddress, :label
  # CC fields
  attr_accessor :number, :expiration, :verificationNumber
  # billing-address fields
  attr_accessor :firstName, :lastName, :addressLine1, :addressLine2,
                :city, :country, :emailAddress, :postalCode, :state

  # All fields are required
  validates_presence_of :accountIdentifier, :customerIdentifier, :ipAddress, :label
  validates_presence_of :number, :expiration, :verificationNumber
  validates_presence_of :firstName, :lastName, :addressLine1,
                        :city, :country, :emailAddress, :postalCode, :state

  def to_tango_payload
    {
      accountIdentifier: accountIdentifier,
      customerIdentifier: customerIdentifier,
      ipAddress: ipAddress,
      label: label,
      creditCard: {
        number: number,
        expiration: expiration,
        verificationNumber: verificationNumber
      },
      billingAddress: {
        firstName: firstName,
        lastName: lastName,
        emailAddress: emailAddress,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        state: state,
        postalCode: postalCode,
        country: country
      }
    }
  end
end
