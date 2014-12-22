json.array!(@static_permissions) do |static_permission|
  json.extract! static_permission, :id, :permission_type, :target
  json.url static_permission_url(static_permission, format: :json)
end
