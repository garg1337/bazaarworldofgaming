ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /\<label/
    html_tag
  else
    errors = Array(instance.error_message).join(',&nbsp;')
    %(<div class = "error_msg">#{html_tag}<span class="validation-error">&nbsp;#{errors}</span></div>)).html_safe
  end
end