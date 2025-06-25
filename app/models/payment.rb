class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :attendance, optional: true

  validates :stripe_checkout_session_id, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[pending processing succeeded failed canceled] }

  scope :succeeded, -> { where(status: 'succeeded') }
  scope :pending, -> { where(status: 'pending') }
  scope :failed, -> { where(status: 'failed') }

  def succeeded?
    status == 'succeeded'
  end

  def pending?
    status == 'pending'
  end

  def failed?
    status == 'failed'
  end

  def amount_in_euros
    amount / 100.0
  end

  def mark_as_succeeded!
    ActiveRecord::Base.transaction do
      update!(
        status: 'succeeded',
        paid_at: Time.current
      )

      create_attendance_if_needed!
    end
  end

  def mark_as_failed!
    update!(status: 'failed')
    attendance&.destroy
  end

  private

  def create_attendance_if_needed!
    return if attendance.present?

    self.attendance = Attendance.create!(
      user: user,
      event: event,
      stripe_customer_id: stripe_customer_id,
      payment_status: 'succeeded',
      amount_paid: amount,
      paid_at: paid_at
    )

    save!
  end
end
