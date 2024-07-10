# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Czyszczenie bazy danych
puts "Clearing database ..."
Ticket.destroy_all
User.destroy_all

# Tworzenie użytkowników
puts "Create users..."
user1 = User.create!(
  email: 'user1@example.com',
  password: 'password123',
  name: 'Jan Kowalski',
  role: :user
)

user2 = User.create!(
  email: 'user2@example.com',
  password: 'password123',
  name: 'Anna Nowak',
  role: :support
)
user3 = User.create!(
  email: 'user3@example.com',
  password: 'password123',
  name: 'Tech Support',
  role: :support
)

user4 = User.create!(
  email: 'admin@example.com',
  password: 'adminpass',
  name: 'Admin',
  role: :admin
)

users = [user1, user2, user3, user4]

# Tworzenie zgłoszeń
puts "Tworzenie zgłoszeń..."
statuses = ['open', 'assigned', 'in_progress', 'resolved', 'closed']
priorities = ['low', 'medium', 'high', 'urgent']

20.times do |i|
  Ticket.create!(
    title: "Zgłoszenie #{i+1}",
    description: "To jest opis zgłoszenia numer #{i+1}.",
    status: statuses.sample,
    priority: priorities.sample,
    user: users.sample
  )
end

puts "Seed zakończony pomyślnie!"
puts "Utworzono #{User.count} użytkowników i #{Ticket.count} zgłoszeń."
