require 'test_helper'

class DiplomaTest < ActiveSupport::TestCase
  test 'get_id_for_study_program_localized' do
    [
        ['Betriebswirtschaftslehre', 'BWL', 'Sciences de Gestion'],
        ['infoRmatiK', 'InfOrmAtique', 'computer scIENCE'],
        ['Logistique', 'Logistik'],
        ['génie électrique', 'Elektrotechnik']
    ].each do |study_program_names|
      study_program_id = nil
      study_program_names.each do |study_program|
        if study_program_id
          assert_equal study_program_id, StudyProgram.get_id_for_study_program_localized(study_program)
        else
          study_program_id = StudyProgram.get_id_for_study_program_localized(study_program)
          assert_not_nil study_program_id
        end
      end
    end
  end
end
