class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input_html_classes
    super.push('uk-select uk-width-auto')
  end
end