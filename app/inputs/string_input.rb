class StringInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('uk-input')
  end
end