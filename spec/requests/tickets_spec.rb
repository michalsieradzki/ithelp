require 'rails_helper'

RSpec.describe "Tickets", type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: :admin) }
  let(:support) { create(:user, role: :support) }
  let(:valid_attributes) { attributes_for(:ticket) }
  let(:invalid_attributes) { attributes_for(:ticket, title: nil) }

  before do
    sign_in user
  end

  describe "GET /index" do
    it "returns a success response" do
      Ticket.create! valid_attributes.merge(user: user)
      get tickets_path
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      ticket = create(:ticket, user: user)
      get ticket_path(ticket), params: { id: ticket.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get new_ticket_path
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Ticket' do
        sign_in user
        expect {
          post tickets_path, params: { ticket: valid_attributes.except(:assigned_to_id) }
        }.to change(Ticket, :count).by(1)
      end

      it 'redirects to the created ticket' do
        sign_in user
        post tickets_path, params: { ticket: valid_attributes.except(:assigned_to_id) }
        expect(response).to redirect_to(ticket_path(Ticket.last))
      end

      it 'allows admin to assign ticket' do
        sign_in admin

        expect {
          post tickets_path, params: { ticket: valid_attributes.merge(assigned_to_id: support.id) }
        }.to change(Ticket, :count).by(1)

        expect(Ticket.last.assigned_to).to eq(support)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        sign_in user
        post tickets_path, params: { ticket: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { title: 'New Title' } }

      it 'updates the requested ticket' do
        ticket = create(:ticket, user: user)
        sign_in admin

        new_attributes = { title: 'New Title' }

        put ticket_path(ticket), params: { ticket: new_attributes }
        ticket.reload

        expect(ticket.title).to eq('New Title')
      end

      it 'redirects to the ticket' do
        ticket = create(:ticket, user: user)
        sign_in admin
        new_attributes = { title: 'New Title' }

        put ticket_path(ticket), params: { id: ticket.to_param, ticket: new_attributes }
        expect(response).to redirect_to(ticket)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested ticket' do
      ticket = create(:ticket, user: user)
      sign_in admin

      expect {
        delete ticket_path(ticket)
      }.to change(Ticket, :count).by(-1)
    end

    it 'redirects to the tickets list' do
      ticket = create(:ticket, user: user)
      sign_in admin
      delete ticket_path(ticket), params: { id: ticket.to_param }
      expect(response).to redirect_to(tickets_url)
    end
  end

end
