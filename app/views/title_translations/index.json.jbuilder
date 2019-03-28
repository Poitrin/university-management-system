json.array!(@title_translations) do |title_translation|
  json.extract! title_translation, :id, :title_id, :lang_id, :title_short, :title_long
  json.url title_translation_url(title_translation, format: :json)
end
