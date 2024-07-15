# app/helpers/events_helper.rb

module EventsHelper
  def render_event_action(event)
    case event.action_type
    when Event::STATUS_CHANGE
      "#{event.user.name} zmienił status z #{event.details['from']} na #{event.details['to']}"
    when Event::ASSIGNMENT_CHANGE
      "#{event.user.name} zmienił przypisanie z #{event.details['from']} na #{event.details['to']}"
    when Event::COMMENT_ADDED
      "#{event.user.name} dodał komentarz"
    else
      "Nieznana akcja"
    end
  end
end
