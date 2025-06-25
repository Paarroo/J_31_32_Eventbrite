class AddStripeFieldsToAttendances < ActiveRecord::Migration[8.0]
  def change
    # ID de la session Stripe Checkout
    add_column :attendances, :stripe_checkout_session_id, :string

    add_column :attendances, :stripe_payment_intent_id, :string

    add_column :attendances, :payment_status, :string, default: 'pending'

    add_column :attendances, :amount_paid, :integer

    add_column :attendances, :paid_at, :datetime

    # Index pour améliorer les performances des requêtes
    add_index :attendances, :stripe_checkout_session_id
    add_index :attendances, :stripe_payment_intent_id
    add_index :attendances, :payment_status
  end
end
