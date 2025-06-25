# lib/tasks/admin.rake
namespace :admin do
  desc "Créer un admin depuis les variables d'environnement"
  task create: :environment do
    require 'dotenv/load' if Rails.env.development?

    puts "🔐 Création d'un admin depuis .env..."

    # Vérifier les variables requises
    email = ENV['ADMIN_EMAIL']
    password = ENV['ADMIN_PASSWORD']
    first_name = ENV['ADMIN_FIRST_NAME']
    last_name = ENV['ADMIN_LAST_NAME']

    if [ email, password, first_name, last_name ].any?(&:blank?)
      puts "❌ Variables manquantes dans .env :"
      puts "   ADMIN_EMAIL, ADMIN_PASSWORD, ADMIN_FIRST_NAME, ADMIN_LAST_NAME"
      exit 1
    end

    # Vérifier si l'admin existe déjà
    if User.exists?(email: email)
      puts "⚠️  Un utilisateur avec cet email existe déjà : #{email}"
      user = User.find_by(email: email)

      if user.admin?
        puts "✅ L'utilisateur est déjà admin"
      else
        user.update!(admin: true)
        puts "✅ Utilisateur promu admin : #{email}"
      end
    else
      # Créer le nouvel admin
      admin = User.create!(
        email: email,
        password: password,
        password_confirmation: password,
        first_name: first_name,
        last_name: last_name,
        admin: true,
        description: "Administrateur créé via tâche Rake"
      )

      puts "✅ Nouvel admin créé : #{admin.email}"
    end
  end

  desc "Lister tous les admins"
  task list: :environment do
    puts "👥 Liste des administrateurs :"

    admins = User.where(admin: true)

    if admins.empty?
      puts "   Aucun administrateur trouvé"
    else
      admins.each_with_index do |admin, index|
        puts "   #{index + 1}. #{admin.email} - #{admin.full_name}"
        puts "      Créé le : #{admin.created_at.strftime('%d/%m/%Y à %H:%M')}"
      end
    end
  end

  desc "Promouvoir un utilisateur admin par email"
  task :promote, [ :email ] => :environment do |task, args|
    email = args[:email]

    if email.blank?
      puts "❌ Usage: rails admin:promote[email@example.com]"
      exit 1
    end

    user = User.find_by(email: email)

    if user.nil?
      puts "❌ Utilisateur introuvable : #{email}"
      exit 1
    end

    if user.admin?
      puts "⚠️  L'utilisateur est déjà admin : #{email}"
    else
      user.update!(admin: true)
      puts "✅ Utilisateur promu admin : #{email}"
    end
  end

  desc "Révoquer les droits admin d'un utilisateur"
  task :demote, [ :email ] => :environment do |task, args|
    email = args[:email]

    if email.blank?
      puts "❌ Usage: rails admin:demote[email@example.com]"
      exit 1
    end

    user = User.find_by(email: email)

    if user.nil?
      puts "❌ Utilisateur introuvable : #{email}"
      exit 1
    end

    if !user.admin?
      puts "⚠️  L'utilisateur n'est pas admin : #{email}"
    else
      # Vérifier qu'il reste au moins un admin
      if User.where(admin: true).count <= 1
        puts "❌ Impossible de révoquer : il doit rester au moins un admin"
        exit 1
      end

      user.update!(admin: false)
      puts "✅ Droits admin révoqués : #{email}"
    end
  end

  desc "Réinitialiser le mot de passe d'un admin"
  task :reset_password, [ :email ] => :environment do |task, args|
    email = args[:email]

    if email.blank?
      puts "❌ Usage: rails admin:reset_password[email@example.com]"
      exit 1
    end

    user = User.find_by(email: email)

    if user.nil?
      puts "❌ Utilisateur introuvable : #{email}"
      exit 1
    end

    if !user.admin?
      puts "❌ L'utilisateur n'est pas admin : #{email}"
      exit 1
    end

    new_password = ENV['ADMIN_PASSWORD'] || 'TempPassword123!'
    user.update!(
      password: new_password,
      password_confirmation: new_password
    )

    puts "✅ Mot de passe réinitialisé pour : #{email}"
    puts "   Nouveau mot de passe : #{new_password}"
  end
end
