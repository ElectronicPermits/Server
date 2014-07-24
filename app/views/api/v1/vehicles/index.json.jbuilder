json.array!(@vehicles) do |vehicle|
  json.extract! vehicle, :id, :make, :model, :color, :year, :inspection_date, :license_plate
  json.url vehicle_url(vehicle, format: :json)
end
