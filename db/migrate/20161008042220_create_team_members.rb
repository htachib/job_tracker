class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.timestamps null: false
    end
  end
end
