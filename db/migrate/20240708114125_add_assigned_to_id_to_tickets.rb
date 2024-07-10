class AddAssignedToIdToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :assigned_to_id, :integer
    add_foreign_key :tickets, :users, column: :assigned_to_id
  end
end
