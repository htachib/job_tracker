class Log < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :part
  belongs_to :customer

end
