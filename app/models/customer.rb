class Customer < ActiveRecord::Base

  has_many :purchase_orders
  has_many :parts, through: :purchase_orders
  belongs_to :team_member
  has_many :logs, through: :purchase_orders

end
