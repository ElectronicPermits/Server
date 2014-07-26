json.array!(@violations) do |violation|
  json.extract! violation, :id, :name, :description, :ordinance, :issue_date, :closed
  json.url violation_url(violation, format: :json)
end
