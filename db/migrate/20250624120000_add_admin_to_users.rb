class AddAdminToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean, default: false, null: false
    add_index :users, :admin

    # Créer le premier admin si aucun n'existe
    reversible do |dir|
      dir.up do
        if User.count > 0 && !User.where(admin: true).exists?
          first_user = User.first
          first_user.update!(admin: true)
          puts "✅ Premier utilisateur (#{first_user.email}) défini comme admin"
        end
      end
    end
  end
end
