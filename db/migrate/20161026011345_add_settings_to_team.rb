class AddSettingsToTeam < ActiveRecord::Migration[5.0]
  def change
    change_table :slack_teams do |t|
      t.integer :award_limit
      t.integer :daily_limit
      t.integer :double_rate
      t.integer :boomerang_rate
    end
  end
end
