# == Schema Information
#
# Table name: attendances
#
#  id                 :integer          not null, primary key
#  stripe_customer_id :string
#  user_id            :integer          not null
#  event_id           :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_attendances_on_event_id  (event_id)
#  index_attendances_on_user_id   (user_id)
#

class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event_id }

  after_create :send_notification_to_event_creator

  private

  def send_notification_to_event_creator
    EventMailer.new_participant_email(self).deliver_now
  end
end
