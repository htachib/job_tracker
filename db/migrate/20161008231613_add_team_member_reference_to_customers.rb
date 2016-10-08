class AddTeamMemberReferenceToCustomers < ActiveRecord::Migration
  def change
    add_reference :customers, :team_member, index: true
  end
end
