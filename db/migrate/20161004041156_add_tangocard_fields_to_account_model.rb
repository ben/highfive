class AddTangocardFieldsToAccountModel < ActiveRecord::Migration[5.0]
  def change
    change_table :slack_teams do |t|
      t.string :tango_customer_identifier
      t.string :tango_account_identifier
      t.string :tango_card_token
    end
  end
end
