class Part < ActiveRecord::Base

  has_many :purchase_orders
  has_and_belongs_to_many :customers
  has_many :team_members, through: :purchase_orders
  has_many :logs, through: :purchase_orders

end
