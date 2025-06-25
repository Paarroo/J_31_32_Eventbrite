class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :attended_events, through: :attendances, source: :event
  has_many :payments, dependent: :destroy


  has_many :validated_events, class_name: 'Event', foreign_key: 'validated_by_id'

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :send_welcome_email

  scope :admins, -> { where(admin: true) }
  scope :regular_users, -> { where(admin: false) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    admin
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
