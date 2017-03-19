json.extract! schedule, :id, :salon_id, :start_time, :end_time, :recruitment_numbers, :notes, :created_at, :updated_at
json.url schedule_url(schedule, format: :json)
