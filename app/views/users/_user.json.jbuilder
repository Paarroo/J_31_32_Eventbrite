json.extract! user, :id, :first_name, :last_name, :description, :email, :encrypted_password, :created_at, :updated_at
json.url user_url(user, format: :json)
