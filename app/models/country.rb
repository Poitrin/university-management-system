class Country < ActiveRecord::Base
  scope :registration_countries, -> { where(id: %w(DE FR)) }

  self.primary_key = 'id'

  validates :id, presence: true
  validates :id, uniqueness: true

  validates :name_de, presence: true
  validates :name_fr, presence: true
  validates :name_en, presence: true

  def name_localized(locale = I18n.locale)
    send("name_#{locale}")
  end

  def self.get_id_for_name_localized(name_localized)
    return nil if name_localized.blank?

    countries = Country.arel_table
    query = countries.project(countries[:id]) \
      .where(countries[:name_de].matches(name_localized) \
      .or(countries[:name_fr].matches(name_localized)) \
      .or(countries[:name_en].matches(name_localized)) \
      .or(countries[:id].matches(name_localized))) # it could happen that it's already the ISO code

    return Country.find_by_sql(query.to_sql).first.try(:id)
  end
end

