json.array!(@ratings) do |rating|
  json.extract! rating, :id, :rating, :comments
  json.url rating_url(rating, format: :json)
end
