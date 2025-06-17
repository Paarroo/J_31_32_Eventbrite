json.extract! event, :id, :title, :description, :start_date, :duration, :price, :location, :user_id, :created_at, :updated_at
json.url event_url(event, format: :json)
