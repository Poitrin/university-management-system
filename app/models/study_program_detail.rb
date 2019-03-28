class StudyProgramDetail < ActiveRecord::Base
  belongs_to :study_program, required: false
end
