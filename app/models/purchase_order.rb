class PurchaseOrder < ActiveRecord::Base

  belongs_to :customer
  belongs_to :part
  belongs_to :team_member
  has_many :logs

  STAGES = ["Sales", "Quoting", "Design", "Engineering", "Production", "Inspections", "Shipping"]

  PART_IDS = ["ASDF1234", "DEFG1234", "HIJK1234", "LMNO1234"]

  # crunched from historical averages of each part_id, should automatically update every week or so
  STAGE_LENGTHS = {
    'ASDF1234' => {"Sales" => 1, "Quoting" => 2, "Design" => 7, "Engineering" => 14, "Production" => 80, "Inspections" => 20, "Shipping" => 5},
    'DEFG1234' => {"Sales" => 2, "Quoting" => 4, "Design" => 15, "Engineering" => 20, "Production" => 20, "Inspections" => 10, "Shipping" => 1},
    'HIJK1234' => {"Sales" => 4, "Quoting" => 6, "Design" => 23, "Engineering" => 25, "Production" => 50, "Inspections" => 23, "Shipping" => 3},
    'LMNO1234' => {"Sales" => 7, "Quoting" => 3, "Design" => 9, "Engineering" => 30, "Production" => 60, "Inspections" => 15, "Shipping" => 10}
  }

  def calculate_average_stage_lengths
    case part_id
    when 'engineering'
      stage_length[engineering] = time_stmp
    when 'quoting'
      stage_length[quoting] = time_stmp
    end
  end


# status generates number of days PO will be late or early,
# given the number of days part is expected to take before completion (based on historical evidence)
  def status
    self.estimate_ship_date
    return  "On Time" if self.estimated_ship_date == self.requested_ship_date

    days = (self.estimated_ship_date.to_time.to_i - self.requested_ship_date.to_time.to_i) / 86400
    sentiment = days < 0 ? "ahead" : "late"
    unit = "days"

    return "#{days.abs} #{unit} #{sentiment}"
  end

  # TODO: update .map to use activerecord consolidate vs symbol notation
  def incomplete_stages
    STAGES - complete_stages
  end

  def complete_stages
    logs = self.logs
    completed = logs.map {|log| log.department}.uniq
  end

  def estimated_days_left
    sum = 0
    incomplete_stages.map {|stage| sum += stage_lengths[stage]}.last
  end

  def estimate_ship_date
    self.estimated_ship_date = self.created_at + estimated_days_left.days
    self.save
  end

  def total_days
    stage_lengths.values.inject(0, :+)
  end

  #returns % of each stage days / total time
  # def stage_percents
  #   stage_lengths.each do |key, value|
  #   end
  # end

  def stage_lengths
    STAGE_LENGTHS[self.part.external_id] # => hash of all stages for part ID
  end

  # returns an integer, works backwards from what's remaining vs what's been done
  def progress
    (total_days - estimated_days_left).to_f / total_days # => percentage completed
  end

  # logs
  # logs = po.logs # => [{agent: 'John', department: 'quoting'}, {agent: 'Jim', department: 'negotiation'}]

  # rails generate migration CreatePurchaseOrders soid requested_ship_date:date quantity:integer unit_price:float estimated_ship_date:date revised_ship_date:date customer:references part:references salespeople:references
end
