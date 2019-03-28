module StudentsHelper
  def student_breadcrumb(student = nil)
    "<ul class='uk-breadcrumb'>
      <li>#{ link_to t('activerecord.models.student.other'), students_path }</li>
      #{student ? "<li>#{ student.full_name }</li>" : ''}
    </ul>"
  end

  # student can be "new" or contain some data, but still have validation errors
  def setup_student(student)
    # student.build_user unless student.user

    student.build_address unless student.address

    diplomas_count = student.diplomas.length
    student.diplomas.build if diplomas_count == 0 # Bachelor
    # student.diplomas.build # Master

    return student
  end
end