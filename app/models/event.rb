# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  validates :action_type, presence: true

  STATUS_CHANGE = 'status_change'.freeze
  ASSIGNMENT_CHANGE = 'assignment_change'.freeze
  COMMENT_ADDED = 'comment_added'.freeze

  after_create_commit -> { broadcast_prepend_to ticket, target: 'ticket_events', partial: 'events/event', locals: { event: self } }

  def self.log_status_change(ticket, old_status, new_status, user)
    create(
      ticket: ticket,
      user: user,
      action_type: STATUS_CHANGE,
      details: { from: old_status, to: new_status }
    )
  end

  def self.log_assignment_change(ticket, old_assignee, new_assignee, user)
    create(
      ticket: ticket,
      user: user,
      action_type: ASSIGNMENT_CHANGE,
      details: {
        from: old_assignee ? old_assignee.name : 'Nikt',
        to: new_assignee ? new_assignee.name : 'Nikt'
      }
    )
  end

  def self.log_comment_added(ticket, comment, user)
    create(
      ticket: ticket,
      user: user,
      action_type: COMMENT_ADDED,
      details: { comment_id: comment.id }
    )
  end

end
