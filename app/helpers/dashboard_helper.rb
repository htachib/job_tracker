module DashboardHelper

  def status_color(purchase_order)
    return if purchase_order.status == "On Time"
    purchase_order.status.include?("ahead") ? "ahead" : "behind"
  end

  def stage_progress(stage, purchase_order)
    progress = 0

    if purchase_order.complete_stages.include?(stage)
      progress = purchase_order.stage_lengths[stage].to_f / purchase_order.total_days # => 7
    end

    progress * 100
  end

end
