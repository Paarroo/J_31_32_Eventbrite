# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  start_date  :datetime
#  duration    :integer
#  price       :integer
#  location    :string
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_events_on_user_id  (user_id)
#

class Event < ApplicationRecord
  belongs_to :user
  has_many :attendances, dependent: :destroy
  has_many :participants, through: :attendances, source: :user

  validates :title, presence: true, length: { minimum: 5, maximum: 140 }
  validates :description, presence: true, length: { minimum: 20, maximum: 1000 }
  validates :start_date, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0, modulo: 5 }
  validates :price, presence: true, numericality: { in: 1..1000 }
  validates :location, presence: true

  validate :start_date_cannot_be_in_the_past

  def end_date
    start_date + duration.minutes
  end

  def participants_count
    attendances.count
  end

  private

  def start_date_cannot_be_in_the_past
    return unless start_date.present?

    errors.add(:start_date, "ne peut pas être dans le passé") if start_date < Date.current
  end
end
