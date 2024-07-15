require 'rails_helper'

RSpec.describe "tickets/show", type: :view do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:ticket) { create(:ticket, user: user) }

  before(:each) do
    assign(:ticket, ticket)
    allow(view).to receive(:can?).and_return(true)
  end

  it "renders ticket attributes" do
    render
    expect(rendered).to match(/#{ticket.title}/)
    expect(rendered).to match(/#{ticket.status}/)
    expect(rendered).to match(/#{ticket.user.email}/)
    expect(rendered).to match(/#{l(ticket.created_at, format: :long)}/)
    expect(rendered).to match(/#{l(ticket.updated_at, format: :long)}/)
  end

  it "renders edit link when user can update" do
    render
    expect(rendered).to have_link('Edytuj', href: edit_ticket_path(ticket))
  end

  it "does not render edit link when user cannot update" do
    allow(view).to receive(:can?).with(:update, ticket).and_return(false)
    render
    expect(rendered).not_to have_link('Edytuj')
  end
end
