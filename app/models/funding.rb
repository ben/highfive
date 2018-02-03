class Funding < ApplicationRecord
  belongs_to :slack_team
  belongs_to :highfive_record

  def succeceded?
    json_payload['status'] == 'SUCCESS'
  end

  def json_payload
    @json_payload_cache ||= JSON.parse(payload)
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << ['date', 'amount', 'success', 'tangocard id', 'error']

      all.each do |f|
        csv << [
          f.created_at.utc,
          f.amount,
          f.succeeded,
          f.fund_id,
          f.error,
        ]
      end
    end
  end
end
