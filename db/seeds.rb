# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Nettoyer la base
User.destroy_all
Event.destroy_all
Attendance.destroy_all

# Créer des utilisateurs de test
users = []
5.times do |i|
  users << User.create!(
    first_name: "Prénom#{i+1}",
    last_name: "Nom#{i+1}",
    email: "user#{i+1}@yopmail.com",
    password: "password123",
    password_confirmation: "password123",
    description: "Description de l'utilisateur #{i+1}"
  )
end

# Créer des événements
10.times do |i|
  Event.create!(
    title: "Événement #{i+1}",
    description: "Description détaillée de l'événement #{i+1}. Ceci est un super événement qui va vous plaire énormément !",
    start_date: Date.current + rand(1..30).days + rand(8..20).hours,
    duration: [ 60, 120, 180, 240 ].sample,
    price: rand(10..100),
    location: [ "Paris", "Lyon", "Marseille", "Toulouse", "Nice" ].sample,
    user: users.sample
  )
end

# Créer quelques participations
Event.all.each do |event|
  rand(1..3).times do
    user = users.sample
    next if event.user == user || event.participants.include?(user)

    Attendance.create!(
      user: user,
      event: event,
      stripe_customer_id: "cus_#{SecureRandom.hex(8)}"
    )
  end
end

puts "Seed terminé !"
puts "Utilisateurs créés : #{User.count}"
puts "Événements créés : #{Event.count}"
puts "Participations créées : #{Attendance.count}"
