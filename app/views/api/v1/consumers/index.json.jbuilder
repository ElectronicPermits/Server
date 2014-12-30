json.array!(@consumers) do |consumer|
  json.extract! consumer, :id, :unique_user_id
  json.url api_v1_consumer_url(consumer, format: :json)
end
