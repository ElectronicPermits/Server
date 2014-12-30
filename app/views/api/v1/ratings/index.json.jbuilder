json.array!(@ratings) do |rating|
  json.extract! rating, :id, :rating, :comments
  json.url api_v1_rating_url(rating, format: :json)
end
