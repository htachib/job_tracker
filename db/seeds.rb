30.times do |num|
  member = TeamMember.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  po = member.purchase_orders.create!(soid: Faker::Code.asin, requested_ship_date: Faker::Date.forward(Faker::Number.between(1, 100)),
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

  part = Part.create!(external_id: random, part_type: part_types.shuffle.first)
  po.update(part_id: part.id)

  departments = ["Production", "Engineering", "Quoting", "Sales", "Inspections", "Design"]

  5.times do |n|
    log = Log.create!(agent: Faker::Name.name_with_middle, department: departments.shuffle.first, comment: Faker::Hacker.say_something_smart,
                     part_id: part.id, purchase_order_id: po.id, customer_id: customer.id)
  end
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
