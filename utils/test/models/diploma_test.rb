require 'test_helper'

class DiplomaTest < ActiveSupport::TestCase
  test 'get_id_for_degree_localized' do
    [
        ['Bachelor', 'B'],
        ['Licence', 'B'],
        ['bAchELoR', 'B'],
        ['LiCencE', 'B'],
        ['Master', 'M'],
        ['mastER', 'M'],
        ['maaaaaasteR', nil],
        ['01234', nil],
        [nil, nil]
    ].each do |degree|
      assert_equal degree[1], Diploma.get_id_for_degree_localized(degree[0])
    end
  end

  test 'localized values' do

  end
end
