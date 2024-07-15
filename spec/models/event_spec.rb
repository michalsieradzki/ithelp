require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:ticket) { create(:ticket) }
  let(:user) { create(:user) }

  it "is valid with valid attributes" do
    event = Event.new(
      ticket: ticket,
      user: user,
      action_type: Event::STATUS_CHANGE
    )
    expect(event).to be_valid
  end

  it "is invalid without action_type" do
    event = Event.new(
      ticket: ticket,
      user: user
    )
    expect(event).not_to be_valid
    expect(event.errors[:action_type]).to include("nie może być puste")
  end
end
