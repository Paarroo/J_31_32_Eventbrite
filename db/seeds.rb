# db/seeds.rb
# ================================================================
# 🌱 SEEDS POUR EVENTBRITE - UTILISANT LES VARIABLES .ENV
# ================================================================

require 'dotenv/load' if Rails.env.development?

puts "🗑️  Nettoyage de la base de données..."

# Ordre important pour respecter les dépendances
Payment.destroy_all if defined?(Payment)
Attendance.destroy_all if defined?(Attendance)
Event.destroy_all
User.destroy_all

puts "✅ Base de données nettoyée !"

# ================================================================
# 👥 CRÉATION DES UTILISATEURS ADMIN DEPUIS .ENV
# ================================================================

puts "👥 Création des administrateurs depuis .env..."

# Vérifier que les variables d'environnement existent
required_env_vars = %w[ADMIN_EMAIL ADMIN_PASSWORD ADMIN_FIRST_NAME ADMIN_LAST_NAME]
missing_vars = required_env_vars.select { |var| ENV[var].blank? }

if missing_vars.any?
  puts "❌ Variables d'environnement manquantes dans .env :"
  missing_vars.each { |var| puts "   - #{var}" }
  puts "🔧 Création d'admins par défaut..."

  # Admin par défaut si .env incomplet
  admin = User.create!(
    first_name: "Default",
    last_name: "Admin",
    email: "admin@eventbrite.local",
    password: "password123",
    password_confirmation: "password123",
    admin: true,
    description: "Administrateur par défaut"
  )
else
  # 1. Admin principal depuis .env
  admin = User.create!(
    first_name: ENV['ADMIN_FIRST_NAME'],
    last_name: ENV['ADMIN_LAST_NAME'],
    email: ENV['ADMIN_EMAIL'],
    password: ENV['ADMIN_PASSWORD'],
    password_confirmation: ENV['ADMIN_PASSWORD'],
    admin: true,
    description: "Administrateur principal configuré via .env"
  )

  puts "✅ Admin principal créé : #{admin.email}"
end

# 2. Admin secondaire depuis .env (si défini)
if ENV['ADMIN2_EMAIL'].present?
  admin2 = User.create!(
    first_name: ENV['ADMIN2_FIRST_NAME'] || 'Admin',
    last_name: ENV['ADMIN2_LAST_NAME'] || 'Secondaire',
    email: ENV['ADMIN2_EMAIL'],
    password: ENV['ADMIN2_PASSWORD'] || ENV['ADMIN_PASSWORD'],
    password_confirmation: ENV['ADMIN2_PASSWORD'] || ENV['ADMIN_PASSWORD'],
    admin: true,
    description: "Administrateur secondaire configuré via .env"
  )

  puts "✅ Admin secondaire créé : #{admin2.email}"
end

# ================================================================
# 👥 CRÉATION DES UTILISATEURS DE TEST
# ================================================================

puts "👥 Création des utilisateurs de test..."

# Organisateurs d'événements
organisateur1 = User.create!(
  first_name: "Jean",
  last_name: "Martin",
  email: "jean.martin@gmail.com",
  password: "password123",
  password_confirmation: "password123",
  admin: false,
  description: "Organisateur d'événements tech et conférences."
)

organisateur2 = User.create!(
  first_name: "Sophie",
  last_name: "Lemoine",
  email: "sophie.lemoine@outlook.com",
  password: "password123",
  password_confirmation: "password123",
  admin: false,
  description: "Spécialisée dans l'organisation d'événements culturels."
)

organisateur3 = User.create!(
  first_name: "Alexandre",
  last_name: "Petit",
  email: "alex.petit@yahoo.fr",
  password: "password123",
  password_confirmation: "password123",
  admin: false,
  description: "Organisateur d'événements sportifs et de bien-être."
)

# Participants réguliers
10.times do |i|
  User.create!(
    first_name: "User#{i+1}",
    last_name: "Test",
    email: "user#{i+1}@test.com",
    password: "password123",
    password_confirmation: "password123",
    admin: false,
    description: "Utilisateur de test #{i+1}"
  )
end

puts "✅ #{User.count} utilisateurs créés !"
puts "   - #{User.where(admin: true).count} administrateurs"
puts "   - #{User.where(admin: false).count} utilisateurs normaux"

# ================================================================
# 🎉 CRÉATION DES ÉVÉNEMENTS (version simplifiée)
# ================================================================

puts "🎉 Création des événements..."

# Événements validés à venir
upcoming_events = [
  {
    title: "Hackathon IA & Santé",
    description: "48h pour développer des solutions innovantes alliant IA et Santé.",
    user: organisateur1,
    start_date: 2.weeks.from_now,
    duration: 2880,
    price: 25.0,
    location: "Station F, Paris",
    validated: true,
    validated_by: admin,
    validated_at: 1.week.ago
  },
  {
    title: "Concert Jazz Fusion",
    description: "Soirée jazz avec le quartet 'Fusion Elements'.",
    user: organisateur2,
    start_date: 10.days.from_now,
    duration: 180,
    price: 35.0,
    location: "Le Blue Note, Paris",
    validated: true,
    validated_by: admin,
    validated_at: 4.days.ago
  },
  {
    title: "Formation WordPress Avancée",
    description: "Maîtrisez WordPress comme un pro.",
    user: organisateur1,
    start_date: 3.weeks.from_now,
    duration: 360,
    price: 120.0,
    location: "École du Web, Paris",
    validated: true,
    validated_by: admin,
    validated_at: 1.day.ago
  }
]

# Événements en attente
pending_events = [
  {
    title: "Conférence Blockchain",
    description: "Découvrez l'avenir de la finance décentralisée.",
    user: organisateur1,
    start_date: 5.weeks.from_now,
    duration: 300,
    price: 75.0,
    location: "Palais des Congrès, Nice",
    validated: nil
  },
  {
    title: "Atelier Cuisine Moléculaire",
    description: "Initiez-vous aux techniques de cuisine moléculaire.",
    user: organisateur2,
    start_date: 6.weeks.from_now,
    duration: 180,
    price: 95.0,
    location: "Institut Culinaire de Lyon",
    validated: nil
  }
]

# Créer tous les événements
all_events = upcoming_events + pending_events
all_events.each do |event_data|
  Event.create!(event_data)
end

puts "✅ #{Event.count} événements créés !"

puts "🎫 Création des participations..."

Event.where(validated: true).each do |event|
  participants_count = rand(3..10)
  available_users = User.where(admin: false).where.not(id: event.user.id)
  participants = available_users.sample(participants_count)

  participants.each do |participant|
    # Déterminer le payment_status selon le prix de l'événement
    payment_status = if event.price == 0
      'free'  # Événement gratuit
    else
      # 90% de chance d'être payé, 10% en attente
      rand(1..10) <= 9 ? 'succeeded' : 'pending'
    end

    attendance = Attendance.create!(
      user: participant,
      event: event,
      payment_status: payment_status,
      amount_paid: event.price > 0 ? (event.price * 100).to_i : 0, # En centimes
      created_at: rand(1.week.ago..Time.current)
    )

    # Créer un paiement si nécessaire
    if event.price > 0 && payment_status == 'succeeded'
      Payment.create!(
        attendance: attendance,
        amount: (event.price * 100).to_i, # En centimes
        status: 'succeeded',
        stripe_payment_intent_id: "pi_test_#{SecureRandom.hex(8)}",
        created_at: attendance.created_at
      )
    end
  end
end

puts "✅ #{Attendance.count} participations créées !"
puts "   - #{Attendance.where(payment_status: [ 'succeeded', 'free' ]).count} confirmées"
puts "   - #{Attendance.where(payment_status: 'pending').count} en attente"



puts "\n" + "="*60
puts "🎉 SEEDS TERMINÉS AVEC SUCCÈS !"
puts "="*60

puts "\n📊 STATISTIQUES :"
puts "   👥 Utilisateurs : #{User.count}"
puts "   🎉 Événements : #{Event.count}"
puts "   🎫 Participations : #{Attendance.count}"

puts "\n🔐 COMPTES ADMIN (depuis .env) :"
User.where(admin: true).each do |admin_user|
  puts "   📧 Email : #{admin_user.email}"
  puts "   👤 Nom : #{admin_user.full_name}"
end
puts "   🔑 Mot de passe : #{ENV['ADMIN_PASSWORD'] || 'password123'}"
puts "   🌐 URL : #{ENV['APP_URL'] || 'http://localhost:3000'}/admin/login"

puts "\n✨ Votre application est prête !"
puts "="*60
