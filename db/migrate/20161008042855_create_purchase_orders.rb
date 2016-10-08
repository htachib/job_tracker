class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.string :soid
      t.date :requested_ship_date
      t.integer :quantity
      t.float :unit_price
      t.date :estimated_ship_date
      t.date :revised_ship_date
      t.references :customer, index: true, foreign_key: true
      t.references :part, index: true, foreign_key: true
      t.references :team_member, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
