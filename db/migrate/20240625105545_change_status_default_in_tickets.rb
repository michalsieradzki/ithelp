class ChangeStatusDefaultInTickets < ActiveRecord::Migration[7.0]
  def up
    change_column_default :tickets, :status, from: 'new', to: 'open'
    Ticket.where(status: 'new').update_all(status: 'open')
  end

  def down
    change_column_default :tickets, :status, from: 'open', to: 'new'
    Ticket.where(status: 'open').update_all(status: 'new')
  end
end
