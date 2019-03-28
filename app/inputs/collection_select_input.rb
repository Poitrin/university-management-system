class CollectionSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input_html_classes
    # add a class to all the select fields
    super.push('uk-select')
  end
end