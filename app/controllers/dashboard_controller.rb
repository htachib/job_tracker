class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index #fetch POs from database to iterate through
    overdue_length = params[:overdue].to_i || 0
    @title = "At least #{overdue_length} days late"

    po_list = PurchaseOrder.all

    @overdue = po_list.map do |po|
      if po.status.include?("late")
        status_message = po.status.split # => ["53", "days", "ahead"]
        days = status_message[0].to_i
        po if days > overdue_length
      end
    end.compact
  end

end
