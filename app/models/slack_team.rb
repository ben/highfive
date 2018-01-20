class SlackTeam < ApplicationRecord
  has_many :highfive_records

  def tangocard?
    tango_customer_identifier && tango_account_identifier
  end
end
