class AddHighfiveState < ActiveRecord::Migration[5.0]
  def change
    change_table :highfive_records do |t|
      t.string :state
    end
  end
end
