class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket

  def create
    @comment = @ticket.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      @event = @ticket.events.last  # Get the last event (which should be the one we just created)
      respond_to do |format|
        format.html { redirect_to @ticket, notice: 'Comment was successfully created.' }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend('comments', partial: 'comments/comment', locals: { comment: @comment }),
            turbo_stream.prepend('ticket_events', partial: 'events/event', locals: { event: @event })
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @ticket, alert: 'Failed to create comment.' }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: "comments/form", locals: { comment: @comment }) }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
