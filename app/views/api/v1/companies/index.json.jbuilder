json.array!(@companies) do |company|
  json.extract! company, :id, :name, :average_rating, :phone_number
  json.url company_url(company, format: :json)
end
