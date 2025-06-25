# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user
  belongs_to :validated_by, class_name: 'User', optional: true
  has_many :attendances, dependent: :destroy
  has_many :payments, through: :attendances


  # Participants confirmés (payé ou gratuit)
  has_many :confirmed_attendances, -> { where(payment_status: [ 'succeeded', 'free' ]) },
           class_name: 'Attendance'

  has_many :confirmed_participants, through: :confirmed_attendances, source: :user

  # Participants en attente de paiement
  has_many :pending_attendances, -> { where(payment_status: 'pending') },
           class_name: 'Attendance'

  has_many :pending_participants, through: :pending_attendances, source: :user

  # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :start_date, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true

  # Scopes pour la validation
  scope :pending, -> { where(validated: nil) }
  scope :validated, -> { where(validated: true) }
  scope :rejected, -> { where(validated: false) }
  scope :upcoming, -> { where('start_date > ?', Time.current) }
  scope :past, -> { where('start_date < ?', Time.current) }


  def validation_status
    case validated
    when true then "Validé"
    when false then "Refusé"
    else "En attente"
    end
  end

  def validated?
    validated == true
  end

  def rejected?
    validated == false
  end

  def pending?
    validated.nil?
  end


  # Nombre de participants confirmés
  def confirmed_participants_count
    attendances.where(payment_status: [ 'succeeded', 'free' ]).count
  end

  # Nombre de participants en attente
  def pending_participants_count
    attendances.where(payment_status: 'pending').count
  end

  # Revenus de l'événement
  def total_revenue
    attendances.where(payment_status: 'succeeded').joins(:payment).sum('payments.amount') / 100.0
  end

  # Est-ce que l'événement peut être validé ?
  def can_be_validated?
    pending? && start_date > Time.current
  end

  # Est-ce un événement gratuit ?
  def free_event?
    price == 0
  end


  def full_price_with_currency
    "#{price}€"
  end

  def formatted_start_date
    start_date.strftime("%d/%m/%Y à %H:%M")
  end

  def duration_in_hours
    duration / 60.0
  end
  def participants_count
     confirmed_participants_count
   end

  private

  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Time.current
      errors.add(:start_date, "ne peut pas être dans le passé")
    end
  end
end
