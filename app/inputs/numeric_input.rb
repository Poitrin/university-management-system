class NumericInput < SimpleForm::Inputs::NumericInput
  def input_html_classes
    super.push('uk-input')
  end
end