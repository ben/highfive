class RecordFullTangocardOrderPayload < ActiveRecord::Migration[5.1]
  def change
    change_table :highfive_records do |t|
      t.string :tango_payload
    end
  end
end
