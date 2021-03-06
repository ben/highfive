class CreateHighfiveRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :highfive_records do |t|
      t.belongs_to :slack_team, foreign_key: true
      t.string :from
      t.string :to
      t.string :reason
      t.string :currency
      t.integer :amount
      t.string :card_code
      t.timestamps
    end
  end
end
