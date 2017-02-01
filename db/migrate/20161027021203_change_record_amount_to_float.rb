class ChangeRecordAmountToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :highfive_records, :amount, :float
  end
end
