# this module is used by the person model and the enterprise model
# both models have ContactDetail objects attributed
# this module provides the necessary functionality
# to read and write private/business email/fixed line/cell phone/fax data

module ContactDetailsHelper
  def business_email
    get_value_with_method_name(__method__)
  end

  def business_email=(value)
    set_value_with_method_name(__method__, value)
  end

  def business_fixed_line
    get_value_with_method_name(__method__)
  end

  def business_fixed_line=(value)
    set_value_with_method_name(__method__, value)
  end

  # ----------------------------------------------------

  private
  # gets called from methods (private_email, business_cell_phone, etc.)
  #
  def get_value_with_method_name(method_name)
    get_contact_detail_value(hash_from_method_name(method_name))
  end

  # returns hash. :business is boolean, :category is EMAIL, CELL_PHONE, ...
  def hash_from_method_name(method_name)
    business, category = method_name.to_s.upcase.split('_', 2)
    {business: business == 'BUSINESS', category: category.gsub(/=$/, '')}
  end

  # returns value of ContactDetail object, or nil
  def get_contact_detail_value(hash)
    contact_detail = get_contact_detail(hash[:business], hash[:category])
    contact_detail.value if contact_detail
  end

  # returns ContactDetail object for business (true/false) and category (PHONE, ...)
  def get_contact_detail(business, category)
    contact_details.find_by(business: business, category: category)
  end

  def set_value_with_method_name(method_name, value)
    set_contact_detail(hash_from_method_name(method_name), value)
  end

  def set_contact_detail(hash, value)
    contact_detail = get_contact_detail(hash[:business], hash[:category])

    if contact_detail
      # already exists? update!
      contact_detail.value = value
    else
      # add a new one
      self.contact_details_attributes =
          {contact_detail:
               {category: hash[:category],
                business: hash[:business],
                value: value
               }
          }
    end
  end
end
