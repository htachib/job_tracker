class TeamMember < ActiveRecord::Base

  # associations
  has_many :purchase_orders
  has_many :customers
  has_many :parts, through: :purchase_orders

  # validations
  validates_presence_of :first_name, :last_name

  # callbacks
  before_create :format_name

  def format_name
    self.first_name = self.first_name.titleize
    self.middle_name = self.middle_name.titleize if self.middle_name?
    self.last_name = self.last_name.titleize
  end

  def initials
    first_name.chars.first + middle_name.chars.first + last_name.chars.first
  end

end
