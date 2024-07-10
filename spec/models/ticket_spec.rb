require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      ticket = Ticket.new(
        title: 'Test Ticket',
        description: 'This is a test ticket',
        status: 'open',
        priority: 'medium',
        user: user
      )
      expect(ticket).to be_valid
    end

    it 'is not valid without a title' do
      ticket = Ticket.new(title: nil)
      expect(ticket).to_not be_valid
    end

    it 'is not valid without a description' do
      ticket = Ticket.new(description: nil)
      expect(ticket).to_not be_valid
    end

    it 'is not valid without a status' do
      ticket = Ticket.new(status: nil)
      expect(ticket).to_not be_valid
    end

    it 'is not valid without a priority' do
      ticket = Ticket.new(priority: nil)
      expect(ticket).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'enums' do
    it 'defines the correct statuses' do
      expect(Ticket.statuses.keys).to match_array(['open', 'assigned', 'in_progress', 'resolved', 'closed'])
    end

    it 'defines the correct priorities' do
      expect(Ticket.priorities.keys).to match_array(['low', 'medium', 'high', 'urgent'])
    end
  end
end
