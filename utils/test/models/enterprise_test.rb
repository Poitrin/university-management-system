require 'test_helper'

class EnterpriseTest < ActiveSupport::TestCase
  test "no insert with empty name" do
    assert_not Enterprise.new(name: "", website: "www.google.de").save
  end

  test "insert with valid name and empty website" do
    assert Enterprise.new(name: "Google", website: "").save
  end

  test "no insert with valid name and invalid website" do
    assert_not Enterprise.new(name: "Google", website: "google").save
    assert_not Enterprise.new(name: "Google", website: "123.45").save
  end

  test "insert with valid name and valid website 1" do
    assert Enterprise.new(name: "Google", website: "www.google.de")
  end

  # test "no insert of the same enterprise name" do
  #   assert Enterprise.create(name: "Already", website: "exists.de")
  #   assert_not Enterprise.create(name: "Already", website: "exists.de")
  # end
end
