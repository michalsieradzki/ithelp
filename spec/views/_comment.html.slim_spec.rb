require 'rails_helper'

RSpec.describe "comments/_comment", type: :view do
  let(:user) { create(:user) }
  let(:ticket) { create(:ticket) }
  let(:comment) { create(:comment, user: user, ticket: ticket, body: "Comment content") }

  before do
    allow(view).to receive(:can?).and_return(true)
    assign(:ticket, ticket)
  end

  it "render comment content" do
    render partial: "comments/comment", locals: { comment: comment, ticket: ticket }
    expect(rendered).to include("Comment content")
  end

  it "show user name" do
    render partial: "comments/comment", locals: { comment: comment, ticket: ticket }
    expect(rendered).to include(user.name.to_s)
  end

  it "contain delete button" do
    render partial: "comments/comment", locals: { comment: comment, ticket: ticket }
    expect(rendered).to have_button('X')
  end
end
