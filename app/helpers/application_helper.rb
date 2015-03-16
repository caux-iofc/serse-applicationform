module ApplicationHelper

  # Override error_messages_for to make error messages prettier
  def error_messages_for(*params)
    object = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact.first
    if object.errors.any?
      content_tag(:div, class: "panel panel-danger") do
        concat(content_tag(:div, class: "panel-heading") do
          concat(content_tag(:h4, class: "panel-title") do
            concat "The form contains #{pluralize(object.errors.count, "error")}:"
          end)
        end)
        concat(content_tag(:div, class: "panel-body") do
          concat(content_tag(:ul) do
            object.errors.each_with_index.map do |msg|
              if (I18n.t(msg[0]) != '') then
                concat content_tag(:li, raw("<strong>") + I18n.t(msg[0].to_s.gsub(/\./,'_')) + raw('</strong> ') + msg[1])
              else
                concat content_tag(:li, msg[1])
              end
            end
          end)
        end)
      end
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
