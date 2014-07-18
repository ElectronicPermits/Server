json.array!(@permits) do |permit|
  json.extract! permit, :id, :permit_number, :permit_expiration_date, :training_completion_date, :status, :valid, :beacon_id
  json.url permit_url(permit, format: :json)
end
