class BooleanInput < SimpleForm::Inputs::BooleanInput
  def input_html_classes
    super.push('uk-checkbox')
  end

  # Get the following appearance:
  #
  #   [X] (label_text)
  #
  # (no label on top, but besides checkbox)
  def inline_label
    " #{label_text}".html_safe
  end

  def label
    false
  end
end