module InternshipsHelper
  def internship_breadcrumb(internship = nil)
    bc = "<ul class=\"uk-breadcrumb\">
          <li>#{link_to t('activerecord.models.internship.other'), internships_path}</li>
          <li>"

    if internship
    bc << internship.student.full_name << ', ' << internship.enterprise.name
    else
      bc << t('helpers.add', model: t('activerecord.models.internship.one'))
    end

    bc << '</li></ul>'

    bc
  end

  def setup_internship(internship)
    internship.build_university_supervisor unless internship.university_supervisor
    internship.build_enterprise_supervisor unless internship.enterprise_supervisor
    internship.build_address unless internship.address

    internship.build_enterprise unless internship.enterprise
    # internship.enterprise.build_address unless internship.enterprise.address
    internship.build_student unless internship.student

    internship
  end

  def status(type, ok, date, person)
    case ok
      when true
        '<p><span class="uk-label uk-label-success">' +
            t('activerecord.attributes.internship.' + type + '_status.' + ok.to_s, date: l(date), person: person) +
            '</span></p>'
      when false
        '<p><span class="uk-label uk-label-danger">' +
            t('activerecord.attributes.internship.' + type + '_status.' + ok.to_s, date: l(date), person: person) +
            '</span></p>'
      else
        '<p><span class="uk-label uk-label-default">' + t('internships.show.unvalidated') + '</span></p>'
    end
  end
end
