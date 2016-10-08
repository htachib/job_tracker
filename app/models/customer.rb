class Customer < ActiveRecord::Base

  has_many :purchase_orders
  has_and_belongs_to_many :parts
  has_and_belongs_to_many :team_members
  has_many :logs, through: :purchase_orders

end
