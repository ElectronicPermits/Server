json.array!(@people) do |person|
  json.extract! person, :id, :first_name, :middle_name, :last_name, :date_of_birth, :race, :sex, :height, :weight, :phone_number
  json.url api_v1_person_url(person, format: :json)
end
