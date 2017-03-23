class ConfirmCardJob < ApplicationJob
  queue_as :default
  include SlackClient
  include SlackRecordOwner

  def perform(record_id)
    @record = HighfiveRecord.find(record_id)

    # Send an interactive message to the user
  end
end
