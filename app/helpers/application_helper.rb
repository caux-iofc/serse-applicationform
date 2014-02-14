module ApplicationHelper

  # Override error_messages_for to make error messages prettier
  def error_messages_for(*params)
    options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          html[key] = 'errorExplanation'
        end 
      end 

      header_message = "Error!"
      header_message = options[:header_message] if options.has_key?(:header_message)
      error_messages = raw(objects.map { |object|
        object.errors.each_with_index.map {|msg|
          # If the translation field is deliberately empty, do not print it
          if (I18n.t(msg[0]) != '') then
            content_tag(:li, raw("<strong>") + I18n.t(msg[0].to_s.gsub(/\./,'_')) + raw('</strong> ') + msg[1])
          else
            content_tag(:li, msg[1])
          end
        } 
      }.join(''))

      content_tag(:table,
        content_tag(:tr,
          content_tag(:td,
            content_tag(:div,
                  content_tag(:h2, header_message) +
                      content_tag(:ul, error_messages), :id => 'errorExplanation'

            ), :align => 'center'
          )   
        ), :width => '100%'
      )   
    else
      ''  
    end 
  end 

  # Rails 3.1.3 (really!) still does not wrap the date_select form helper in a
  # field_with_errors div when it fails validation. Seriously, this is somewhat incredible. 
  # This is a workaround. 
  # Ward, 2012-02-08
  # Note - for Ruby 1.9, you'll need to modify to class: "field_with_errors"
  # Cf. http://luke.carrier.im/2011/08/rails-3-0-select-tags-and-field_with_errors/
  def field_with_errors(object, method, &block)
    if block_given? then
      if object.errors[method].empty? then
        concat capture(&block)
      else
        concat content_tag(:div, capture(&block), :class => "field_with_errors")
      end
    end
  end
  
end
