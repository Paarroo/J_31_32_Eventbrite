class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_one :payment, dependent: :destroy

  validates :user_id, uniqueness: { scope: :event_id, message: "est déjà inscrit à cet événement" }
  validates :payment_status, inclusion: { in: %w[pending succeeded failed free] }

  after_create :send_notification_to_event_creator, if: :payment_succeeded_or_free?



  def payment_succeeded?
    payment_status == 'succeeded'
  end

  def payment_pending?
    payment_status == 'pending'
  end

  def free_event?
    payment_status == 'free'
  end

  def payment_succeeded_or_free?
    payment_succeeded? || free_event?
  end

  def amount_paid_in_euros
    return 0 if amount_paid.nil?
    amount_paid / 100.0
  end

  def status_badge_class
    case payment_status
    when 'succeeded' then 'is-success'
    when 'free' then 'is-info'
    when 'pending' then 'is-warning'
    when 'failed' then 'is-danger'
    else 'is-light'
    end
  end

  def status_text
    case payment_status
    when 'succeeded' then 'Payé'
    when 'free' then 'Gratuit'
    when 'pending' then 'En attente'
    when 'failed' then 'Échec'
    else 'Inconnu'
    end
  end

  private

  def send_notification_to_event_creator
    EventMailer.new_participant_email(self).deliver_later
  end
end
