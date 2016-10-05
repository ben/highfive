class AddNameToSlackTeam < ActiveRecord::Migration[5.0]
  def change
    change_table :slack_teams do |t|
      t.string :team_name
    end
  end
end
