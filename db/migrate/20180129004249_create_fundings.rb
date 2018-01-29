class CreateFundings < ActiveRecord::Migration[5.1]
  def change
    create_table :fundings do |t|
      t.belongs_to :slack_team, foreign_key: true
      t.belongs_to :highfive_record, foreign_key: true
      t.integer :amount
      t.boolean :succeeded
      t.string :fund_id
      t.string :error
      t.timestamps
    end
  end
end
