class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: [:show, :destroy, :assign]
  load_and_authorize_resource

  def index
    @tickets = if current_user.admin?
      Ticket.all
    elsif current_user.support?
      Ticket.where(status: [:open, :assigned]).or(Ticket.where(assigned_to: current_user))
    else
      current_user.tickets
    end

    @tickets = @tickets.search(params[:search]) if params[:search].present?
    @tickets = @tickets.where(status: params[:status]) if params[:status].present?
    @tickets = @tickets.where(priority: params[:priority]) if params[:priority].present?
    @tickets = @tickets.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @comments = @ticket.comments
    @comment = Comment.new
    @events = @ticket.events.includes(:user).order(created_at: :desc)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @ticket = current_user.tickets.build
    @tech_support_users = User.support if can? :assign, Ticket
  end

  def create
    @ticket = current_user.tickets.build(ticket_params)
    if cannot? :assign, Ticket
      @ticket.assigned_to_id = nil
    end
    if @ticket.save
      redirect_to @ticket, notice: 'Zgłoszenie zostało utworzone.'
    else
      render :new
    end
  end

  def edit
    @ticket = current_user.admin? ? Ticket.find(params[:id]) : set_ticket
    @tech_support_users = User.support if can? :assign, Ticket
  end

  def update
    if cannot? :assign, Ticket
      params[:ticket].delete(:assigned_to_id)
    end

    old_status = @ticket.status
    old_assigned_to = @ticket.assigned_to
    if @ticket.update(ticket_params)
      # Tworzymy eventy po udanej aktualizacji
      if @ticket.status != old_status
        Event.log_status_change(@ticket, old_status, @ticket.status, current_user)
      end

      if @ticket.assigned_to != old_assigned_to
        Event.log_assignment_change(@ticket, old_assigned_to, @ticket.assigned_to, current_user)
      end

      respond_to do |format|
        format.html { redirect_to @ticket, notice: 'Zgłoszenie zostało zaktualizowane.' }
        format.turbo_stream { redirect_to @ticket, notice: 'Zgłoszenie zostało zaktualizowane.' }
      end
    else
      @tech_support_users = User.all if can? :assign, Ticket
      respond_to do |format|
        format.html do
          flash.now[:alert] = "Wystąpił błąd podczas aktualizacji zgłoszenia: #{error_messages}"
          render :edit
        end
        format.turbo_stream do
          flash.now[:alert] = "Wystąpił błąd podczas aktualizacji zgłoszenia: #{error_messages}"
          render :edit
        end
      end
    end
  end

  def assign
    authorize! :assign, @ticket

    if @ticket.assigned_to.nil?
      assign_ticket
    elsif @ticket.assigned_to == current_user
      if @ticket.assigned?
        unassign_ticket
      else
        redirect_to @ticket, alert: 'Można porzucić tylko zgłoszenie o statusie "Przypisany".'
      end
    else
      redirect_to @ticket, alert: 'Zgłoszenie jest już przypisane do innego użytkownika.'
    end
  end
  def destroy
    @ticket.destroy
    redirect_to tickets_url, notice: 'Zgłoszenie zostało usunięte.'
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :status, :priority, :assigned_to_id)
  end

  def assign_ticket
    if @ticket.update(status: :assigned, assigned_to: current_user)
      Event.log_assignment_change(@ticket, nil, current_user, current_user)
      redirect_to @ticket, notice: 'Zgłoszenie zostało do Ciebie przypisane.'
    else
      redirect_to @ticket, alert: 'Nie udało się przypisać zgłoszenia.'
    end
  end

  def unassign_ticket
    if @ticket.update(status: :open, assigned_to: nil)
      Event.log_assignment_change(@ticket, current_user, nil, current_user)
      redirect_to @ticket, notice: 'Zgłoszenie zostało porzucone.'
    else
      redirect_to @ticket, alert: 'Nie udało się porzucić zgłoszenia.'
    end
  end
end
