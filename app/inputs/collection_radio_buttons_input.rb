class CollectionRadioButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def input_html_classes
    super.push('uk-radio')
  end
end