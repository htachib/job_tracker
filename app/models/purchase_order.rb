class PurchaseOrder < ActiveRecord::Base

  belongs_to :customer
  belongs_to :part
  belongs_to :team_member
  has_many :logs

  STAGES = ['quoting', 'negotiation', 'design', 'engineering', 'inspection']

  def get_stage_lengths(micross_part_id)
    length = case micross_part_id
      when 'abc-123'
        {'engineering' => 7, 'quoting' => 3}
      when 'def-456'
        {'engineering' => 2, 'quoting' => 6}
    end

    length
  end

  def calculate_average_stage_lengths
    case part_id
    when 'engineering'
      stage_length[engineering] = time_stmp
    when 'quoting'
      stage_length[quoting] = time_stmp
    end
  end

  def status
    days = (self.estimated_ship_date.to_i - self.requested_ship_date.to_i) / 86400
    days = (estimated.to_i - requested.to_i) / 86400
    sentiment = days < 0 ? "ahead" : "late"
    unit = "days"

    return "#{days.abs} #{unit} #{sentiment}"
  end

  # TODO: update .map to use activerecord consolidate vs symbol notation
  def incomplete_stages
    logs = self.logs
    completed = logs.map {|log| log[:department]}.uniq

    STAGES - completed
  end

  def estimated_days_left
    stage_lengths = get_stage_lengths(self.part.external_id)

    sum = 0
    incomplete_stages.map {|stage| sum += stage_lengths[stage]}
  end

  def estimate_ship_date
    self.estimated_ship_date = self.created_at + estimated_days_left.days
  end

  # returns an integer, works backwards from what's remaining vs what's been done
  def progress
    stage_lengths = get_stage_lengths(self.part.external_id)
    total_days = stage_lengths.keys.inject(0, :+)
    (total_days - estimated_days_left) / total_days
  end

  # stages
  # 1. quoting
  # 2. negotiation
  # 3. design
  # 4. engineering
  # 5. inspection

  # logs
  # logs = po.logs # => [{agent: 'John', department: 'quoting'}, {agent: 'Jim', department: 'negotiation'}]

  # rails generate migration CreatePurchaseOrders soid requested_ship_date:date quantity:integer unit_price:float estimated_ship_date:date revised_ship_date:date customer:references part:references salespeople:references
end
