module EnterprisesHelper
  def enterprise_breadcrumb(ep = nil)
    bc = "<ul class=\"uk-breadcrumb\">
          <li>#{link_to t('activerecord.models.enterprise.other'), enterprises_path}</li>
          <li>"

    if ep
      bc << ep.name
    else
      bc << t('helpers.add', model: t('activerecord.models.enterprise.one'))
    end

    bc << '</li></ul>'

    bc
  end

  def setup_enterprise(enterprise)
    enterprise.build_address unless enterprise.address
    enterprise.build_director unless enterprise.director

    enterprise
  end
end