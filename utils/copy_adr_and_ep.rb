ActiveRecord::Base.transaction do
  Address.where('type = 1
AND intermediary IS NOT NULL
AND street IS NOT NULL
AND postalCode IS NOT NULL
AND city IS NOT NULL
AND country IS NOT NULL').each do |address|
    Enterprise.create!(name: address.intermediary,
                       is_validated: true,
                       address_attributes: {city: address.city,
                                            country: address.country, postalCode: address.postalCode,
                                            street: address.street, type: address.type})
    # break
  end
end