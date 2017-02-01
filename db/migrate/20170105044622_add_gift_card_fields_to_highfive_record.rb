class AddGiftCardFieldsToHighfiveRecord < ActiveRecord::Migration[5.0]
  def change
    change_table :highfive_records do |t|
      t.string :slack_response_url
      t.string :tango_reference_order_id
    end
  end
end
