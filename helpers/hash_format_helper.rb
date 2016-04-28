module HashFormatHelper
  # These methods add classes to the HTML structure that are defined in Bootstrap (and can be defined for other CSS frameworks)
  def format_hash(hash, html = '')
    hash.each do |key, value|
      next if value.blank?
      if value.is_a?(String) || value.is_a?(Numeric)
        html += content_tag(:ul, class: 'list-group') {
          ul_contents = ''
          ul_contents << content_tag(:li, content_tag(:h3, key.to_s.underscore.humanize.titleize), class: 'list-group-item')
          ul_contents << content_tag(:li, value, class: 'list-group-item')

          ul_contents.html_safe
        }
      elsif value.is_a?(Hash)
        html += content_tag(:ul, class: 'list-group') {
          ul_contents = ''
          ul_contents << content_tag(:li, content_tag(:h3, key.to_s.underscore.humanize.titleize), class: 'list-group-item')
          inner = content_tag(:li, format_hash(value), class: 'list-group-item')
          ul_contents << inner

          ul_contents.html_safe
        }
      elsif value.is_a?(Array)
        html += format_array(value)
      else
        Rails.logger.info "Unexpected value in format_hash: #{value.inspect}"
        Rails.logger.info "value type: #{value.class.name}"
      end
    end
    html.html_safe
  end

  def format_array(array, html = '')
    array.each do |value|
      if value.is_a?(String)
        html += content_tag(:div, value).html_safe
      elsif value.is_a?(Hash)
        html += format_hash(value)
      elsif value.is_a?(Array)
        html += format_array(value)
      else
        Rails.logger.info "Unexpected value in format_array: #{value.inspect}"
        Rails.logger.info "value type: #{value.class.name}"
      end
    end
    html
  end
end
