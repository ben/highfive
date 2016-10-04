class SlackTeam < ApplicationRecord
  def tangocard?
    tango_customer_identifier && tango_account_identifier
  end
end
