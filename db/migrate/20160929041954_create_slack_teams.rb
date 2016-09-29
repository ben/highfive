class CreateSlackTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_teams do |t|
      t.string :team_id
      t.string :access_token
      t.timestamps
      t.index :team_id, unique: true
    end
  end
end
