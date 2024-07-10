class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tickets
  has_many :assigned_tickets, class_name: 'Ticket', foreign_key: 'assigned_to_id'
  has_many :comments

  enum role: {
    user: 0,
    support: 1,
    admin: 2
  }
  scope :admins_and_support, -> { where(role: [:admin, :support]) }
  scope :support, -> { where(role: :support) }

  def admin_or_support?
    admin? || support?
  end
end
