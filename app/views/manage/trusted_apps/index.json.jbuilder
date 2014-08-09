json.array!(@trusted_apps) do |trusted_app|
  json.extract! trusted_app, :id, :app_name, :description, :sha_hash
  json.url trusted_app_url(trusted_app, format: :json)
end
