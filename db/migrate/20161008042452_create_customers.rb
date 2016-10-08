class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :company_name
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :phone_number
      t.timestamps null: false
    end
  end
end
