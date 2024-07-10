class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :assigned_to, class_name: 'User', foreign_key: 'assigned_to_id', optional: true
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  validate :assigned_by_authorized_user

  enum status: { open: 'open', assigned: 'assigned', in_progress: 'in_progress', resolved: 'resolved', closed: 'closed' }
  enum priority: { low: 'low', medium: 'medium', high: 'high', urgent: 'urgent' }

  scope :search, ->(query) {
    where("title LIKE ? OR description LIKE ?", "%#{query}%", "%#{query}%")
  }



  private

  def assigned_by_authorized_user
    if assigned_to_id_changed? && user && !user.admin_or_support?
      errors.add(:assigned_to_id, "tylko admin lub support może przypisać zgłoszenie")
    end
  end
end
