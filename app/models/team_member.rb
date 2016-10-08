class TeamMember < ActiveRecord::Base

  has_many :purchase_orders
  has_and_belongs_to_many :customers
  has_many :parts, through: :purchase_orders

  def initials
    initials = first_name.chars.first + middle_name.chars.first + last_name.chars.first
    initials.upcase
  end

end
