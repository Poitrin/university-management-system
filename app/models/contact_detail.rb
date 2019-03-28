class ContactDetail < ActiveRecord::Base
  validates :value, presence: true
  validates :category, presence: true

  scope :private_email, -> { where(business: false, category: 'EMAIL') }
  scope :business_email, -> { where(business: true, category: 'EMAIL') }

  scope :private_fixed_line, -> { where(business: false, category: 'FIXED_LINE') }
  scope :business_fixed_line, -> { where(business: true, category: 'FIXED_LINE') }

  scope :private_cell_phone, -> { where(business: false, category: 'CELL_PHONE') }
  scope :business_cell_phone, -> { where(business: true, category: 'CELL_PHONE') }

  scope :business_fax, -> { where(business: true, category: 'FAX') }


end
