class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :assigned_to, class_name: 'User', foreign_key: 'assigned_to_id', optional: true
  has_many :comments, dependent: :destroy
  has_many :events

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
  after_create :log_changes


  private

  def assigned_by_authorized_user
    if assigned_to_id_changed? && user && !assigned_to&.admin_or_support?
      errors.add(:assigned_to_id, "tylko admin lub support może przypisać zgłoszenie")
    end
  end

  def log_changes
    if saved_change_to_status?
      Event.log_status_change(self, status_before_last_save, status, user)
    end

    if saved_change_to_assigned_to_id?
      Event.log_assignment_change(
        self,
        User.find_by(id: assigned_to_id_before_last_save),
        assigned_to,
        user
      )
    end
  end

end
