json.array!(@service_types) do |service_type|
  json.extract! service_type, :id, :name, :description
  json.url api_v1_service_type_url(service_type, format: :json)
end
