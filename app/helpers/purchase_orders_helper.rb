module PurchaseOrdersHelper

  require 'action_view'
  include ActionView::Helpers::NumberHelper



  def average_margin
    ##
  end

  def price_as_currency
    number_to_currency(@purchase_order.unit_price)
  end

  def actual_time_intervals #days spent in each completed stage so far
    actual = @purchase_order.complete_stages
    actual_lengths = []
    actual.each do |stage|
      case stage
      when "Sales"
        actual_lengths << rand(1...10)
      when "Quoting"
        actual_lengths << rand(2...20)
      when "Design"
        actual_lengths << rand(5...30)
      when "Engineering"
        actual_lengths << rand(10...50)
      when "Production"
        actual_lengths << rand(30...80)
      when "Inspections"
        actual_lengths << rand(5...10)
      when "Shipping"
        actual_lengths << rand(2...10)
      else
        "ERR"
      end
    end
    actual_lengths
  end

  def predicted_time_intervals
    predicted = @purchase_order.incomplete_stages
    predicted_lengths = []
    predicted.each do |remain_stage|
      predicted_lengths << @purchase_order.stage_lengths[remain_stage]
    end
    predicted_lengths
  end



end
