class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.references :attendance, null: true, foreign_key: true


      t.string :stripe_checkout_session_id, null: false
      t.string :stripe_payment_intent_id
      t.string :stripe_customer_id

      t.integer :amount, null: false # en centimes
      t.string :currency, default: 'eur'
      t.string :status, default: 'pending'

      t.text :stripe_metadata
      t.datetime :paid_at

      t.timestamps
    end

    add_index :payments, :stripe_checkout_session_id, unique: true
    add_index :payments, :stripe_payment_intent_id
    add_index :payments, :status
    add_index :payments, [ :user_id, :event_id ]
  end
end
