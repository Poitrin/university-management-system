require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "Find correct title_id for title_localized" do
    p = Person.new(first_name: "Waldo", last_name: "Ceylon", business_email: 'john@john.com')
    assert p.valid?

    p.title_localized = "Monsieur"
    assert p.valid?
    assert_not_nil p.title_localized
    assert_not_nil p.title
  end

  test "Invalid title_localized" do
    p = Person.new(first_name: "Waldo", last_name: "Ceylon", business_email: 'john@john.com')
    assert p.valid?

    INVALID_TITLE_LOCALIZED = "manNoMe"
    p.title_localized = INVALID_TITLE_LOCALIZED
    assert_not p.valid?
    assert_equal INVALID_TITLE_LOCALIZED, p.title_localized # = wrong title is still saved
    assert_equal 1, p.errors.messages.count

    p.title_localized = "Madame"
    assert p.valid?
    assert_not_nil p.title_localized
    assert_not_nil p.title
  end
end
