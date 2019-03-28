json.array!(@countries) do |country|
  json.extract! country, :id, :id
  json.url country_url(country, format: :json)
end
