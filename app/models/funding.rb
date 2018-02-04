class Funding < ApplicationRecord
  belongs_to :slack_team
  belongs_to :highfive_record

  def succeeded?
    json_payload['status'] == 'SUCCESS'
  end

  def json_payload
    @json_payload_cache ||= JSON.parse(payload)
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << ['date', 'amount', 'success', 'response payload']

      all.each do |f|
        csv << [
          f.created_at.utc,
          f.amount,
          f.succeeded?,
          f.payload,
        ]
      end
    end
  end
end
