require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:ticket) { create(:ticket) }

  it "jest ważny z poprawnymi atrybutami" do
    comment = Comment.new(
      body: "To jest treść komentarza",
      user: user,
      ticket: ticket
    )
    expect(comment).to be_valid
  end

  it "jest nieważny bez treści" do
    comment = Comment.new(user: user, ticket: ticket)
    expect(comment).to_not be_valid
  end

  it "jest nieważny bez użytkownika" do
    comment = Comment.new(body: "Treść", ticket: ticket)
    expect(comment).to_not be_valid
  end

  it "jest nieważny bez ticketu" do
    comment = Comment.new(body: "Treść", user: user)
    expect(comment).to_not be_valid
  end

  it "należy do użytkownika" do
    association = described_class.reflect_on_association(:user)
    expect(association.macro).to eq :belongs_to
  end

  it "należy do ticketu" do
    association = described_class.reflect_on_association(:ticket)
    expect(association.macro).to eq :belongs_to
  end
end
