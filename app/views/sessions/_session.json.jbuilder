json.extract! session, :id, :dates, :hall_id, :movie_id, :created_at, :updated_at
json.url session_url(session, format: :json)
