# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.support?
      can :read, :all
      can :create, Ticket
      can :update, Ticket, assigned_to_id: user.id
      can :assign, Ticket do |ticket|
        ticket.open? && ticket.assigned_to.nil?
      end
      can :unassign, Ticket do |ticket|
        ticket.assigned? && ticket.assigned_to_id == user.id
      end
    else
      can :read, Ticket, user_id: user.id
      can :create, Ticket
      can :update, Ticket, user_id: user.id
      cannot :assign, Ticket
      cannot :unassign, Ticket
    end

    can :manage, Comment, user_id: user.id
    can :manage, Comment, ticket: { user_id: user.id }
    can :manage, Comment, ticket: { assigned_to_id: user.id }
  end
end
