require 'pry'
30.times do |num|
  member = TeamMember.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  po = member.purchase_orders.create!(soid: Faker::Code.asin[0..6], requested_ship_date: Faker::Date.forward(Faker::Number.between(1, 100)),
       quantity: Faker::Number.between(1,1000), unit_price: Faker::Commerce.price)

  if num % 2 == 0
    po.requested_ship_date = Faker::Date.backward(Faker::Number.between(1, 100))
  end

  customer = Customer.create!(company_name: Faker::Company.name, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
                             email_address: Faker::Internet.email, phone_number: Faker::PhoneNumber.phone_number, team_member_id: member.id)

  po.update(customer_id: customer.id)

  letters  = ("A".."Z").to_a
  numbers = (0..9).to_a
  random = letters.sample(4).join + numbers.sample(8).join
  part_types = ["SMD", "MEM", "SMD LT", "CUST", "PLAS"]

  #external_ids to only include those with historical averages available -- will change with real data
# binding.pry
  part = Part.create!(external_id: PurchaseOrder::STAGE_LENGTHS.keys.shuffle.take(1).join, part_type: part_types.shuffle.first)
  po.update(part_id: part.id)

  departments = ["Sales", "Quoting", "Design", "Engineering", "Production", "Inspections", "Shipping"]

  # at least do sales step for every PO
  log = Log.create!(agent: Faker::Name.name_with_middle, department: departments[0], comment: Faker::Hacker.say_something_smart,
                   part_id: part.id, purchase_order_id: po.id, customer_id: customer.id)

  progress = Faker::Number.between(1, 6)
  progress.times do |n|
    log = Log.create!(agent: Faker::Name.name_with_middle, department: departments[n], comment: Faker::Hacker.say_something_smart,
                     part_id: part.id, purchase_order_id: po.id, customer_id: customer.id)
  end
end

def delete_everything
  Log.destroy_all
  PurchaseOrder.destroy_all
  Part.destroy_all
  Customer.destroy_all
  TeamMember.destroy_all
end

require 'CSV'
csv= CSV.read("../test.csv")
reads csv file from directory above app location
headers = csv[0]
data = csv[1..10000]
all_pos = []
data.each do |row|
  n = headers.length
  po = {}

  n.times do |col|
    po[headers[col]] = row[col]
  end
  all_pos << po
end

#   person = {first_name: 'Bob', last_name: 'Kulp'}
#   # other stuff
#   # more other stuff
#   TeamMember.new(person)
#
# # => Class Methods
#   .find #=> accepts primary key as argument, returns object with that id
#   .find_by # => accepts (i) attribute name of calling model and (ii) matching attribute value.
#            # => Returns first object with a value for that attribute
#            # => TeamMember.find_by(first_name: 'Ryan')
#   .where   # => similar to find_by inputs. returns *all* objects that match the query
#   .new     # => accepts a hash of key-value attribute names and values
#            # => t = TeamMember.new(first_name: 'Hideko', last_name: 'Tachi')
#            # => t.save
#   .create  # => actually commit to database and return the object created, same syntax as ".new"
#            # TeamMember.
#   .destroy_all
#
#   # => Instance Methods
#   .update  # => accepts (i) attribute as symbol and (ii) value you want attribute to become
#
#   .destroy #
#
#
# # person = TeamMember.find_by(first_name: 'Ryan') # => 'returns an object`
# # person.first_name # => 'Ryan'
# #
# # person = TeamMember.where(first_name: 'Ryan')
# # person # => [<ActiveRecord:: {first_name: 'Ryan'}>]
# # person.first.first_name # => undefined method 'first_name' for ActiveRecord::Collection
# # person[0].first_name



all_pos.each do |po_data|
  member = TeamMember.create!(first_name: "Xavier", last_name: "Xavier")
  requested = po_data["Request. Ship Date"]
  req_ship_date = Date.strptime(requested, "%m/%d/%Y")

  po = member.purchase_orders.create!(soid: po_data["SO ID"], requested_ship_date: req_ship_date, quantity: po_data["Revised Order Qty"], unit_price: po_data["SO Unit Price"])

  customer = Customer.create!(company_name: po_data["Customer Name"], first_name: "First Name", last_name: "Last Name",
                             email_address: "Email", phone_number: "(xxx) xxx-xxxx", team_member_id: member.id)

  po.update(customer_id: customer.id)

  #external_ids to only include those with historical averages available -- will change with real data
  (po_data["Product Line"] == "STD" && po_data["Part ID"].include?("MTLT") ) ? po_data["Product Line"] = "STD LT" : po_data["Product Line"] = "STD"

  part = Part.create!(external_id: po_data["Part ID"], part_type: po_data["Product Line"] || "NA")
  po.update(part_id: part.id)

  departments = ["Sales", "Quoting", "Design", "Engineering", "Production", "Inspections", "Shipping"]

  # at least do sales step for every PO
  progress = Faker::Number.between(1, 7)
  progress.times do |n|
    Log.create!(agent: "Logger Name", department: departments[n], comment: "Updated new production stage..",
                     part_id: part.id, purchase_order_id: po.id, customer_id: customer.id)
  end
end
