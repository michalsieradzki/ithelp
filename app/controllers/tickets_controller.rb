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

    if @ticket.update(ticket_params)
      redirect_to @ticket, notice: 'Zgłoszenie zostało zaktualizowane.'
    else
      @tech_support_users = User.support if can? :assign, Ticket
      render :edit
    end
  end
  def assign
    authorize! :assign, @ticket
    @ticket = Ticket.find(params[:id])
    @ticket.update(status: :assigned, assigned_to: current_user)
    redirect_to @ticket, notice: 'Zgłoszenie zostało do Ciebie przypisane.'
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
end
