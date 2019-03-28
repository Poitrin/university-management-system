json.array!(@people) do |person|
  json.extract! person, :id, :title_id, :first_name, :last_name, :birth_name, :complete_name, :birth_date
  json.url person_url(person, format: :json)
end
