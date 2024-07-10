require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:ticket) { create(:ticket) }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid params" do
      it "create new comment" do
        expect {
          post :create, params: { ticket_id: ticket.id, comment: { body: "Nowy komentarz" } }, format: :turbo_stream
        }.to change(Comment, :count).by(1)
      end

      it "return response via turbo stream" do
        post :create, params: { ticket_id: ticket.id, comment: { body: "Nowy komentarz" } }, format: :turbo_stream
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end

    context "with invalid params" do
      it "do not create comment" do
        expect {
          post :create, params: { ticket_id: ticket.id, comment: { body: "" } }, format: :turbo_stream
        }.to_not change(Comment, :count)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { create(:comment, user: user, ticket: ticket) }

    it "delete comment" do
      expect {
        delete :destroy, params: { ticket_id: ticket.id, id: comment.id }, format: :turbo_stream
      }.to change(Comment, :count).by(-1)
    end

    it "return response via turbo stream" do
      delete :destroy, params: { ticket_id: ticket.id, id: comment.id }, format: :turbo_stream
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end
end
