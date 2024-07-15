class Comment < ApplicationRecord
  validates :body, presence: true

  belongs_to :user
  belongs_to :ticket

  after_create :create_comment_event

  private

  def create_comment_event
    event = Event.create(
      ticket: ticket,
      user: user,
      action_type: Event::COMMENT_ADDED,
      details: { comment_id: id }
    )

    Turbo::StreamsChannel.broadcast_prepend_to(
      ticket,
      target: 'ticket_events',
      partial: 'events/event',
      locals: { event: event }
    )
  end

end
