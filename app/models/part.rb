class Part < ActiveRecord::Base

  has_many :purchase_orders
  has_many :customers, through: :purchase_orders
  has_many :team_members, through: :purchase_orders
  has_many :logs, through: :purchase_orders

end
