class AddValidationToEvents < ActiveRecord::Migration[8.0]
  def change
    # Système de validation des événements par les admins
    add_column :events, :validated, :boolean, default: nil
    add_column :events, :reviewed, :boolean, default: false, null: false
    add_column :events, :admin_comment, :text
    add_column :events, :validated_at, :datetime
    add_column :events, :validated_by_id, :integer

    # Index pour les requêtes admin
    add_index :events, :validated
    add_index :events, :reviewed
    add_index :events, [ :validated, :reviewed ]

    # Clé étrangère vers l'admin qui a validé
    add_foreign_key :events, :users, column: :validated_by_id
  end
end
