class Funding < ApplicationRecord
  belongs_to :slack_team
  belongs_to :highfive_record
end
