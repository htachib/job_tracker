class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :agent
      t.string :department
      t.text :comment
      t.references :purchase_order, index: true, foreign_key: true
      t.references :part, index: true, foreign_key: true
      t.references :customer, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
