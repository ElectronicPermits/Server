json.array!(@app_roles) do |app_role|
  json.extract! app_role, :id, :name, :description
  json.url app_role_url(app_role, format: :json)
end
