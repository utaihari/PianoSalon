json.extract! reservation, :id, :user_id, :schedule_id, :condition, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
