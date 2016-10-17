module ApplicationHelper
  def status_color(purchase_order) #=> determines color of each purchase order based on status
    return if purchase_order.status == "On Time"
    purchase_order.status.include?("ahead") ? "ahead" : "behind"
  end

  def stage_progress(stage, purchase_order)
    progress = 0

    if purchase_order.complete_stages.include?(stage)
      progress = purchase_order.stage_lengths[stage].to_f / purchase_order.total_days # => 7
    end

    progress * 100 # => % completed based on how many production stages have been completed
  end

end
