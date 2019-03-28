module ApplicationHelper
  def normalize_string(unnormalized_name)
    return '' unless unnormalized_name
    I18n.transliterate(unnormalized_name.downcase).gsub(/\W/, '')
  end

  def insert_add_button(items)
    items.unshift(nil)
  end
end
