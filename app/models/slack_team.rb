class SlackTeam < ApplicationRecord
  has_many :highfive_records

  def tangocard?
    !!(tango_customer_identifier && tango_account_identifier)
  end

  def daily_total
    records = HighfiveRecord.where(created_at: 24.hours.ago..Time.now)
    records.reduce(0) { |sum, r| sum + (r.amount || 0) }
  end
end
