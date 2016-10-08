class AddMiddleNameToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :middle_name, :string
  end
end
