class SlackTeam < ApplicationRecord
  has_many :highfive_records
  has_many :fundings

  def tangocard?
    tango_customer_identifier.present? && tango_account_identifier.present?
  end

  def daily_total
    records = HighfiveRecord.where(created_at: 24.hours.ago..Time.now).sent
    records.reduce(0) { |sum, r| sum + (r.amount || 0) }
  end
end
