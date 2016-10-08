class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.string :external_id
      t.string :part_type
      t.timestamps null: false
    end
  end
end
