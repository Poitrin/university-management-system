class ContactPerson < Person
  validates :business_email, presence: true
end
