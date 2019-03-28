require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test 'import Student with localized values' do
    student_attributes = {
        title_localized: 'Madame',
        first_name: 'Lena',
        last_name: 'Meyer',
        birth_name: 'Müller',
        birth_date: '18.10.1993',
        nationality_localized: 'France',
        second_nationality_localized: 'Deutschland',
        private_email: 'lena.meyer@gmx.de',
        private_fixed_line: '0492859283',
        private_cell_phone: '0193749',
        business_email: 'lena.business.meyer@great.com',
        business_fixed_line: '0394849234',
        business_cell_phone: '02838419404',
        diplomas_attributes: [
            {
                degree_localized: 'Licence',
                study_program_localized: 'Informatique',
                # promotion ?
                studies_start: '01.09.2011',
                studies_end: '30.09.2014',
                matriculation_number: '10492849',
            }
        ]
    }
    student = Student.new(student_attributes)
    validation_status = student.valid?
    assert validation_status
  end
end
