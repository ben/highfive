class SlackTeam < ApplicationRecord
  has_many :highfive_records
  
  def tangocard?
    false
  end
end
